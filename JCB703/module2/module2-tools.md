# Module 2 - Tools - No Code to some code options

While the instructor repeatedly encourages using **S.A.I. (the “Smart Assistant Interface,” i.e., ChatGPT)** for conceptual reasoning, reflection prompts, and even exploratory analysis guidance, the course also identifies and demonstrates several **complementary tools and resources** that students can use for *data auditing, bias visualization, and fairness reporting*.

These tools span **three tiers**: (1) no-code / visual tools, (2) low-code analytical platforms, and (3) professional or open-source fairness toolkits.
Let’s go through them systematically.

---

## **1. No-Code and Visual Tools**

*(For non-programmers — fully supported in course demonstrations and project guidance)*

| **Tool**                            | **Purpose in Module 2**                                              | **How It’s Used / Mentioned**                                                                                    | **Why It’s Relevant to Bias Analysis**                                                 |
| ----------------------------------- | -------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- |
| **Microsoft Excel / Google Sheets** | Core environment for bias identification and descriptive statistics. | Instructor demonstrates pivot tables, grouped summaries, and charts for comparing outcomes by demographic group. | Accessible to all students; supports bar charts, 100 % stacked charts, and cross-tabs. |
| **Tableau Public** *(free)*         | Visualizes disparities and missingness interactively.                | Suggested for exploring distributions and subgroup representation via drag-and-drop.                             | Helps see intersectional or geographic bias visually without coding.                   |
| **Power BI Desktop**                | Similar to Tableau; good for ratio and KPI dashboards.               | Mentioned as an alternative if students already use Microsoft products.                                          | Allows creation of a “Bias Audit Dashboard.”                                           |
| **OpenRefine**                      | Cleaning tool introduced in Module 1 but reused here.                | Used to cluster inconsistent labels (e.g., “Male / male / M”).                                                   | Reduces measurement bias before quantitative comparison.                               |
| **Datawrapper / Flourish**          | Online visualization platforms.                                      | Recommended for students who want publication-quality bar or heat maps for their bias reports.                   | Lets students communicate disparities clearly without coding.                          |

> *Instructor emphasis:* “Use whatever visualization tool you’re comfortable with — the goal is clarity, not syntax.”

---

## **2. Low-Code / Analytical Environments**

*(For students with limited scripting ability — optional but encouraged)*

| **Tool**                              | **Function**                                                            | **Module 2 Application**                                                       | **Example Use**                                                               |
| ------------------------------------- | ----------------------------------------------------------------------- | ------------------------------------------------------------------------------ | ----------------------------------------------------------------------------- |
| **Jupyter Notebook / Google Colab**   | Browser-based Python notebook (no install needed).                      | Optional environment for running fairness calculations and correlation checks. | Run Pandas `groupby()` or Seaborn boxplots on demographic splits.             |
| **Python + Pandas / NumPy / Seaborn** | Data wrangling and visualization.                                       | Demonstrated conceptually for bias detection.                                  | Calculate group outcome rates, correlation matrices, or missingness heatmaps. |
| **R Studio (tidyverse)**              | Statistical alternative for those familiar with R.                      | Mentioned briefly as an equivalent to Pandas/Seaborn.                          | Perform ANOVA or Chi-square tests for group differences.                      |
| **Google Sheets Add-ons**             | Quick statistical summaries (Descriptive Stats, Data Analysis Toolpak). | Suggested for students avoiding code notebooks.                                | Compute mean/median by group to check disparities.                            |

These tools let semi-technical students reproduce fairness metrics (e.g., disparity ratios, false-positive gaps) with only a few lines of code or built-in menu actions.

---

## **3. Professional / Fairness-Specific Toolkits**

*(Mentioned conceptually as “industry examples” for students to explore beyond the course)*

| **Toolkit**                      | **Developer**      | **Capability**                                                       | **Use Case Discussed in Module 2**                                                                                      |
| -------------------------------- | ------------------ | -------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| **IBM AI Fairness 360 (AIF360)** | IBM Research       | Comprehensive open-source library for measuring and mitigating bias. | Referenced as a model framework implementing the fairness metrics taught (Statistical Parity, Equal Opportunity, etc.). |
| **Google What-If Tool**          | Google PAI         | Visual, browser-based model inspection tool.                         | Shown as a demonstration of how to visualize bias and threshold effects across subgroups.                               |
| **Microsoft Fairlearn**          | Microsoft Research | Fairness metrics and dashboard for model evaluation.                 | Discussed when covering “equalized odds” and post-processing adjustments.                                               |
| **DataRobot AI Bias Monitor**    | DataRobot          | Enterprise SaaS example of continuous bias auditing.                 | Used in lecture slides to illustrate ongoing fairness monitoring.                                                       |

> These toolkits aren’t required for assignments, but are presented so students can see *how ethical AI principles are operationalized in practice.*

---

## **4. Ethical and Policy-Reference Tools**

*(Non-technical resources that support fairness thinking)*

| **Resource**                                         | **Function**                                                                                         |
| ---------------------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| **AI Ethics Guidelines (OECD, EU AI Act summaries)** | Frameworks for evaluating fairness, accountability, and transparency.                                |
| **The AI Incident Database**                         | Repository of real-world bias failures; used for reflection exercises.                               |
| **Model Cards for AI (Google PAI template)**         | Structured documentation template for describing data sources, metrics, and fairness considerations. |

Students are encouraged to consult these while writing their “Bias Audit” and “Ethical Reflection” deliverables.

---

## **5. Recommended Workflow (Non-Coder Friendly)**

1. **Excel / Sheets** – Clean and tabulate data by group.
2. **Tableau Public** – Visualize disparities and missingness.
3. **ChatGPT (S.A.I.)** – Interpret visuals, draft fairness language, and generate metric formulas.
4. **Optional:** Run fairness checks in **Google Colab** using sample code generated by ChatGPT.
5. **Document results** in Word using bias tables and annotated charts.

---

## **Instructor’s Key Guidance**

> “Choose the simplest tool that lets you *see* and *explain* bias clearly.
> Don’t let technology hide the ethics — let it reveal them.”

Thus, the expectation is not mastery of libraries or frameworks, but rather competent use of **accessible analytical and visualization tools** that make disparities transparent and reproducible.

---

### ✅ **Summary: Tools Suggested Beyond S.A.I.**

| **Category**            | **Examples**                                              | **Primary Purpose**                     |
| ----------------------- | --------------------------------------------------------- | --------------------------------------- |
| No-code / Visual        | Excel, Sheets, Tableau, Power BI, Datawrapper, OpenRefine | Basic analysis and visualization        |
| Low-code / Analytical   | Jupyter / Colab, Pandas, Seaborn, R Studio                | Quantitative fairness metrics           |
| Professional / Research | IBM AIF360, Google What-If, Microsoft Fairlearn           | Advanced bias diagnostics               |
| Ethical / Framework     | OECD Guidelines, Model Cards for AI                       | Contextual reflection and documentation |



---
