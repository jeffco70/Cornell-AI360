# Module 2 - Data Analysis Techniques

This is where **Module 2 of JCB703 (“Identifying and Addressing Bias”)** really connects the technical data-cleaning techniques from Module 1 with higher-level **data auditing and bias analysis methods**.

Although the module’s main focus is fairness and ethics, the instructor still teaches a number of *concrete, practical data-cleaning and analysis techniques* that support bias detection and mitigation.

Below is a detailed list — organized into categories — of what’s actually discussed and demonstrated in the transcript.
(We’ll divide it into multiple parts for completeness.)

---

## **Part 2A: Data Cleaning Techniques for Bias Prevention**

In this module, cleaning is no longer just about “making the data tidy.”
It’s about ensuring that the cleaning process **doesn’t introduce or conceal bias**.
The instructor walks through how the same cleaning steps used in Module 1 must be re-evaluated through a fairness lens.

---

### **1. Targeted Missing-Data Analysis**

**Goal:** Identify whether missingness is random or concentrated among specific groups (a major bias source).

**Techniques taught:**

| Method                                | Purpose                                                            | Implementation Example                                                                  |
| ------------------------------------- | ------------------------------------------------------------------ | --------------------------------------------------------------------------------------- |
| **Group-wise missing value analysis** | Check if certain demographics have higher rates of missing values. | In Excel or Pandas: `df.groupby('gender')['income'].apply(lambda x: x.isnull().mean())` |
| **Missingness correlation matrix**    | Correlate missingness indicators with categorical attributes.      | Add Boolean “is_missing” flags and visualize correlation.                               |
| **Stratified imputation**             | Impute missing values *within each subgroup* instead of globally.  | e.g., fill missing incomes using the median for each gender/region.                     |
| **Bias audit log for imputation**     | Document what was imputed, for whom, and why.                      | Maintain a simple “cleaning decisions” sheet.                                           |

**Key principle taught:**

> “A neutral-looking imputation can become biased if it overwrites systematic absence in one population.”

---

### **2. Balanced Sampling and Representation Checks**

**Goal:** Detect and correct underrepresentation in subgroups.

**Techniques:**

* **Frequency distribution checks**:
  Count the number of observations per group (gender, age, region) using pivot tables or `value_counts()`.

* **Percentage-based balance metric:**
  Compute % share of each category and visualize with bar plots to highlight dominance of one group.

* **Resampling approaches:**

  * *Undersampling*: reduce overrepresented groups.
  * *Oversampling*: duplicate or synthesize examples of underrepresented ones (conceptual, not algorithmic).
  * *Weighted sampling*: assign proportional weights during model evaluation.

* **Visualization:**
  Stacked bar charts comparing population vs. dataset proportions.

**Concept emphasized:**

> “Fair datasets represent all relevant groups in proportion to their real-world presence — or deliberately rebalance to achieve parity.”

---

### **3. Outlier Review with Fairness Context**

Outliers can distort model training **unevenly across groups**.

**Taught methods:**

* Compute IQR or z-scores *within each demographic subgroup* (not globally).
* Identify whether certain groups have systematically higher variability.
* Decide whether outliers represent data quality issues or real minority patterns that should be preserved.

**Example:**
If female participants show more variability in income due to part-time work, don’t trim those “outliers” — that variability is meaningful.

---

### **4. Feature Review and Proxy Detection**

**Goal:** Identify variables that unintentionally encode protected characteristics.

**Techniques:**

| Method                                                      | Description                                                   | Example                                                    |
| ----------------------------------------------------------- | ------------------------------------------------------------- | ---------------------------------------------------------- |
| **Correlation check between features and demographics**     | Quantify relationships to detect proxies.                     | ZIP code correlated with race → potential bias.            |
| **Variance Inflation Factor (VIF) or pairwise correlation** | Detect multicollinearity that hides demographic signals.      | Highly correlated variables may duplicate bias.            |
| **Manual semantic audit**                                   | Inspect variable names and meanings to spot sensitive fields. | “School district” may correlate with socioeconomic status. |

**Conceptual insight:**

> “Data can discriminate quietly — through proxy variables that look harmless but encode group membership.”

---

### **5. Documentation and Transparency in Cleaning**

Students are taught to create a **data-audit trail**:

* Record each transformation (dropped columns, imputed fields, normalization rules).
* Capture reasoning for every decision.
* Note potential ethical implications (e.g., “dropping rows with missing gender may bias toward majority group”).

This is part of **responsible AI documentation** — essentially a simplified *data provenance log*.

---

### **6. Validation and Sanity Checks Post-Cleaning**

After cleaning, students perform:

* **Cross-tab checks** — verify that subgroup counts remain consistent.
* **Aggregate metric validation** — mean/median values by subgroup before vs. after cleaning.
* **Fairness delta check** — measure if disparities widened or narrowed after cleaning.

This reinforces the idea that **data cleaning itself is an intervention** that must be evaluated.

---

