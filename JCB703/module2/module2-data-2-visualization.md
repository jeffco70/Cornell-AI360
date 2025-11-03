# Bias detection begins with visualization

The instructor repeatedly emphasizes that **graphical techniques are the most intuitive, transparent, and accessible way** to reveal bias — especially for students without coding backgrounds.

Below is a complete list of **visualization and graphical analysis methods** discussed, recommended, or demonstrated in the course, organized by bias type and learning objective.

---

## **1. Group-Comparison Visuals**

*(Detect differences in representation or outcomes across groups)*

These are the most fundamental graphics for identifying bias, and the ones the instructor encourages every student to use — even in Excel or Google Sheets.

| **Technique**                 | **Purpose**                                                                          | **What to Look For**                                     | **Tool / Implementation**                                        |
| ----------------------------- | ------------------------------------------------------------------------------------ | -------------------------------------------------------- | ---------------------------------------------------------------- |
| **Bar charts (side-by-side)** | Compare outcome rates between groups (e.g., male vs. female, region A vs. region B). | Visible gaps in height indicate outcome disparities.     | Excel “Clustered Bar” chart, Tableau, or Matplotlib `barplot()`. |
| **Stacked bar charts**        | Show proportional composition of classes within each group.                          | Check whether one group dominates the dataset.           | Pivot table → chart in Excel, or Seaborn `countplot()`.          |
| **100% stacked bar charts**   | Normalize totals to compare relative proportions, not absolute counts.               | Reveal imbalance even in unequal sample sizes.           | Excel → “Stacked 100%” bar.                                      |
| **Grouped column charts**     | Compare multiple outcomes (e.g., True/False or 0/1) per demographic group.           | Identify unequal model performance or data distribution. | Excel or Pandas `.plot(kind='bar')`.                             |

**Example insight:**
If acceptance rates are 75% for Group A and 45% for Group B → potential sampling or label bias.

---

## **2. Distribution Visuals**

*(Explore differences in numeric variable distributions across groups)*

| **Technique**             | **Purpose**                                                            | **Bias Type Detected**                            | **Notes**                                                     |
| ------------------------- | ---------------------------------------------------------------------- | ------------------------------------------------- | ------------------------------------------------------------- |
| **Boxplots (by group)**   | Compare median, spread, and outliers of a feature across demographics. | Sampling bias, measurement bias                   | Useful for income, test scores, or prediction scores.         |
| **Violin plots**          | Combine boxplot + density shape to see distribution asymmetry.         | Skew or unequal variability                       | More informative than plain boxplots when group sizes differ. |
| **Histograms (by group)** | Show distribution overlap or separation between groups.                | Systematic bias in measurement or feature scaling | If histograms barely overlap → possible structural bias.      |
| **Density plots (KDE)**   | Show smoothed probability curves for each group.                       | Subtle distribution shifts                        | Use transparency to compare.                                  |

**Example:**
Prediction scores for “African American” vs. “Caucasian” groups — one curve consistently lower → algorithmic bias.

---

## **3. Representation and Sampling Visuals**

*(Check balance and completeness of the dataset)*

| **Technique**                        | **Purpose**                                                                                 | **Bias Revealed**                                                           |
| ------------------------------------ | ------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------- |
| **Pie charts or donut charts**       | Quick overview of dataset composition by demographic category.                              | Underrepresentation bias.                                                   |
| **Treemaps**                         | Visualize proportional representation in hierarchical data (e.g., region → gender → class). | Hidden imbalance within subgroups.                                          |
| **Missingness heatmap**              | Visualize missing data patterns.                                                            | Systematic missingness correlated with demographic variables (MAR or MNAR). |
| **Bar chart of missing percentages** | Quantify missing data per column or subgroup.                                               | Identify biased data completeness.                                          |

**Instructor note:**

> “Don’t just check if data are missing — check *who* they’re missing for.”

---

## **4. Correlation and Association Visuals**

*(Detect proxy or feature-level bias)*

| **Technique**                            | **Purpose**                                                                | **What to Watch For**                                            |
| ---------------------------------------- | -------------------------------------------------------------------------- | ---------------------------------------------------------------- |
| **Correlation heatmap**                  | Detect features correlated with sensitive attributes (e.g., gender, race). | Strong correlations → potential proxies (e.g., ZIP code ≈ race). |
| **Pairplot (scatterplot matrix)**        | Explore how two or more features differ by group.                          | Non-overlapping clusters by color → bias or segmentation.        |
| **Scatterplots with color-coded groups** | Examine continuous relationships by demographic group.                     | Different slopes/intercepts → aggregation bias.                  |

**Example insight:**
A scatterplot of credit limit vs. income colored by gender shows a systematically lower trend line for women → potential bias in credit assignment.

---

## **5. Model or Outcome-Focused Visuals**

*(Evaluate bias in prediction or decision outcomes — even with conceptual models)*

| **Technique**                  | **Purpose**                                                       | **Bias Type**                  | **Implementation**                                                      |
| ------------------------------ | ----------------------------------------------------------------- | ------------------------------ | ----------------------------------------------------------------------- |
| **Confusion matrix (heatmap)** | Compare true vs. predicted outcomes per group.                    | Evaluation bias                | Especially relevant if classifier overpredicts positives for one group. |
| **ROC curves (by group)**      | Visualize model sensitivity/specificity trade-offs for subgroups. | Performance disparity          | Optional for more technical students.                                   |
| **Error-rate bar chart**       | Display false positive/negative rates per group.                  | Evaluation or algorithmic bias | Excel bar chart or Tableau view.                                        |

**Even non-coders** can do this conceptually using pivot tables:
e.g., “% of misclassified cases by demographic group.”

---

## **6. Intersectional and Multivariate Visuals**

*(Understand how multiple categories interact)*

| **Technique**                 | **Purpose**                                                                | **Bias Revealed**                                |
| ----------------------------- | -------------------------------------------------------------------------- | ------------------------------------------------ |
| **Clustered heatmap**         | Cross-tab two demographics (e.g., gender × region) to view representation. | Intersectional bias.                             |
| **Bubble charts**             | Encode group frequency (size) and outcome (color).                         | Multi-dimensional imbalance.                     |
| **Parallel coordinate plots** | Visualize patterns across multiple attributes.                             | Compound or intersectional bias across features. |

**Instructor note:**

> “Bias often hides in intersections — a dataset can look balanced overall but fail when you drill into combined categories.”

---

## **7. Pre- vs. Post-Cleaning Comparison Visuals**

*(Verify that data cleaning didn’t make bias worse)*

| **Technique**                          | **Purpose**                                                            | **Description**                                                              |
| -------------------------------------- | ---------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| **Before-and-after bar charts**        | Compare representation of groups before and after cleaning/imputation. | Ensure that dropping rows or imputing didn’t reduce minority representation. |
| **Delta plots (change visualization)** | Show changes in group averages or counts pre/post-cleaning.            | Identify if your cleaning step favored one group.                            |

**Concept reinforced:**

> “Every cleaning action changes the data distribution — visualize those changes to confirm they’re fair.”

---

## **8. Communication and Ethical Visualization Practices**

The instructor also discusses how to **present bias findings responsibly**:

* Always **label axes clearly** (avoid deceptive scales).
* Use **consistent colors** for groups throughout all charts.
* Avoid **sensationalizing disparities** — the goal is clarity, not blame.
* Provide short interpretive captions explaining the pattern and its implications.
* When possible, **combine visuals and text** (“The following chart shows that women are underrepresented in high-income brackets after cleaning the data.”).

---

### **Practical Note for Non-Coders**

All of these visuals can be created using:

* **Excel / Google Sheets** (pivot tables + charts)
* **Tableau Public** (free)
* **Power BI Desktop**
* or **ChatGPT + Python snippets** if you want to automate comparisons.

The module emphasizes *visual evidence over code sophistication*.

---

## **9. Summary Table**

| Visualization Type  | Main Bias Type Detected         | Example Use                                   |
| ------------------- | ------------------------------- | --------------------------------------------- |
| Bar / stacked bar   | Representation bias             | Group A = 80%, Group B = 20%                  |
| Boxplot / violin    | Measurement or scaling bias     | Median difference by group                    |
| Heatmap             | Missingness or correlation bias | Systematic data gaps                          |
| Correlation matrix  | Proxy or feature bias           | ZIP code correlated with race                 |
| Confusion matrix    | Evaluation bias                 | Model errors skewed to one group              |
| ROC curves          | Performance disparity           | One group’s AUC lower                         |
| Bubble / treemap    | Intersectional bias             | Group × region imbalance                      |
| Before/after charts | Cleaning-introduced bias        | Minority group reduced by 10% after filtering |

---

### **Key Takeaway from Module 2**

> “If you can see the imbalance, you can explain it — and if you can explain it, you can fix it.”

Bias detection starts with **visual pattern recognition**, and the instructor insists that ethical AI work *always begins with a chart*, not a model.

---

