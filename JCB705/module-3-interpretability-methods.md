Here’s a **technical, side-by-side comparison** of the main interpretability methods you’ll see in the Module 3 “universe” (plus what people actually use in practice).

I’ll organize this as:

1. A **taxonomy** of interpretability methods (axes to compare them on)
2. A **table comparing major method families**
3. Short **technical deep dives** for each family (what it computes, assumptions, pros/cons)
4. A quick **“which method when?”** guide

---

## 1. Taxonomy: How to Classify Interpretability Methods

When you compare methods, it helps to keep these axes in mind:

* **Scope**

  * **Local**: explain one prediction for one input
  * **Global**: explain the model’s behavior over many inputs or entire layers

* **What is explained**

  * **Feature attribution**: importance of input dimensions (pixels, features)
  * **Representation structure**: geometry of hidden layers, embeddings, concepts
  * **Concept-level**: high-level human concepts (e.g., “stripedness”, “gender”)

* **Model access**

  * **Model-agnostic**: only needs input–output pairs
  * **White-box**: needs gradients / architecture

* **Mechanism**

  * **Gradient-based** (backprop)
  * **Perturbation-based** (mask/occlude and observe changes)
  * **Decomposition-based** (redistribute relevance through layers)
  * **Representation-based** (embeddings, similarity, clustering)
  * **Surrogate-based** (fit simple models to explain complex ones)

* **Faithfulness vs. human-interpretability**

  * Some methods are very faithful to model internals but hard for humans to interpret (e.g., raw gradients, RSA).
  * Others are more human-friendly but approximate (e.g., LIME, simple concept visualizations).

---

## 2. High-Level Comparison Table

### 2.1 Method Families Overview

```text
+----------------------------+---------------+--------------+------------------------------+
| Method Family              | Local/Global  | Model Access | What It Explains             |
+----------------------------+---------------+--------------+------------------------------+
| Saliency / Gradients       | Local         | White-box    | Input feature importance     |
| Grad-CAM / CAM variants    | Local         | White-box    | Spatial regions (vision)     |
| Perturbation (LIME/SHAP)   | Local         | Agnostic     | Feature importance           |
| LRP / DeepLIFT             | Local         | White-box    | Relevance decomposition      |
| Feature visualization      | Local/Global  | White-box    | Preferred patterns/neuron    |
| Dim. reduction (PCA/t-SNE) | Global        | Either       | Geometry of representations  |
| RSA / CKA                  | Global        | White-box    | Similarity across layers/models|
| Probing classifiers        | Global        | White-box    | What info is encoded in reps |
| Concept-based (TCAV, CAVs) | Local/Global  | White-box    | Alignment with human concepts|
| Counterfactuals            | Local         | Either       | Decision boundaries/minimal  |
+----------------------------+---------------+--------------+------------------------------+
```

---

## 3. Technical Deep Dives by Method Family

### 3.1 Saliency / Gradient-based Methods

**Examples:**

* Vanilla gradient ∂y/∂x
* Gradient × Input
* SmoothGrad
* Integrated Gradients

**What they compute**

Given a model ( f(x) ) and output (logit or probability) ( y_k = f_k(x) ):

* Vanilla saliency:
  ( S = \left| \frac{\partial y_k}{\partial x} \right| )
  Each input dimension gets a sensitivity score.

* Integrated Gradients:
  Approximate path integral of gradient from a baseline ( x' ) to input ( x ):
  ( IG_i(x) \approx (x_i - x'*i) \cdot \frac{1}{m} \sum*{j=1}^{m} \frac{\partial f(x' + \frac{j}{m}(x - x'))}{\partial x_i} )

**Assumptions**

* Differentiable model
* Gradient magnitude correlates with importance
* Baseline choice (for Integrated Gradients) is meaningful (e.g., black image, zero vector, neutral text).

**Pros**

* Very cheap (one or a few backprops)
* Faithful to model gradients
* Works across architectures (CNNs, transformers, etc.)

**Cons**

* Noisy and fragile (small perturbations can change saliency)
* Can highlight irrelevant but high-variance areas
* Hard to interpret on high-dimensional, structured inputs (text, language tokens)

---

### 3.2 Grad-CAM / Class Activation Mapping (vision-centric)

**Examples:**

* CAM, Grad-CAM, Grad-CAM++

**What they compute**

Focuses on **convolutional layers**:

1. Compute gradient of class score ( y_k ) w.r.t. feature maps ( A^l ) of a conv layer.
2. Aggregate gradients spatially to get weights ( \alpha_k^l ).
3. Compute class activation map:
   ( L^{\text{Grad-CAM}}_k = \text{ReLU}(\sum_l \alpha_k^l A^l) ).

Heatmap overlays show spatial regions important for class ( k ).

**Assumptions**

* Spatial feature maps correspond to locations in input
* Conv structure reflects spatial attention

**Pros**

* Great visual intuition for CNNs
* Spatially coarse but human-readable
* Helps understand “where” the model looks

**Cons**

* Mainly vision, CNN-focused (less direct for ViTs or text)
* Resolution is limited to last conv feature map
* Still gradient-driven; inherits some gradient noise issues

---

### 3.3 Perturbation-based Methods (Occlusion, LIME, SHAP)

**Examples:**

* Occlusion sensitivity (masking pixels/patches and measuring output change)
* LIME (local surrogate linear model)
* SHAP (Shapley value-based importance)

**What they compute**

* **Occlusion**: Replace region ( r ) of input by baseline, measure ∆ in output. Importance ≈ performance drop.
* **LIME**:

  * Sample perturbed inputs around x (e.g., masking superpixels or setting features to mean).
  * Fit a **linear** surrogate model g(x) in that local neighborhood.
  * Coefficients of g(x) = local feature importance.
* **SHAP**:

  * Approximate Shapley values from cooperative game theory:
    Contribution of each feature across all possible feature subsets.

**Assumptions**

* Local linear / additive approximation around x is meaningful
* Perturbation distribution is realistic
* Features can be turned off/perturbed in a coherent way

**Pros**

* Model-agnostic: any black-box model
* Often more intuitive for tabular data
* SHAP has strong theoretical backing (Shapley axioms)

**Cons**

* Computationally expensive (lots of evaluations)
* Sensitive to choice of baseline/perturbation distribution
* LIME can be unstable (different runs, different explanations)
* SHAP becomes intractable with many features (relies on approximations)

---

### 3.4 Decomposition Methods: LRP, DeepLIFT

**Layer-wise Relevance Propagation (LRP)**
**DeepLIFT (Deep Learning Important FeaTures)**

**What they compute**

These methods **redistribute the model output back onto input features** by layer-wise rules:

* LRP:
  Start from output y, push “relevance” backwards through layers, using conservation rules so total relevance is preserved.
* DeepLIFT:
  Compares neuron activations to a reference activation (baseline) and distributes contributions backwards according to contribution scores.

**Assumptions**

* Relevance can be decomposed additively through the network
* Layer-specific rules can capture how importance flows through nonlinearities

**Pros**

* Often yields sharper, more structured explanations than raw gradients
* Applies naturally to deep networks
* Designed for faithfulness and relevance conservation

**Cons**

* Requires detailed access to model internals
* More complex to implement correctly
* Rules can be architecture-dependent (custom treatment for conv, ReLU, pooling, etc.)

---

### 3.5 Feature Visualization / Activation Maximization

**What it is**

Try to find an input that **maximizes** a chosen neuron’s, channel’s, or layer’s activation:

[
x^* = \arg\max_x a_i(x) - \lambda R(x)
]

Where ( a_i(x) ) is neuron activation, and ( R(x) ) is a regularizer (to keep images natural).

**Techniques**

* Gradient ascent on input
* Regularization: total variation, frequency penalties, priors
* Can target:

  * Single neuron
  * Channel
  * Linear combination of units
  * Class logits directly

**Assumptions**

* Maximizing activation reveals the “preferred stimulus”
* Patterns are human-interpretable when regularized

**Pros**

* Directly shows what features a neuron likes
* Useful for global understanding of what layers detect
* Connects to neuroscience (“receptive fields” / “tuning curves”)

**Cons**

* Can produce strange artifacts if not well-regularized
* Can be brittle; optimization can find unnatural inputs
* Not always easy to map to intuitive human concepts

---

### 3.6 Dimensionality Reduction & Clustering (PCA, t-SNE, UMAP)

**What they do**

Take hidden layer activations or embeddings for many samples and **project them into 2D/3D**:

* PCA: linear projection along directions of greatest variance
* t-SNE: nonlinear; preserves local neighborhood similarity
* UMAP: nonlinear; often better global structure, faster than t-SNE

**Use**

* Inspecting clusters
* Detecting category structure
* Discovering biases (e.g., demographic separation)
* Monitoring representation drift

**Assumptions**

* Distance / similarity in high-d space is meaningful
* Projection preserves key structure
* Human can interpret cluster plot

**Pros**

* Great high-level visualization of conceptual structure
* Model-agnostic (just need embeddings)
* Works across domains (vision, NLP, multimodal)

**Cons**

* t-SNE/UMAP can distort global distances
* Sensitive to hyperparameters (perplexity, neighbors)
* Easy to over-interpret patterns that are artifacts of projection

---

### 3.7 RSA / CKA (Representation Similarity Analysis)

**What they do**

Compare two sets of representations (e.g., two layers, or two models) by comparing **pairwise distances** across a common set of stimuli.

* RSA: correlate representational (dis)similarity matrices.
* CKA: computes a kernel alignment score; more stable and invariant to isotropic scaling/rotation.

**Use**

* Compare early vs late layers
* Measure effect of fine-tuning
* Compare models with different architectures
* Link neural networks to brain activity (neuroimaging)

**Assumptions**

* Pairwise distance structure encodes the “geometry of thought” in that layer
* Correlation between geometries implies similar representations

**Pros**

* Global, high-level structural comparison
* Great for understanding model evolution and drift
* Strongly used in research on scaling laws and architecture comparisons

**Cons**

* Not directly human-interpretable (numbers on similarity)
* Requires many example inputs
* More about “how similar are these spaces?” than “why did this particular decision happen?”

---

### 3.8 Probing Classifiers (Linear / Nonlinear Probes)

**What they do**

Take representations from layer L, train a simple classifier (e.g., logistic regression) to predict some property (POS tag, sentiment, gender, object class…).

If a **linear probe** works:

* Representation linearly encodes that property.

If only a nonlinear probe works:

* Property is present but entangled.

**Assumptions**

* Probe performance is a proxy for information content
* Good probe training / regularization (or you get “overfitting probes”)

**Pros**

* Very powerful for analyzing when/where different info emerges
* Widely used in LLM and vision interpretability
* Distinguishes surface vs deep encoding (early vs late layers)

**Cons**

* Probing does not distinguish “used vs available” information
* Overpowered probes can read out information that the base model doesn’t leverage
* Interpretation requires care

---

### 3.9 Concept-Based Methods (TCAV, CAVs, CLIP-like Approaches)

**Core idea**

Define a concept (e.g., “striped”, “smiling”, “medical equipment”) via a set of labeled examples, then find a **direction** in embedding space that corresponds to that concept.

* TCAV: Testing with Concept Activation Vectors

  * Learn a linear separator between examples that have the concept vs do not.
  * The normal vector is the concept direction.
  * Measure sensitivity of predictions to moving along that direction.

**Use**

* Understand which concepts a model relies on
* Diagnose bias (“gender concept” direction driving job predictions)
* Build controls (e.g., style or attribute sliders in generative models)

**Assumptions**

* Concept can be captured linearly in the representation
* Concept dataset is well-defined
* Representation disentangles relevant attributes enough

**Pros**

* Operates at **human concept level** (more interpretable)
* Good for high-level audits (fairness, style, content moderation)
* Bridges human semantics with model internals

**Cons**

* Requires concept example sets
* Linearity assumption may fail for complex concepts
* Sensitive to dataset construction and spurious correlations

---

### 3.10 Counterfactual Explanations

**What they are**

Find a minimal change to input x that flips the prediction:

[
x^* = \arg\min_{x'} \text{distance}(x, x') \quad \text{s.t. } f(x') \neq f(x)
]

**Interpretation**

* Shows what “borderline” cases look like
* Indicates decision boundary
* Very intuitive for users (“if your income were 10% higher, decision changes”)

**Assumptions**

* Distance metric reflects meaningful change
* Counterfactual is feasible in real world (often not true without constraints)

**Pros**

* Very human-intuitive
* Great for debugging and fairness discussions
* Works even for complex black-box models

**Cons**

* Finding truly minimal, realistic counterfactuals can be hard
* Potentially expensive optimization
* Risk of unrealistic or impossible suggestions without strong constraints

---

## 4. “Which Method When?” – Practical Guidance

Here’s a quick decision guide that matches how a practitioner would pick tools.

### 4.1 If you want to know “why did the model make this prediction for this input?”

* Start with:

  * **Gradient saliency / Integrated Gradients** (fast, white-box)
  * **Grad-CAM** (for vision)
* For model-agnostic or tabular data:

  * **LIME** or **SHAP**
* For very high-stakes decisions:

  * Combine saliency + perturbation + (if possible) counterfactual examples.

### 4.2 If you want to understand “what the model has learned overall”

* Use **dimensionality reduction (PCA / t-SNE / UMAP)** on embeddings to inspect cluster structure.
* Use **feature visualization** to see what neurons or channels respond to.
* Use **probes** to locate where particular info is encoded.

### 4.3 If you want to compare two models or track drift

* Use **RSA / CKA** on layers across versions or checkpoints.
* Look at **cluster plots** before/after fine-tuning.
* Use **probes** at different training stages.

### 4.4 If you care specifically about bias and concepts

* Use **concept-based methods (TCAV/CAVs)** to quantify the influence of sensitive attributes or semantic concepts.
* Combine with **embedding visualization** to detect clustering by protected attributes.
* Add **counterfactual** analysis to see minimal changes that alter predictions.

### 4.5 If you care about generative control / editing

* Focus on **concept vectors** within latent or embedding spaces.
* For diffusion / GANs / VAEs, analyze **latent directions** for attributes.
* Use feature visualization to connect those directions to visual/textual attributes.

---
---
---

## A **clean, logically structured flowchart** that maps **the type of interpretability question** you want answered to the **appropriate interpretability method(s)**.

This is designed in the same visual style as your Module 1–3 diagrams — easy to convert into a PowerPoint slide, PDF, or Notion graphic.

---

## **FLOWCHART: “What Interpretability Question Do You Have?” → “Which Method to Use?”**

```
                                     +------------------------------------------------+
                                     |   START: What do you want to understand?       |
                                     +----------------------+-------------------------+
                                                        |
                                                        v
                            +-------------------------------------------------------------------+
                            | 1. Why did the model make THIS prediction for THIS input?         |
                            +-------------------------------------------------------------------+
                                                        |
              -----------------------------------------------------------------------------------------
              |                                       |                                          |
              v                                       v                                          v
     +-------------------+                   +------------------------+                 +----------------------+
     |  Gradients / IG   |                   |  Perturbation Methods  |                 |   Counterfactuals    |
     |  (saliency maps)  |                   |  (LIME, SHAP, occlusion)|                | (minimal changes)    |
     +-------------------+                   +------------------------+                 +----------------------+
              |                                       |                                          |
              |                                       |                                          |
              +----------------------------> Combine results <-----------------------------------+
                                                for reliability
```

---

```
                           +------------------------------------------------------+
                           | 2. Which parts of the input influenced the decision? |
                           +------------------------------------------------------+
                                                |
                         -------------------------------------------------------------
                         |                                                           |
                         v                                                           v
           +------------------------------+                                +-------------------------+
           |    Grad-CAM / CAM methods    |                                |   Attribution heatmaps  |
           |  (vision, conv layers only)  |                                | (IG, DeepLIFT, LRP, etc.)|
           +------------------------------+                                +-------------------------+
```

---

```
                          +--------------------------------------------------------------+
                          | 3. What features or concepts has the model learned generally?|
                          +--------------------------------------------------------------+
                                                |
              --------------------------------------------------------------------------------
              |                                |                                            |
              v                                v                                            v
+--------------------------+      +----------------------------+             +------------------------------+
|   Feature Visualization  |      | Dimensionality Reduction   |             |   Concept Vector Methods     |
|  (activation maximization)|     | (PCA, t-SNE, UMAP on reps) |             | (TCAV, CLIP-style concepts) |
+--------------------------+      +----------------------------+             +------------------------------+
                                 (view clusters / geometry)                   (find human-aligned concepts)
```

---

```
                        +-------------------------------------------------------------------+
                        | 4. Does the representation encode certain information (shape,     |
                        |    color, gender, sentiment, syntax…)?                             |
                        +-------------------------------------------------------------------+
                                                |
                                         +--------------+
                                         |  Probing     |
                                         | Classifiers  |
                                         | (linear/nonlinear probes)
                                         +--------------+
                                                |
                                                v
                            +-----------------------------------------------------+
                            | If linear probe succeeds → info is linearly encoded |
                            | If only nonlinear probe works → info is entangled  |
                            +-----------------------------------------------------+
```

---

```
                      +----------------------------------------------------------------------+
                      | 5. Are two layers/models learning similar representations?            |
                      |    (e.g., before and after fine-tune, or model A vs model B)         |
                      +----------------------------------------------------------------------+
                                                |
                         -----------------------------------------------------------
                         |                                                         |
                         v                                                         v
         +------------------------------+                              +---------------------------+
         |   Representation Similarity   |                              |   Centered Kernel         |
         |       Analysis (RSA)          |                              |     Alignment (CKA)       |
         +------------------------------+                              +---------------------------+
```

---

```
                     +-------------------------------------------------------------+
                     | 6. Is the model biased or relying on sensitive attributes? |
                     +-------------------------------------------------------------+
                                                |
                      ---------------------------------------------------------------------
                      |                                  |                                |
                      v                                  v                                v
       +-----------------------------+       +------------------------------+  +---------------------------+
       |   Concept-based methods     |       |  Embedding visualization     |  | Counterfactual analysis  |
       | (TCAV, CAVs: "gender", etc)|       | (cluster sensitive groups?)  |  | (“change X to flip label”)|
       +-----------------------------+       +------------------------------+  +---------------------------+
```

---

```
                       +---------------------------------------------------------------+
                       | 7. Has the model's understanding changed over time?           |
                       |    (representation drift after retraining or fine-tuning)     |
                       +---------------------------------------------------------------+
                                                |
                             -------------------------------------------------------
                             |                                                     |
                             v                                                     v
        +----------------------------------+                     +-------------------------------------+
        | Embedding space comparison       |                     | RSA / CKA between checkpoints        |
        | (visual drift in PCA/UMAP plots) |                     | (quantitative drift measurement)     |
        +----------------------------------+                     +-------------------------------------+
```

---

```
                    +------------------------------------------------------------+
                    | 8. Where does a specific concept “live” inside the model? |
                    +------------------------------------------------------------+
                                                |
                    ---------------------------------------------------------
                    |                                                       |
                    v                                                       v
      +------------------------------+                        +-------------------------------+
      |  Concept Activation Vectors  |                        | Feature Visualization for     |
      |      (TCAV / CAVs)           |                        | units/heads associated with    |
      +------------------------------+                        | concept directions             |
                                                              +-------------------------------+
```

---

```
                    +------------------------------------------------------------------+
                    | 9. How can I make a model’s explanation understandable for users?|
                    +------------------------------------------------------------------+
                                                |
          -----------------------------------------------------------------------------------
          |                                     |                                           |
          v                                     v                                           v
+---------------------+          +------------------------------+             +---------------------------+
| LIME (simple model) |          |  SHAP (feature contribution) |             | Counterfactuals (“what if”)|
+---------------------+          +------------------------------+             +---------------------------+
 (human-friendly)                 (more theoretically grounded)               (intuitive user impact)
```

---

## **CONSOLIDATED SLIDE-READY VERSION (All Branches)**

Here is the full flowchart as a single block:

```
START → What do you want to understand?
|
+--> [1] Why THIS prediction?
|        |--> Gradients / IG
|        |--> LIME / SHAP / Occlusion
|        |--> Counterfactuals
|
+--> [2] Which parts of the input were important?
|        |--> Grad-CAM (vision)
|        |--> Attribution (IG, LRP, DeepLIFT)
|
+--> [3] What features/concepts has the model learned overall?
|        |--> Feature Visualization
|        |--> PCA / t-SNE / UMAP of embeddings
|        |--> TCAV / Concept Vectors
|
+--> [4] Does the representation encode specific information?
|        |--> Linear/Nonlinear Probes
|
+--> [5] Are two layers/models similar?
|        |--> RSA
|        |--> CKA
|
+--> [6] Is there bias or sensitive-concept reliance?
|        |--> TCAV / CAVs
|        |--> Embedding Visualization
|        |--> Counterfactual Checks
|
+--> [7] Has the representation changed over updates?
|        |--> PCA/UMAP drift inspection
|        |--> RSA / CKA drift comparisons
|
+--> [8] Where does a concept live in the model?
|        |--> TCAV / CAVs
|        |--> Feature Visualization of aligned units
|
+--> [9] Need a user-facing explanation?
         |--> LIME / SHAP / Counterfactuals
```

---
