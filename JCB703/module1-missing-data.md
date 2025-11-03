# Module 1 - Missing Data categories

In **Module 1 of JCB703**, the instructor does not treat “missing data” as a single issue, but rather teaches **several distinct categories (or causes) of missingness**, each with **different handling strategies** depending on its origin and potential bias effect.

The transcript aligns closely with standard data-science taxonomy (MCAR, MAR, MNAR), but presents them in practical, business-oriented language so learners can recognize them in real datasets.

Here’s how the course breaks it down:

---

## **Categories of Missing Data Discussed**

### **1. Random Missing Data (Accidental or Unsystematic Gaps)**

**Description:**
Values that are missing *purely by chance* — for example, a sensor glitch, a web-scraper timeout, or a user who accidentally skips a survey question.

**Example (from the scraping exercise):**
A few recipe entries missing “prep time” because those pages didn’t load completely.

**Approach taught:**

* **Simple imputation** (fill with mean, median, or mode).
* **Deletion** if the percentage is small and the variable isn’t critical.
* **Documenting randomness** to ensure transparency (e.g., noting <2% data loss).

**Why:**
Since missingness is random, imputation introduces little bias and simplifies later analysis.

---

### **2. Systematic or “Patterned” Missing Data**

**Description:**
Missingness depends on *some other observed variable.*
Example: income data missing more often for younger respondents, or ratings missing for recipes under a certain number of reviews.

This corresponds to **MAR (Missing At Random)** in statistical terms.

**Approach taught:**

* **Investigate correlation** between missingness and other features using:

  * Cross-tabulations and missingness heatmaps.
  * Visualizations showing where gaps cluster (e.g., only for certain categories).
* **Model-based imputation**:

  * Use regression or groupwise averages (e.g., fill missing income by age group mean).
* **Conditional deletion**:

  * Drop affected rows if the relationship is weak but data volume is large.

**Why:**
Students learn that systematic gaps can distort conclusions if uncorrected — e.g., a biased estimate of average income or rating.

---

### **3. Intentional or Informative Missing Data**

**Description:**
Data are missing *for a reason related to the target variable* — e.g., customers who churn don’t fill out satisfaction surveys, or low-rated recipes have no comments.
This matches **MNAR (Missing Not At Random)**.

**Approach taught:**

* **Flag and treat as its own category or feature.**

  * Example: Add a Boolean column `missing_feedback = True/False`.
* **Do not impute with averages**, since the absence itself is meaningful.
* **Qualitative analysis:** ask *why* the data weren’t captured — is this a signal of disengagement, bias, or structural exclusion?

**Why:**
These cases carry predictive information, and imputing them hides valuable behavioral signals.

---

### **4. Structural Missing Data**

**Description:**
Fields that logically don’t apply to all records.
Example: “spouse name” for single individuals, or “engine size” for electric vehicles.

**Approach taught:**

* **Do not treat as missing** — leave as nulls or drop the field entirely.
* Optionally **split dataset by applicability** (e.g., electric vs. combustion engines).

**Why:**
These are *expected absences*, not data problems. Treating them as missing can lead to faulty imputations or invalid model inputs.

---

## **Visualization and Assessment Techniques**

The module walks students through tools to *detect and categorize missingness*:

| Technique                         | Purpose                              |
| --------------------------------- | ------------------------------------ |
| `.isnull().sum()`                 | Quantify missing values per column.  |
| `missingno.matrix()` or heatmap   | Visualize patterns of missingness.   |
| Correlation of missing indicators | Reveal systematic missingness (MAR). |
| Boxplots by missing flag          | Identify distribution shifts (MNAR). |

Students are taught to visualize missingness as part of exploratory analysis, not as an afterthought.

---

## **Summary Table of Categories and Actions**

| Category                            | Statistical Equivalent | Typical Cause                                   | Recommended Handling                              |
| ----------------------------------- | ---------------------- | ----------------------------------------------- | ------------------------------------------------- |
| **Random missing**                  | MCAR                   | Data entry or collection errors                 | Mean/median imputation, or drop if minimal        |
| **Systematic missing**              | MAR                    | Linked to another observed feature              | Group-wise imputation, regression-based fill      |
| **Intentional/informative missing** | MNAR                   | Missingness carries meaning (e.g., no feedback) | Create “missing” flag feature, analyze separately |
| **Structural missing**              | N/A                    | Inapplicable data fields                        | Leave as null or exclude field                    |

---

## **Key Teaching Message**

> “Don’t just *fill* missing values — *understand why* they’re missing.
> That ‘why’ tells you whether to impute, drop, flag, or leave it alone.”

---

So yes — **four distinct categories of missing data** are explicitly discussed, with corresponding **analysis and remediation approaches** for each.
This prepares students for Module 2, where understanding how missingness relates to *bias and fairness* becomes essential.

---

