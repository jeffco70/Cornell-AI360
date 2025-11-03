
# Module 2 - Non-code Tool Stack

**ChatGPT (especially GPT-5 level models)** can now perform a major share of the **data cleaning, descriptive analysis, and bias auditing workflow**, directly from a dataset you upload (CSV, XLSX, etc.) — *without requiring Python, Jupyter, or any installed tool*.

Below is a **fully integrated no-code bias-audit stack**, designed for a student who wants to rely primarily on ChatGPT and lightweight companion tools.

---

## ✅ **Updated No-Code Tool Stack (with ChatGPT as Core Engine)**

| **Stage**                                     | **Goal**                                                             | **Primary Tool(s)**                                                           | **Why / How ChatGPT Fits**                                                                                                                                                                         |
| --------------------------------------------- | -------------------------------------------------------------------- | ----------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1️⃣ **Data Access & Inspection**              | Bring data into an analyzable format.                                | **ChatGPT + Excel / Sheets / OpenRefine**                                     | Upload your CSV or Excel file directly to ChatGPT. Ask it to summarize, describe column types, detect missing values, and flag inconsistencies.                                                    |
| 2️⃣ **Data Cleaning**                         | Identify and correct errors, missing data, outliers, and duplicates. | **ChatGPT (primary)**                                                         | ChatGPT can generate cleaning summaries, impute missing values, remove duplicates, standardize categories (“Male/male/M”), and return a cleaned dataset ready for download.                        |
| 3️⃣ **Representation & Missingness Analysis** | Quantify and visualize data balance across groups.                   | **ChatGPT (data analysis mode)**                                              | Request group counts, cross-tabs, missing-value percentages, and bias-oriented summary tables. ChatGPT can produce pivot-style tables automatically.                                               |
| 4️⃣ **Visual Bias Detection**                 | Reveal disparities visually.                                         | **ChatGPT (built-in plotting)** + **Tableau Public / Datawrapper (optional)** | Ask ChatGPT to plot bar charts, boxplots, stacked bars, or heatmaps comparing groups. Export as images for your report. For publication-quality visuals, re-create them in Tableau or Datawrapper. |
| 5️⃣ **Quantitative Bias Metrics**             | Compute fairness and disparity statistics.                           | **ChatGPT (statistical mode)**                                                | Ask for Statistical Parity Ratio, Disparate Impact, outcome gaps, or representation indices. ChatGPT will compute and interpret them in plain language.                                            |
| 6️⃣ **Bias Audit Documentation**              | Create your summary table and interpret results.                     | **ChatGPT + Word / Google Docs**                                              | Have ChatGPT draft your bias-audit table and narrative. Then refine wording in Word/Docs.                                                                                                          |
| 7️⃣ **Ethical Reflection & Recommendations**  | Translate findings into responsible-AI actions.                      | **ChatGPT (writing + synthesis)**                                             | Use ChatGPT to connect numeric results to ethical and business implications, referencing fairness principles.                                                                                      |

---

## 🧭 **Revised Workflow (ChatGPT-Centered)**

### **Step 1 – Upload and Inspect**

* Upload your dataset to ChatGPT (“Analyze this CSV for completeness and bias risk”).
* ChatGPT lists:

  * column types
  * missing-value percentages
  * possible categorical encodings
  * duplicate count
  * basic summary stats

*Output:* quick diagnostic report.

---

### **Step 2 – Clean the Data**

Ask ChatGPT:

> “Clean this dataset by standardizing category labels, removing duplicates, and imputing missing numeric values with medians.”

It can:

* unify case and spelling,
* fill missing values,
* handle outliers (via IQR/z-score trimming),
* and return a downloadable cleaned file.

*(No Excel scripting required.)*

---

### **Step 3 – Evaluate Representation and Missingness**

Prompt examples:

* “Show the percentage of each gender and region.”
* “Which group has the highest missing-value rate?”
* “Create a bar chart comparing group counts.”

ChatGPT will compute counts, ratios, and produce a visual automatically.

---

### **Step 4 – Quantify Bias**

You can run fairness checks in plain English:

* “Compute the disparate-impact ratio for male vs. female outcomes.”
* “Calculate statistical parity difference for approval rates.”
* “List false-positive and false-negative counts by group.”

ChatGPT will provide the formulas, values, and interpret whether they exceed the 80 % rule threshold.

---

### **Step 5 – Visualize Bias**

Ask ChatGPT to:

* Draw side-by-side bar charts for outcome rates per group.
* Create boxplots of prediction scores by demographic variable.
* Plot a heatmap of missingness.

It will generate static images you can embed directly in your report.

---

### **Step 6 – Document Findings**

Prompt example:

> “Summarize these results in a bias audit table and write a 200-word explanation of what these disparities mean and how to mitigate them.”

ChatGPT will output both a table and polished narrative you can paste into Word.

---

### **Step 7 – Optional External Tools**

| Purpose            | Recommended Companion                                |
| ------------------ | ---------------------------------------------------- |
| Touch-up visuals   | Tableau Public / Datawrapper                         |
| Manual inspection  | Excel / OpenRefine                                   |
| Report layout      | Word / Google Docs                                   |
| Ethical references | OECD AI Principles, EU AI Act summaries (web search) |

---

## **Example Minimal Tool Stack**

| **Role**                                           | **Tool**                      |
| -------------------------------------------------- | ----------------------------- |
| Data cleaning, analysis, visualization, reflection | **ChatGPT (core engine)**     |
| Optional manual editing                            | Excel or Sheets               |
| Presentation-grade visuals                         | Datawrapper or Tableau Public |
| Final report assembly                              | Word or Google Docs           |

---

## **Instructor-Aligned Guidance**

> “Use the tools that make the data transparent and interpretable.
> If an AI assistant can clean, visualize, and explain the bias — that’s precisely the point: using AI responsibly to evaluate AI.”

This revised stack satisfies the **Module 2 project** entirely in a **no-code environment**, and demonstrates digital literacy plus ethical reasoning — exactly what the course assesses.

---

