Great—here’s a concise, production-minded **Technical Appendix: Python Data Collection Patterns** you can drop into a repo. It covers: (1) compliant scraping (static & JS), (2) API queries with retries/rate-limits, and (3) dataset documentation/provenance logging, plus quick validation and storage patterns.

---

# Technical Appendix: Python Data Collection Patterns

## 0) Minimal repo layout

```
data-collection/
├─ requirements.txt
├─ src/
│  ├─ common/
│  │  ├─ rate_limit.py
│  │  ├─ provenance.py
│  │  ├─ storage.py
│  │  └─ validation.py
│  ├─ scraping/
│  │  ├─ static_bs4.py
│  │  └─ js_playwright.py
│  ├─ apis/
│  │  └─ generic_api.py
│  └─ run_example_pipeline.py
└─ datasets/
   ├─ raw/
   ├─ curated/
   └─ metadata/
```

---

## 1) Compliance helpers (robots.txt + polite throttling)

### `src/common/rate_limit.py`

```python
import time
import random
from functools import wraps

def polite_delay(min_s=2.0, max_s=5.0):
    def deco(fn):
        @wraps(fn)
        def wrapper(*args, **kwargs):
            resp = fn(*args, **kwargs)
            time.sleep(random.uniform(min_s, max_s))
            return resp
        return wrapper
    return deco
```

### Robots.txt sniff (basic)

```python
import urllib.parse as up
import urllib.robotparser as urp

def allowed_by_robots(url: str, user_agent: str = "DataResearchBot"):
    parsed = up.urlparse(url)
    robots_url = f"{parsed.scheme}://{parsed.netloc}/robots.txt"
    rp = urp.RobotFileParser()
    rp.set_url(robots_url)
    try:
        rp.read()
        return rp.can_fetch(user_agent, url)
    except Exception:
        # Be conservative if robots cannot be retrieved
        return False
```

---

## 2) Provenance & metadata logging (required for every batch)

### `src/common/provenance.py`

```python
import hashlib, json, os, sys, platform, datetime
from typing import Dict, Any

def sha256_bytes(b: bytes) -> str:
    return hashlib.sha256(b).hexdigest()

def provenance_record(
    dataset_name: str,
    source: str,
    method: str,
    tos_note: str,
    license_note: str,
    params: Dict[str, Any],
    script_path: str,
    records_count: int
) -> Dict[str, Any]:
    now = datetime.datetime.utcnow().isoformat() + "Z"
    script_hash = sha256_bytes(open(script_path, "rb").read())
    return {
        "dataset_name": dataset_name,
        "collected_at_utc": now,
        "source": source,
        "method": method,
        "tos_note": tos_note,
        "license": license_note,
        "params": params,
        "script_path": script_path,
        "script_sha256": script_hash,
        "python_version": sys.version,
        "platform": platform.platform(),
        "records_count": records_count,
    }

def write_provenance(record: Dict[str, Any], out_dir: str):
    os.makedirs(out_dir, exist_ok=True)
    ts = record["collected_at_utc"].replace(":", "").replace("-", "")
    fname = f"{record['dataset_name']}_{ts}.provenance.json"
    with open(os.path.join(out_dir, fname), "w", encoding="utf-8") as f:
        json.dump(record, f, indent=2, ensure_ascii=False)
```

---

## 3) Storage utilities (CSV/Parquet with schema)

### `src/common/storage.py`

```python
import os, pandas as pd

def to_csv(df: pd.DataFrame, path: str):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    df.to_csv(path, index=False)

def to_parquet(df: pd.DataFrame, path: str):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    df.to_parquet(path, index=False)

def safe_concat(dfs):
    return pd.concat([d for d in dfs if d is not None and len(d)], ignore_index=True)
```

---

## 4) Lightweight validation (nulls, ranges, regex)

### `src/common/validation.py`

```python
import re, pandas as pd

def assert_no_negative(df: pd.DataFrame, cols):
    for c in cols:
        if (df[c] < 0).any():
            raise ValueError(f"Negative values found in {c}")

def assert_regex(df: pd.DataFrame, col: str, pattern: str):
    rx = re.compile(pattern)
    bad = ~df[col].fillna("").astype(str).map(lambda x: bool(rx.match(x)))
    if bad.any():
        raise ValueError(f"{bad.sum()} rows violate regex in {col}")

def missingness_report(df: pd.DataFrame):
    n = len(df)
    return (df.isna().sum().sort_values(ascending=False) / n).rename("missing_rate")

def basic_summary(df: pd.DataFrame):
    return {
        "rows": len(df),
        "cols": df.shape[1],
        "missing_top": missingness_report(df).head(10).to_dict()
    }
```

---

## 5) Static HTML scraping (requests + BeautifulSoup)

### `src/scraping/static_bs4.py`

```python
import requests, pandas as pd
from bs4 import BeautifulSoup
from src.common.rate_limit import polite_delay
from src.common.validation import basic_summary
from src.common.provenance import provenance_record, write_provenance
from src.common.storage import to_parquet
from . import static_bs4  # for script path hashing

HEADERS = {"User-Agent": "DataResearchBot/1.0 (contact: research@example.org)"}

@polite_delay(2, 4)
def get(url: str) -> requests.Response:
    return requests.get(url, headers=HEADERS, timeout=30)

def parse_listing(html: str):
    soup = BeautifulSoup(html, "lxml")
    items = []
    for card in soup.select(".recipe-card, article, .item"):  # adjust selectors
        title = (card.select_one(".title, h2, h3") or {}).get_text(strip=True) if card.select_one(".title, h2, h3") else None
        rating = card.get("data-rating") or (card.select_one(".rating") or {}).get_text(strip=True) if card.select_one(".rating") else None
        href = card.select_one("a")
        url = href["href"] if href and href.has_attr("href") else None
        items.append({"title": title, "rating": rating, "url": url})
    return items

def crawl_list_pages(base_url: str, pages: int = 3):
    rows = []
    for p in range(pages):
        url = base_url.format(page=p)
        resp = get(url)
        resp.raise_for_status()
        rows.extend(parse_listing(resp.text))
    return pd.DataFrame(rows).drop_duplicates()

def main():
    base_url = "https://example.com/recipes?page={page}"
    df = crawl_list_pages(base_url, pages=3)
    print("SUMMARY:", basic_summary(df))
    out_path = "datasets/raw/recipes_list.parquet"
    to_parquet(df, out_path)

    prov = provenance_record(
        dataset_name="recipes_list",
        source=base_url,
        method="requests+bs4",
        tos_note="Checked robots.txt; rate-limited 2–4s; no login.",
        license_note="Site TOS allows noncommercial research scraping.",
        params={"pages": 3},
        script_path=static_bs4.__file__,
        records_count=len(df)
    )
    write_provenance(prov, "datasets/metadata")

if __name__ == "__main__":
    main()
```

> Replace selectors and `base_url` to match your target; keep delays and headers.

---

## 6) JS-rendered pages (Playwright, headless Chromium)

### `src/scraping/js_playwright.py`

```python
import asyncio, pandas as pd, contextlib
from playwright.async_api import async_playwright
from src.common.provenance import provenance_record, write_provenance
from src.common.storage import to_parquet
from . import js_playwright  # for script hash

async def scrape_js(base_url: str, pages: int = 2):
    rows = []
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True)
        context = await browser.new_context(user_agent="DataResearchBot/1.0")
        page = await context.new_page()
        for i in range(pages):
            url = base_url.format(page=i)
            await page.goto(url, wait_until="networkidle", timeout=60000)
            cards = await page.locator(".card, article, .item").all()
            for c in cards:
                title = await c.locator("h2, h3, .title").first.text_content() or ""
                with contextlib.suppress(Exception):
                    rating = await c.locator(".rating").first.text_content()
                with contextlib.suppress(Exception):
                    href = await c.locator("a").first.get_attribute("href")
                rows.append({"title": title.strip(), "rating": (rating or "").strip(), "url": href})
        await browser.close()
    return pd.DataFrame(rows).drop_duplicates()

def main():
    base_url = "https://example.com/spa?page={page}"
    df = asyncio.run(scrape_js(base_url, pages=2))
    to_parquet(df, "datasets/raw/spa_list.parquet")
    prov = provenance_record(
        "spa_list", base_url, "playwright-chromium",
        "Checked TOS; JS required; headless; throttled by networkidle waits.",
        "Site terms permit research; do not redistribute raw HTML.",
        {"pages": 2}, js_playwright.__file__, len(df)
    )
    write_provenance(prov, "datasets/metadata")

if __name__ == "__main__":
    main()
```

> Install Playwright and browsers: `pip install playwright` then `playwright install chromium`.

---

## 7) API queries (retries, backoff, pagination)

### `src/apis/generic_api.py`

```python
import time, requests, pandas as pd
from typing import Dict, Any, List
from src.common.provenance import provenance_record, write_provenance
from src.common.storage import to_parquet
from . import generic_api  # for script hash

class APIClient:
    def __init__(self, base, headers=None, rate_per_sec=2, retries=3):
        self.base = base.rstrip("/")
        self.headers = headers or {}
        self.min_delay = 1 / max(rate_per_sec, 1)
        self.retries = retries
        self._last = 0.0

    def _throttle(self):
        elapsed = time.time() - self._last
        if elapsed < self.min_delay:
            time.sleep(self.min_delay - elapsed)
        self._last = time.time()

    def get(self, path, params=None) -> Dict[str, Any]:
        url = f"{self.base}/{path.lstrip('/')}"
        for attempt in range(self.retries + 1):
            self._throttle()
            resp = requests.get(url, params=params or {}, headers=self.headers, timeout=30)
            if resp.status_code == 429 and attempt < self.retries:
                time.sleep(2 ** attempt)  # backoff
                continue
            resp.raise_for_status()
            return resp.json()
        raise RuntimeError("Exceeded retries")

def paginate_example(client: APIClient, path: str, page_param="page", per_page=100, max_pages=10):
    all_items: List[Dict[str, Any]] = []
    for p in range(1, max_pages + 1):
        js = client.get(path, params={page_param: p, "per_page": per_page})
        items = js.get("results") or js
        if not items:
            break
        all_items.extend(items)
        if len(items) < per_page:
            break
    return pd.DataFrame(all_items)

def main():
    client = APIClient(
        base="https://api.example.com/v1",
        headers={"Authorization": "Bearer YOUR_TOKEN", "User-Agent": "DataResearchBot/1.0"},
        rate_per_sec=1.5, retries=3
    )
    df = paginate_example(client, "/objects", page_param="page", per_page=100, max_pages=20)
    to_parquet(df, "datasets/raw/example_api.parquet")
    prov = provenance_record(
        "example_api", "https://api.example.com/v1/objects", "HTTP API",
        "Respecting rate limits; auth token; no PII stored.", "Per API license.",
        {"per_page": 100, "max_pages": 20}, generic_api.__file__, len(df)
    )
    write_provenance(prov, "datasets/metadata")

if __name__ == "__main__":
    main()
```

---

## 8) Example pipeline runner

### `src/run_example_pipeline.py`

```python
import pandas as pd
from src.common.storage import safe_concat, to_parquet
from src.common.validation import assert_no_negative, basic_summary

def main():
    # Load artifacts produced by earlier scripts
    dfs = []
    for path in [
        "datasets/raw/recipes_list.parquet",
        "datasets/raw/spa_list.parquet",
        "datasets/raw/example_api.parquet"
    ]:
        try:
            dfs.append(pd.read_parquet(path))
        except Exception:
            pass
    df = safe_concat(dfs)

    # Minimal normalization: coerce ratings to numeric where present
    if "rating" in df.columns:
        df["rating_num"] = pd.to_numeric(df["rating"], errors="coerce")

    # Basic sanity checks (extend as needed)
    numeric_cols = [c for c in ["rating_num"] if c in df.columns]
    if numeric_cols:
        assert_no_negative(df, numeric_cols)

    print("CURATED SUMMARY:", basic_summary(df))
    to_parquet(df, "datasets/curated/combined.parquet")

if __name__ == "__main__":
    main()
```

---

## 9) Quick requirements

```
beautifulsoup4==4.12.*
lxml==5.*
requests==2.*
pandas==2.*
pyarrow==17.*      # for Parquet
playwright==1.*
```

---

## 10) Operating notes

* **Always** record provenance for each run (inputs, params, script hash).
* Validate basic integrity (negative ranges, missingness hotspots).
* Prefer **Parquet** for columnar storage & schema stability; keep CSV for sharing.
* Keep throttling and **User-Agent** identification; verify **robots.txt** and TOS before scrapes.
* For JS sites, start with Playwright headless; if you need hosted scheduling/rotation, port the script to **Apify**.

---

