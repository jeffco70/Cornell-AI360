# Module 4: **math-first comparison** of the main learning objectives:

* **InfoNCE** (contrastive / CLIP-style)
* **Cross-Entropy (CE)** (classification, captioning, seq2seq)
* **Score Matching / Denoising Score Matching** (diffusion)
* **Autoregressive (AR) next-token modeling** (LLMs, multimodal LLMs)

I’ll show:

* the **core loss formula**
* what **distribution** it’s really trying to learn
* what **geometry** it induces
* how it fits into **multimodal** setups

---

## 1. Big Picture: What each objective is doing

Very high level:

* **InfoNCE**:

  * “Bring true pairs together, push mismatched pairs apart.”
  * Learns a **shared embedding space**.
  * Used in CLIP for text–image alignment.

* **Cross-Entropy (CE)**:

  * “Make your predicted probability mass match the empirical labels/sequences.”
  * Learns **conditional distributions** (p_\theta(y|x)) or (p_\theta(x|z)).
  * Used for classification, captioning, text decoders.

* **Score Matching / Denoising Score Matching**:

  * “Learn the **score** (gradient of log density) of a corrupted/noisy data distribution.”
  * Used in diffusion models for text-conditioned image generation.

* **Autoregressive (AR)**:

  * “Maximize the joint probability by factorizing into next-token predictions.”
  * Learns (p_\theta(x_1,\dots,x_T)) via product of conditionals.
  * Used in LLMs & multimodal LLMs.

---

## 2. InfoNCE (Contrastive Objective)

### 2.1 Setup

You have paired data ((x_i, y_i)), e.g.:

* (x_i) = image
* (y_i) = text caption

Encoders map them to embeddings:

[
z_i = f_\theta(x_i), \quad z'*i = g*\phi(y_i)
]

Define a similarity function, typically:

[
s_{ij} = \frac{\langle z_i, z'_j \rangle}{\tau}
]

where (\tau) is a temperature scalar.

### 2.2 InfoNCE loss

For a batch of size (N), the loss for each pair ((i)) is:

[
\mathcal{L}*i^{\text{InfoNCE}}
= - \log \frac{\exp(s*{ii})}{\sum_{j=1}^{N} \exp(s_{ij})}
]

Total loss is average over batch, sometimes symmetrized (image→text and text→image directions).

### 2.3 What it’s doing (probabilistically)

* Treats the batch as a small universe: exactly one **positive** (j=i) and (N-1) **negatives**.
* Encourages high similarity for positives relative to negatives.
* Can be interpreted as optimizing a lower bound on **mutual information** (I(z; z')).

So: **InfoNCE ≈ maximize MI between paired modalities**.

### 2.4 Geometry

* Induces a **metric space** where semantically aligned points from different modalities are close.
* Does **not** model (p(x)) or (p(y|x)) explicitly—only relative similarity.

### 2.5 Multimodal use

* CLIP: image encoder + text encoder trained with InfoNCE = **shared text–image space**.
* Great for cross-modal **alignment**, **retrieval**, and as a **conditioning backbone** for generative models (e.g., Stable Diffusion uses CLIP text encoder).

---

## 3. Cross-Entropy (CE)

Cross-entropy is the workhorse for supervised and conditional modeling.

### 3.1 Classification CE

Given:

* Input (x)
* Ground truth class (y \in {1,\dots,K})
* Model outputs logits (h_\theta(x)\in\mathbb{R}^K)
* Predicted probabilities:
  [
  p_\theta(y=k|x) = \frac{\exp(h_k(x))}{\sum_j \exp(h_j(x))}
  ]

Cross-entropy loss:

[
\mathcal{L}(x,y) = -\log p_\theta(y|x)
]

Over the data distribution (p_{\text{data}}(x,y)):

[
\mathbb{E}*{(x,y)\sim p*{\text{data}}}[-\log p_\theta(y|x)]
]

Minimizing this is equivalent to minimizing:

[
\mathbb{E}*{x} \big[ \text{KL}(p*{\text{data}}(y|x) ,|, p_\theta(y|x)) \big]
]

So CE **matches conditional distributions**.

### 3.2 Sequence CE (captioning, seq2seq)

For a caption (y_{1:T}) given image embedding (z):

[
p_\theta(y_{1:T} | z) = \prod_{t=1}^{T} p_\theta(y_t | y_{<t}, z)
]

Loss:

[
\mathcal{L}(x,y_{1:T}) = - \sum_{t=1}^T \log p_\theta(y_t | y_{<t}, z)
]

This is just CE summed over time steps (“teacher forcing”).

### 3.3 Multimodal use

* Image→text captioning:

  * (z = E_{\text{img}}(x_{\text{img}})), decoder uses CE to learn (p(\text{text}|\text{image})).
* VQA decoders, label heads:

  * CE over answer vocabulary conditioned on image+question embeddings.

CE is the objective when you want a **direct conditional output distribution**.

---

## 4. Score Matching / Denoising Score Matching (Diffusion)

For diffusion, we move from modeling **probabilities** directly to modeling the **score function**:

[
s_\theta(x) \approx \nabla_x \log p(x)
]

### 4.1 Classical score matching (Hyvärinen)

Given data distribution (p_{\text{data}}(x)) and model (p_\theta(x)), define score:

[
s_\theta(x) = \nabla_x \log p_\theta(x)
]

Hyvärinen’s score matching objective:

[
\mathcal{L}(\theta) = \mathbb{E}*{p*{\text{data}}(x)}\left[ \frac{1}{2} | s_\theta(x) |^2

* \nabla_x \cdot s_\theta(x) \right]
  ]

This avoids needing (p_\theta(x)) normalized; focuses on matching **score fields**.

### 4.2 Denoising score matching (used in diffusion)

Diffusion doesn’t directly use the classical form. Instead:

1. Define a noising process that corrupts data:
   [
   q(x_t | x_0)
   ]
   where (t) is a noise level / timestep.

2. Train a model (s_\theta(x_t, t)) to approximate the score of the noisy distribution:
   [
   s_\theta(x_t, t) \approx \nabla_{x_t} \log q(x_t | x_0)
   ]

Practical loss (one common form):

[
\mathcal{L}(\theta)
= \mathbb{E}*{t, x_0, x_t \sim q(x_t|x_0)}
\left[ \lambda(t) , \left| s*\theta(x_t, t) - \nabla_{x_t} \log q(x_t|x_0) \right|^2 \right]
]

In practice you don’t compute the true gradient term explicitly; for Gaussian noising, this simplifies to a regression on the added noise.

### 4.3 Conditional / multimodal diffusion (text→image)

Condition on text embedding (c) (from CLIP / transformer):

[
s_\theta(x_t, t, c)
]

Loss:

[
\mathcal{L}(\theta)
= \mathbb{E}*{t, x_0, x_t, c}
\left[ \lambda(t) , \left| s*\theta(x_t, t, c) - \text{target_score}(x_t, t, x_0) \right|^2 \right]
]

This makes the score function **text-conditional** → text steers denoising.

### 4.4 What it’s doing conceptually

* Learns a vector field that points towards high-density regions of the data manifold at every noise scale.
* Sampling = numerically integrating a stochastic differential equation (SDE/ODE) from noise → data using this score field.

So: **Score matching learns how to climb the log-density landscape; generation is gradient-guided denoising.**

---

## 5. Autoregressive (AR) Next-Token Modeling

This is the standard LLM objective.

### 5.1 Factorization of joint distribution

Given a sequence (x = (x_1,\dots,x_T)):

[
p_\theta(x) = \prod_{t=1}^{T} p_\theta(x_t | x_{<t})
]

Training objective (negative log-likelihood):

[
\mathcal{L}(\theta) = - \mathbb{E}*{x \sim p*{\text{data}}} \left[ \sum_{t=1}^T \log p_\theta(x_t | x_{<t}) \right]
]

So this is **just cross-entropy for each token**, but now the model distribution is the full joint via the product.

### 5.2 Multimodal AR

If you tokenize non-text modalities (e.g., image patches, audio tokens), you get sequences like:

* ([ \text{<img>}, \text{patch}_1, …, \text{<txt>}, w_1, w_2, …])

The AR factorization becomes:

[
p_\theta(x) = \prod_{t} p_\theta(x_t | x_{<t})
]

where some tokens are visual/audio “tokens.”

Same CE loss:

[
\mathcal{L}(\theta) = -\mathbb{E}*x \left[ \sum_t \log p*\theta(x_t | x_{<t}) \right]
]

But now **attention** is free to flow between modalities.

### 5.3 Conceptual view

* AR models are **density models** over discrete sequences.
* They directly approximate the joint distribution, unlike CLIP (which is contrastive) or diffusion (which models scores in continuous space).

---

## 6. Comparative Summary: What Each Objective Really Optimizes

### 6.1 Objective forms (condensed)

* **InfoNCE (contrastive):**

  [
  \mathcal{L}_{\text{InfoNCE}} =
  \mathbb{E}\left[-\log \frac{\exp( s(z,z^+) )}{\sum_j \exp( s(z,z_j) )}\right]
  ]

  Learns relative similarity; approximates maximizing (I(z;z^+)).

* **Cross-Entropy (CE):**

  [
  \mathcal{L}*{\text{CE}} =
  \mathbb{E}*{(x,y)} [ -\log p_\theta(y|x) ]
  ]

  Minimizes KL between model conditional and true conditional.

* **Score Matching (Diffusion / DSM):**

  [
  \mathcal{L}*{\text{DSM}} =
  \mathbb{E}*{t,x_0,x_t} \left[
  \lambda(t) , | s_\theta(x_t,t,c) - \nabla_{x_t} \log q(x_t|x_0) |^2
  \right]
  ]

  Fits score function of noisy data distribution; enables SDE-based sampling.

* **Autoregressive (AR NLL):**

  [
  \mathcal{L}*{\text{AR}} =
  \mathbb{E}*{x} \left[

  * \sum_{t} \log p_\theta(x_t | x_{<t})
    \right]
    ]

  Equivalent to CE per token; learns full joint (p_\theta(x)).

---

### 6.2 What they’re best at (from a modeling perspective)

* **InfoNCE**:

  * Best at **representation learning** and **alignment**, not full generative modeling.
  * Great for **shared semantic spaces** (text–image, text–audio, etc.).

* **Cross-Entropy**:

  * Best at **prediction** and **supervised conditional output**.
  * Used in **captioning**, **classification**, conditional text generation.

* **Score Matching / Diffusion**:

  * Best at **continuous generative modeling** of rich high-dimensional data (images, audio).
  * Handles complex multimodal densities with powerful sampling.

* **Autoregressive**:

  * Best at **sequence generation** and **joint density estimation** over tokens.
  * When extended to multimodal tokens, becomes a **general multimodal generative model** (LLMs, multimodal LLMs).

---

### 6.3 How they support multimodal capability

* **CLIP + InfoNCE** → gives you **aligned embeddings** = backbone for:

  * retrieval
  * conditioning for diffusion
  * multimodal similarity.

* **CE (captioning, VQA heads)** → gives **explicit conditional outputs**:

  * image→text
  * text→label, etc.

* **Score Matching (diffusion)** → gives **high-fidelity image/audio generation** conditioned on text (or other modalities).

* **AR (LLMs / MLLMs)** → gives **unified modeling** of any modalities tokenizable into sequences and supports:

  * reasoning
  * multi-step dialogue
  * multimodal chain of thought.

---
