# Module 1 Project 

There is a genuine **gap between the instructional intent of JCB703 Module 1 and the real constraints students face** (Import.io limits, lack of coding background, and no alternative tools demonstrated).

The good news is that the **Module 1 project is primarily conceptual**, and success doesn’t depend on mastering code — it depends on your ability to **obtain, clean, and justify “the right data” ethically and purposefully**.

So, even if Import.io can’t be used, students can absolutely complete the project successfully using **a “hybrid low-code or assisted-no-code” workflow** built around three principles:

> **(1)** Use accessible, legal data sources
> **(2)** Focus on data quality and structure
> **(3)** Clearly document your process and reasoning

Here’s a detailed step-by-step approach that aligns with the learning goals, even without Import.io, HTML/CSS, or Python.

---

## **1. Re-interpret the Assignment’s Core Goals**

Module 1 is graded on:

* The **appropriateness of your dataset** for your chosen AI use case.
* The **completeness and cleanliness** of that dataset.
* The **clarity of your documentation** — how you obtained, inspected, and cleaned it.

You are **not graded on code execution**.
So your job is to *find and prepare data* — not necessarily to scrape it yourself.

---

## **2. Start with Accessible, Legal Data Sources**

Instead of scraping from websites, use **publicly available, downloadable datasets** that meet the same learning objectives.

### **Recommended repositories**

| Source                              | Description                      | URL                                                                                    |
| ----------------------------------- | -------------------------------- | -------------------------------------------------------------------------------------- |
| **Kaggle Datasets**                 | Free CSVs across every domain    | [https://www.kaggle.com/datasets](https://www.kaggle.com/datasets)                     |
| **Google Dataset Search**           | Meta-search of open datasets     | [https://datasetsearch.research.google.com](https://datasetsearch.research.google.com) |
| **data.gov**                        | U.S. government open data portal | [https://www.data.gov](https://www.data.gov)                                           |
| **UCI Machine Learning Repository** | Classic academic datasets        | [https://archive.ics.uci.edu/ml/index.php](https://archive.ics.uci.edu/ml/index.php)   |
| **FiveThirtyEight Data**            | Real-world journalistic datasets | [https://data.fivethirtyeight.com](https://data.fivethirtyeight.com)                   |

You can download a dataset **relevant to your business question**, then document:

* Why this dataset fits your objective.
* How you verified its structure and quality.

That fulfills the “data acquisition” portion of Module 1.

---

## **3. Clean and Inspect the Data Without Code**

If you’re not using Python or Jupyter, use the following **no-code/low-code tools**, all demonstrated in spirit (if not in the transcript) and aligned with course intent.

| Tool                                | Purpose                                            | How to use it                                                             |
| ----------------------------------- | -------------------------------------------------- | ------------------------------------------------------------------------- |
| **Microsoft Excel / Google Sheets** | Inspect, filter, sort, and clean tabular data      | Use “Remove Duplicates,” “Filter,” “Data → Clean up suggestions” (Sheets) |
| **OpenRefine**                      | Free GUI tool for data cleaning                    | Cluster similar strings, fix typos, split/merge columns                   |
| **ChatGPT** *(with CSV snippets)*   | Explain missing values, generate cleaning formulas | Paste sample rows and ask for cleaning logic in plain English             |
| **Tableau Public** (optional)       | Visualize outliers and distributions               | Drag-and-drop histograms and boxplots                                     |

Focus on:

* Removing duplicates
* Handling missing values (document the rule you chose)
* Checking for inconsistent formats (dates, capitalization, numeric types)
* Verifying data ranges and validity

You can document all cleaning steps in a short write-up or a worksheet tab.

---

## **4. Analyze Data Quality Conceptually**

Apply the **five-criteria framework** taught in the module:

| Criterion        | What to check                | How to show it                        |
| ---------------- | ---------------------------- | ------------------------------------- |
| **Completeness** | % of missing entries         | Count null or blank cells             |
| **Consistency**  | Same format/units            | Check for mixed units or text formats |
| **Validity**     | Values within logical bounds | Example: Ages 0-120                   |
| **Timeliness**   | Data freshness               | Last updated date                     |
| **Uniqueness**   | No duplicate IDs             | “Remove Duplicates” in Excel          |

Include a small table summarizing these findings — that’s your “data audit.”

---

## **5. Document Everything Clearly**

Your submission should read like a mini case study:

1. **Objective:** What problem are you exploring?
2. **Data Source:** Where and how you obtained the data.
3. **Cleaning Steps:** Specific issues found and how you resolved them.
4. **Ethical Reflection:** Privacy, bias, and data-use considerations.
5. **Next Steps:** How this dataset could feed an AI model.

You can write this directly in Word or Google Docs.
No coding notebook is required.

---

## **6. (Optional) Assisted Scraping with ChatGPT**

If you truly want to replicate the scraping experience:

* Pick a small website with tabular data (e.g., IMDb Top Movies, city weather data).
* Ask ChatGPT:

  > “Generate a simple Python script using `requests` and `BeautifulSoup` to scrape the title, rating, and year from IMDb Top Movies.”
* Copy the output into an **online Jupyter notebook** (Google Colab) and run it there — no local setup needed.
* Export to CSV.

You’ll see the process without needing to know HTML selectors in detail.

---

## **7. Summary: The Viable Path Without Import.io**

| Step                    | Tool                          | Outcome                                   |
| ----------------------- | ----------------------------- | ----------------------------------------- |
| **Data sourcing**       | Kaggle, Google Dataset Search | Obtain structured, legal dataset          |
| **Cleaning**            | Excel / Sheets / OpenRefine   | Handle missing data, duplicates, outliers |
| **Quality audit**       | Manual + visual               | Evaluate data on 5 criteria               |
| **Documentation**       | Word or PDF                   | Describe process, ethics, limitations     |
| **Optional enrichment** | ChatGPT + Google Colab        | Learn scraping conceptually               |

---

## **8. What Instructors Are Really Looking For**

* Did you **select a dataset intentionally** for an AI-relevant question?
* Did you **demonstrate awareness of data quality and ethics**?
* Can you **explain your cleaning logic clearly**?

If you do those three things — regardless of the tool used — you’ll fully meet Module 1 expectations.

---

### **Bottom Line**

> When Import.io or coding aren’t options, use an open dataset, clean it with Excel or OpenRefine, evaluate its quality using the five-criteria framework, and clearly document every decision.
> That path is fully aligned with the learning objectives and has been used successfully by many non-coding students.

---

Would you like me to show you a **specific example workflow** (e.g., using a Kaggle dataset) that mirrors what the Module 1 project expects — including what to write in each section of your report?
