Buiding a Quant Research Stack docker image.

* Data access (Yahoo, Quandl-like, etc.)
* Time-series analysis and stats
* Backtesting / event-driven research
* Portfolio analysis and optimization
* Plotting and notebook work

I’ll give you:

1. Updated **Dockerfile** (minimal changes, mostly comments)
2. Quant-focused **requirements.txt** (pip)
3. Quant-focused **environment.yml** (conda/mamba)
4. A quick note on what to use where

You can literally drop these into your `tf-gpu-template` folder and rebuild.

---

## 1. Dockerfile (quant-tuned, small edits)

Only differences vs the previous template:

* Slightly re-labeled comments for “quant stack”
* Nothing magic here; the real tuning is in `requirements.txt` and `environment.yml`.

```Dockerfile
# =====================================================================
# Base: Official TensorFlow GPU + Jupyter image
# =====================================================================
FROM tensorflow/tensorflow:latest-gpu-jupyter

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /tf

# ---------------------------------------------------------------------
# APT: system tools and basic build deps
# ---------------------------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        curl \
        wget \
        build-essential \
        nano \
        htop \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------------------
# Optional: small sample data baked in (you can remove this)
# ---------------------------------------------------------------------
RUN mkdir -p /tf/data && \
    wget -O /tf/data/README.txt "https://example.com/placeholder.txt" || true

# ---------------------------------------------------------------------
# PIP: Quant research Python stack
# ---------------------------------------------------------------------
COPY requirements.txt /tmp/requirements.txt

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r /tmp/requirements.txt

# ---------------------------------------------------------------------
# MAMBA / CONDA: heavy numeric + IO stack for quant work (optional)
# ---------------------------------------------------------------------
RUN wget -qO /tmp/mambaforge.sh \
      "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh" && \
    bash /tmp/mambaforge.sh -b -p /opt/mambaforge && \
    rm /tmp/mambaforge.sh && \
    /opt/mambaforge/bin/conda config --system --set auto_update_conda false && \
    /opt/mambaforge/bin/conda clean -afy

ENV PATH=/opt/mambaforge/bin:$PATH

COPY environment.yml /tmp/environment.yml

RUN mamba env update -n base -f /tmp/environment.yml && \
    conda clean -afy

# ---------------------------------------------------------------------
# Optional: post-start script wiring (kept simple for now)
# ---------------------------------------------------------------------
COPY scripts/post_start.sh /usr/local/bin/post_start.sh
RUN chmod +x /usr/local/bin/post_start.sh

EXPOSE 8888

# Optional non-root user – leave commented until you want it:
# RUN useradd -ms /bin/bash dev && \
#     chown -R dev:dev /tf
# USER dev
```

---

## 2. Quant-focused `requirements.txt` (pip)

This focuses on **Python quant libraries** that are pip-friendly and don’t need heavy conda management.

```text
##############################
# Core numeric / array stack #
##############################
numpy
pandas
scipy

##############################
# Visualization              #
##############################
matplotlib
seaborn
plotly
# Optional: interactive plotting in notebooks
# bokeh

##############################
# Time series & stats        #
##############################
statsmodels
arch                      # GARCH / volatility modeling
pmdarima                  # ARIMA auto-model selection (optional)

##############################
# Backtesting / trading      #
##############################
# Lightweight, Python-based backtesting engines
backtrader
vectorbt                   # vectorized backtesting / portfolio analysis
# zipline-reloaded         # can be tricky, leave commented unless you want the pain

##############################
# Data access / APIs         #
##############################
yfinance                   # Yahoo Finance data
pandas-datareader          # multiple remote sources (FRED, etc.)
alpha-vantage              # AlphaVantage API (you bring the key)
# ccxt                      # crypto exchange connectors (optional)

##############################
# Portfolio & optimization   #
##############################
cvxpy                       # convex optimization (for alloc / risk)
riskfolio-lib               # portfolio optimization / risk management

##############################
# ML / feature engineering   #
##############################
scikit-learn
xgboost
lightgbm

##############################
# Utilities                  #
##############################
tqdm
ipywidgets
jupyterlab
```

You can comment out anything you don’t want.
I’d keep at least: `numpy`, `pandas`, `scipy`, `matplotlib`, `seaborn`, `statsmodels`, `yfinance`, `scikit-learn`.

---

## 3. Quant-focused `environment.yml` (mamba/conda)

This is for **heavy numeric + IO libs** where conda shines (blas/lapack, arrow, hdf5, etc.) and to keep them cleanly versioned.

```yaml
name: base
channels:
  - conda-forge
dependencies:
  # You can pin Python if you want, but TF base already has it
  # - python=3.11

  ##################################
  # Numeric / linear algebra stack #
  ##################################
  - numpy
  - scipy
  - numba
  - bottleneck
  - numexpr

  ##################################
  # IO / data formats              #
  ##################################
  - pyarrow        # parquet / arrow tables
  - pytables       # HDF5 support
  - openpyxl       # Excel IO
  - xlrd           # legacy excel

  ##################################
  # Optimization / solvers         #
  ##################################
  - cvxopt         # lower-level convex optimization
  - glpk           # linear programming backend

  ##################################
  # Time handling / calendars      #
  ##################################
  - python-dateutil
  - pytz

  ##################################
  # Tools                          #
  ##################################
  - mamba
  - pip

  ##################################
  # Pip-only quant extras          #
  ##################################
  - pip:
      # Quant-related libs better handled via pip but specified here
      - ta                # technical analysis indicators
      - empyrical         # performance stats (like Quantopian style)
      - alphalens         # factor analysis (Quantopian-style, sometimes finicky)
      - ffns              # Fama-French data / regression helpers (optional)
```

Notes:

* Some of these might overlap with `requirements.txt` (e.g., `numpy`). That’s okay if the versions are consistent; for **least surprise**, you can choose to keep them only in one place.
* If you start to see version conflicts, we can pin specific versions (e.g., `numpy==1.26.*`, `pandas==2.2.*`) and rationalize who installs what.

---

## 4. How I’d actually use this stack

For day-to-day quant research:

* **Conda/Mamba** (environment.yml):

  * Heavier compiled libs like `pyarrow`, `pytables`, `cvxopt`, etc.
* **Pip** (requirements.txt):

  * Most quant libraries (`backtrader`, `vectorbt`, `riskfolio-lib`, `yfinance`, etc.)
  * ML libs (`xgboost`, `lightgbm`, `sklearn`)
  * Plotting and notebooks

### Build

From your template folder:

```bash
docker build -t tf-quant-research .
# or podman build -t tf-quant-research .
```

### Run

Interactive Jupyter:

```bash
docker run -it --gpus all \
  -p 8888:8888 \
  -v "$PWD":/tf \
  tf-quant-research
```

Then:

* Open the Jupyter URL with token that appears in logs.
* Create notebooks in `/tf` (which is your mounted project dir).

Interactive shell (for poking around):

```bash
docker run -it --gpus all \
  -p 8888:8888 \
  -v "$PWD":/tf \
  tf-quant-research \
  bash
```

Inside the container, you can quickly sanity check:

```bash
python -c "import numpy, pandas, statsmodels, yfinance, backtrader, vectorbt; print('OK')"
python -c "import cvxpy, riskfolio as rp; print('OK')"
```

---

