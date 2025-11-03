# Module 2 - Quantitative (Non-Visual) Bias Metrics and Analysis Techniques

While the graphical methods reveal *where* imbalance exists, these **quantitative measures** let you **quantify, compare, and justify fairness outcomes** in numeric terms.
The instructor emphasizes that these are *conceptual tools*, not heavy-math exercises — they can be computed in Excel, with descriptive statistics, or even reasoned qualitatively for non-coders.

---

## **1. Group-Level Descriptive Metrics**

These are the simplest and most universal bias measures — suitable for any dataset.

| **Metric**                            | **Formula / Description**                           | **Interpretation / Bias Type**          | **Example**                                          |
| ------------------------------------- | --------------------------------------------------- | --------------------------------------- | ---------------------------------------------------- |
| **Group Count / Share**               | % of each subgroup in the dataset.                  | Representation / sampling bias.         | 60% male, 40% female → possible imbalance.           |
| **Outcome Rate (Success %)**          | (# positive outcomes per group) ÷ (total in group). | Detects label or historical bias.       | 75% acceptance rate for Group A vs. 40% for Group B. |
| **Disparity Ratio (Rate A / Rate B)** | Ratio between highest and lowest outcome rate.      | Quantifies magnitude of difference.     | 0.53 → Group B gets 53% of Group A’s positive rate.  |
| **Difference in Means**               | Mean(outcome A) − Mean(outcome B).                  | Highlights unequal continuous outcomes. | Avg. loan amount = $12 k vs. $9 k → $3 k gap.        |

These are the first statistics every student is expected to produce — no code needed.

---

## **2. Disparity-Based Fairness Metrics**

The course introduces (conceptually) **fairness definitions** used in data-science ethics and model evaluation.
Even though coding them is optional, understanding what each *means* is required.

| **Fairness Metric**                             | **Concept**                                                  | **Typical Use**                              | **Formula / Logic**                             |                    |        |
| ----------------------------------------------- | ------------------------------------------------------------ | -------------------------------------------- | ----------------------------------------------- | ------------------ | ------ |
| **Statistical Parity (aka Demographic Parity)** | All groups should have roughly equal positive-outcome rates. | Hiring / credit approval                     | ( P(\hat{Y}=1                                   | A=a) ≈ P(\hat{Y}=1 | A=b) ) |
| **Disparate Impact Ratio**                      | Ratio of positive-decision rates between groups.             | Regulatory threshold in U.S. law (80% Rule). | ( \text{DI} = P_1 / P_2 ); acceptable if ≥ 0.8. |                    |        |
| **Equal Opportunity Difference**                | True-positive rate should be equal across groups.            | Evaluating model fairness.                   | ( TPR_a − TPR_b ) ≈ 0.                          |                    |        |
| **Equalized Odds**                              | Both TPR and FPR should match across groups.                 | Ensures fairness in error distribution.      | Compare ( TPR, FPR ) for each group.            |                    |        |
| **Predictive Parity**                           | Positive predictions should be equally accurate.             | Credit risk / recidivism cases.              | ( PPV_a ≈ PPV_b ).                              |                    |        |
| **Calibration by Group**                        | Predicted probabilities match actual outcomes per group.     | Probabilistic models (e.g., scores).         | Compare binned predictions vs. actuals.         |                    |        |

The module doesn’t require computing these formulas but encourages describing whether your cleaned data *could* support such fairness tests later.

---

## **3. Error-Rate Metrics (for Those Doing Predictive Work)**

If students extend their data into a basic predictive model (optional), the instructor explains how **error patterns reveal bias**.

| **Metric**                      | **What It Measures**                           | **Bias Implication**                         |
| ------------------------------- | ---------------------------------------------- | -------------------------------------------- |
| **False Positive Rate (FPR)**   | % of negatives incorrectly labeled positive.   | Higher FPR for one group → unfair penalties. |
| **False Negative Rate (FNR)**   | % of positives missed.                         | Higher FNR → unfair denial of benefits.      |
| **Accuracy Gap**                | Difference in overall accuracy between groups. | Evaluation bias.                             |
| **Precision / Recall by Group** | Measure of correctness and coverage.           | Systematic performance differences.          |
| **Balanced Accuracy**           | Average of TPR and TNR across groups.          | Normalized view of group fairness.           |

Students are told that these can be calculated even in Excel with confusion-matrix counts.

---

## **4. Bias Auditing Ratios and Indices**

The instructor introduces several simplified *bias-index metrics* usable with only summary stats.

| **Metric / Index**            | **Definition**                                                    | **Interpretation**                                |
| ----------------------------- | ----------------------------------------------------------------- | ------------------------------------------------- |
| **Representation Index (RI)** | (Group share in data) ÷ (Group share in population).              | RI < 1 → underrepresented; > 1 → overrepresented. |
| **Label Bias Index**          | (Group positive label rate) ÷ (global average positive rate).     | Values ≠ 1 signal skew in labels.                 |
| **Impact Gap (Δ)**            | Difference in predicted probabilities or outcomes between groups. | Quantifies practical inequality.                  |
| **Composite Fairness Score**  | Weighted average of multiple bias metrics (qualitative summary).  | Used for reporting to stakeholders.               |

These indices allow a **bias audit table** — one of the main graded outputs in Module 2 — where students summarize disparities and proposed mitigations.

---

## **5. Data-Quality Metrics with Bias Lens**

Students revisit the *Module 1 data-quality checklist* but now quantify it per group.

| **Metric**                  | **How Quantified**                                  | **Bias Insight**                                     |
| --------------------------- | --------------------------------------------------- | ---------------------------------------------------- |
| **Completeness % by Group** | (# non-missing values per group) ÷ (total expected) | Unequal missingness shows sampling bias.             |
| **Consistency Score**       | % of records following expected format/range.       | Lower consistency in one group = measurement bias.   |
| **Timeliness Gap**          | Avg. data age difference between groups.            | Outdated records for certain groups = temporal bias. |

These can be expressed as percentages in a small table to accompany visuals.

---

## **6. Bias-Change Metrics (Pre- vs. Post-Cleaning)**

The module stresses *evaluating the effect of cleaning*.

| **Metric**               | **Purpose**                                         | **Example**                        |
| ------------------------ | --------------------------------------------------- | ---------------------------------- |
| **Δ Representation %**   | Compare group share before and after cleaning.      | Group B dropped from 25% → 18%.    |
| **Δ Outcome Rate**       | Change in positive rate per group after imputation. | F rate rose 3 points; M unchanged. |
| **Bias Reduction Ratio** | (Bias_before − Bias_after) ÷ Bias_before.           | Quantifies cleaning improvement.   |

Students are encouraged to *visualize* these changes alongside the numbers to check whether “fixing” data actually improved fairness.

---

## **7. Statistical Tests for Group Differences (Optional Advanced)**

For students with analytical background, the instructor briefly mentions:

* **t-tests / ANOVA** — compare means between groups.
* **Chi-square test** — compare categorical outcome distributions.
* **Kolmogorov–Smirnov test** — compare distributions of prediction scores.
* **Effect size (Cohen’s d)** — quantify magnitude of group differences.

These are introduced conceptually; students may perform them in Excel’s “Data Analysis ToolPak” or report qualitative interpretations.

---

## **8. Reporting Format: The Bias Audit Table**

Every student produces a “bias audit” summary resembling:

| **Attribute** | **Group A Rate** | **Group B Rate** | **Difference** | **Interpretation**       | **Proposed Mitigation**         |
| ------------- | ---------------- | ---------------- | -------------- | ------------------------ | ------------------------------- |
| Gender        | 0.75             | 0.45             | −0.30          | Underrepresentation of B | Oversample B, collect more data |
| Region        | 0.60             | 0.63             | +0.03          | Small variance           | Acceptable                      |
| Missingness   | 5 %              | 15 %             | +10 %          | Systematic data loss     | Investigate collection process  |

This demonstrates *quantitative reasoning + ethical interpretation* — exactly what the module grades.

---

## **9. Instructor’s Core Message**

> “If you can express bias in numbers, you can discuss it objectively — but never forget what those numbers represent: real people and real outcomes.”

He stresses that **metrics are diagnostic tools**, not moral absolutes — they inform trade-offs among fairness, accuracy, and business goals.

---

### **Summary of Part 2C**

| **Category**           | **Example Metrics**                                      | **Bias Type Assessed**     |
| ---------------------- | -------------------------------------------------------- | -------------------------- |
| Descriptive            | Group counts, rates, disparity ratios                    | Sampling / label bias      |
| Fairness definitions   | Statistical parity, equal opportunity, predictive parity | Algorithmic / outcome bias |
| Error rates            | FPR, FNR, accuracy gap                                   | Evaluation bias            |
| Data-quality per group | Completeness, timeliness                                 | Measurement bias           |
| Change over time       | Δ representation %, bias reduction ratio                 | Bias from cleaning steps   |

---

Would you like me to proceed with **Part 3: Module 3 – Leveraging Data for Principled Value Cultivation**, where the course shifts from fairness analysis to using data responsibly for *sustainable and ethical value creation*?
