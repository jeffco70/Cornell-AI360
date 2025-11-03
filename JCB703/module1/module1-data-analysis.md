# Module 1 data cleaning and data analysis approaches

The course’s goal is to make learners *operationally competent* in managing messy real-world datasets, preparing them for later bias and ethics analysis in Modules 2 and 3.

Below is a breakdown of what’s **actually taught**, organized by type of method:

---

## **1. Data Cleaning Approaches**

### **a. Handling Missing Data**

Students are shown how to:

* **Quantify missingness:**
  `df.isnull().sum()` and visual inspection of NaNs.
* **Remove rows/columns:**
  `df.dropna()` for low-value or incomplete records.
* **Impute values:**
  Replace missing numerical values with:

  * Mean, median, or mode (`df.fillna(df.mean())`).
  * Domain-specific defaults (e.g., “Unknown,” “0,” or prior average rating).
* **Analyze missing patterns:**
  Use heatmaps or missing-value matrices to identify systematic issues (e.g., all missing from a single source).

**Taught conceptually as**:

> “Treat missing data as an information signal — not just an error.”

---

### **b. Outlier Detection and Treatment**

Explicitly taught as part of “data health checks” before modeling:

* **Boxplot/IQR method:**

  * Calculate IQR = Q3 – Q1.
  * Flag data beyond `Q3 + 1.5*IQR` or `Q1 – 1.5*IQR`.
* **Z-score filtering:**
  `np.abs(stats.zscore(column)) > 3` for extreme numerical values.
* **Winsorization / capping:**
  Replace extreme values with boundary percentiles (1st and 99th).
* **Visual validation:**
  Outlier points are verified with `seaborn.boxplot()` or scatterplots.

These steps are directly demonstrated in the cleaning exercise that follows the web-scraping task.

---

### **c. Duplicate and Consistency Management**

Students clean scraped data that often contain duplicates:

* **Detect duplicates:**
  `df.duplicated()` and `df.drop_duplicates()`.
* **Standardize case and formatting:**
  `.str.lower()`, `.strip()`, `.replace()`.
* **Normalize units and scales:**
  Convert prices, times, or ratings to consistent units before analysis.

---

### **d. Data Type and Schema Normalization**

To make data analyzable:

* Convert text-encoded numbers (`"$3,450"`) to floats.
* Cast categories (`object` → `category`) for memory efficiency.
* Parse dates using `pd.to_datetime()`.
* Encode categorical features with one-hot encoding (`pd.get_dummies()`).

---

### **e. Data Quality Auditing**

Students apply a **five-criterion data-quality checklist** used throughout the course:

1. **Completeness** – Are all key fields populated?
2. **Consistency** – Are formats and units uniform?
3. **Validity** – Are values within expected ranges?
4. **Timeliness** – Is the data recent enough to be relevant?
5. **Uniqueness** – Are records distinct?

They use summary functions (`df.describe()`, `.info()`) and sampling to evaluate these metrics.

---

## **2. Data Analysis Approaches (Exploratory & Descriptive)**

Once data are cleaned, the course introduces **basic exploratory data analysis (EDA)** to evaluate structure and trends:

### **a. Descriptive Statistics**

* `df.describe()` for central tendency, spread, and distribution checks.
* Grouping and aggregation (`df.groupby()`) to examine relationships.
* Frequency tables (`value_counts()`) to evaluate categorical balance.

### **b. Visualization for Understanding**

Visual methods are emphasized to *see* data issues:

* **Histograms** – check skewness or multimodal distributions.
* **Boxplots** – reveal outliers and interquartile spread.
* **Scatterplots** – detect clustering or anomalies between variables.
* **Heatmaps / Correlation matrices** – find redundant or highly correlated variables.

### **c. Feature Screening**

Although not formal modeling, the transcript shows the instructor prompting students to:

* Identify **uninformative columns** (e.g., constant values).
* Examine **redundant attributes** (e.g., two correlated rating scales).
* Keep only those features that support the intended business question.

### **d. Sampling and Validation**

Students practice taking **random samples** to inspect data (`df.sample(5)`) and learn reproducibility by setting random seeds.

---

## **3. Framing Techniques (Analytical Thinking)**

Throughout the module, learners are coached to apply:

* **“Data → Insight → Action → Value” pipeline logic**, ensuring every transformation connects to a business or ethical goal.
* **Reflexive analysis:** Before running models, reflect on *what the data represent* and *who they might exclude*.
* **Iterative refinement:** Clean → check → visualize → refine again.

---

## **Summary of Taught Approaches**

| Category             | Approach                          | Example / Implementation         |
| -------------------- | --------------------------------- | -------------------------------- |
| Missing data         | Drop, impute, or flag             | `dropna()`, `fillna()`           |
| Outliers             | IQR, z-score, capping             | Boxplots, percentile clipping    |
| Duplicates           | Remove / deduplicate              | `drop_duplicates()`              |
| Normalization        | Standardize scales, types         | `to_datetime()`, `get_dummies()` |
| Data quality audit   | 5-criterion checklist             | completeness → uniqueness        |
| Descriptive analysis | Summary & visualization           | `describe()`, histograms         |
| Schema validation    | Enforce structure                 | column type checks               |
| Ethical checks       | Scraping legality, bias awareness | review ToS, reflect on inclusion |

---

**In short:**
Module 1 moves beyond theoretical cleanliness into a reproducible, Python-based data-pipeline discipline.
Students leave with a **practical skill set** in *data wrangling, validation, and exploratory analysis*—skills directly used later to detect bias and evaluate fairness.

---
