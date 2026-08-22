# 📊 DATA.ML.100

Introduction to Data Science and Machine Learning.

This folder holds the Python environment and the exercise scripts for the course.

## 🎯 How to start

1. Open the terminal

   - Select "Terminal" from the upper left menu bar

2. Navigate to this folder

   ```bash
   cd courses/data.ml.100
   ```

   cd means "change directory." This allows you to navigate the file system.

3. Create the Python virtual environment

   ```bash
   python3 -m venv venv
   ```

4. Activate the virtual environment

   ```bash
   source venv/bin/activate
   ```

   The prompt now starts with `(venv)`. Run `deactivate` to leave it.

5. Install the dependencies

   ```bash
   pip install -r requirements.txt
   ```

6. Check that everything works

   ```bash
   python3 check_env.py
   ```

   The script prints the version of every library and writes `chart.html`.
   Right-click the file and choose "Open with Live Preview" to view the chart.

7. Run a script

   ```bash
   python3 stock_markets_plotting.py
   ```

## 📦 The stack

| Library        | Used for                                                           |
| -------------- | ------------------------------------------------------------------ |
| **polars**     | DataFrames. Reading CSV/Parquet, filtering, grouping, joining.     |
| **pydantic**   | Validating data that comes from outside, e.g. JSON from a web API. |
| **yfinance**   | Downloading share prices and other market data from Yahoo Finance. |
| **requests**   | Downloading data over HTTP when there is no ready-made library.    |
| **altair**     | Declarative charts. Describe what to show, not how to draw it.     |
| **matplotlib** | Imperative charts. More control, and saves straight to PNG.        |
| pyarrow        | Not used directly. Lets polars read yfinance's pandas DataFrames.  |
| black, ruff    | Formatting and linting. Keeps the code style consistent.           |

### 🔁 yfinance gives you pandas, not polars

yfinance returns **pandas** DataFrames, because it pulls in pandas as a
dependency. Convert once, at the edge, then stay in polars:

```python
import polars as pl
import yfinance as yf

prices = yf.Ticker("AAPL").history(period="1mo").reset_index()
df = pl.from_pandas(prices)
```

`reset_index()` matters: yfinance puts the date in the pandas _index_, and an
index is not a column, so it would be lost in the conversion.

## 🇫🇮 Downloading the OMX Helsinki 25 companies

There is **no free API that returns index membership**. Three things were tried
against the Yahoo components page:

| Attempt                                  | Result                            |
| ---------------------------------------- | --------------------------------- |
| `requests.get` on the components page    | 404 - Yahoo blocks plain clients  |
| Browser-impersonating client (curl_cffi) | 200, but zero tickers in the HTML |
| Nasdaq Nordic index endpoints            | Redirect to a generic page        |

The page builds its table in JavaScript after loading, so the HTML that arrives
over HTTP contains no ticker symbols at all. Scraping it would need a headless
browser, which is a lot of machinery for 25 strings that change twice a year.

So the list lives as the `OMXH25` constant in `stock_markets_plotting.py`.
Check it against the page after Nasdaq's reviews in January and July.

Downloading the prices is the easy half - pass the whole list to `yf.download`
and it fetches them in one request:

```python
raw = yf.download(list(OMXH25), period="1y", interval="1d", auto_adjust=True)
close = raw["Close"].reset_index()
df = pl.from_pandas(close).unpivot(
    index="Date", variable_name="ticker", value_name="close"
)
```

`unpivot` turns the 25 price columns into `ticker` / `close` rows. Altair needs
this long shape to draw one line per company.

Helsinki tickers end in `.HE` and are trading codes, not names: `KNEBV.HE` is
Kone, `WRT1V.HE` is Wartsila, `NDA-FI.HE` is Nordea.

## 📈 Viewing charts

The devcontainer has no browser and no desktop, so nothing pops up in a window.
Charts are written to a file that VS Code opens directly.

**Matplotlib** needs the `Agg` backend, which draws into a file instead of a
window. Set it before importing `pyplot`, or the import tries to find a display
and fails:

```python
import matplotlib

matplotlib.use("Agg")

import matplotlib.pyplot as plt
```

Then `fig.savefig("nokia.png")`. Click the PNG in the file explorer to view it.

**Altair** saves a standalone page instead:

```python
chart.save("chart.html")
```

That HTML pulls the Vega libraries from a CDN, so viewing it needs a network
connection. The PNG has no such dependency.

Matplotlib reads plain Python sequences, so a polars DataFrame needs no
conversion - pass the columns straight in:

```python
ax.plot(df["Date"].to_list(), df["Close"].to_list())
```

## 🌐 What is a virtual environment?

An isolated environment that keeps this course's dependencies separate from every
other project on the machine, which prevents version conflicts. Using one is the
recommended practice in Python.

The `venv/` folder is ignored by Git, so it never ends up in a commit. Everyone
recreates it locally from `requirements.txt`.

## 📄 Requirements

`requirements.txt` lists the external Python dependencies with pinned versions,
so that everyone works against the exact same library versions.

## 🩺 Troubleshooting

**Pylance says an import cannot be resolved.**
VS Code is using the wrong Python. The workspace settings already bind this
folder to its own `venv`, so the usual fix is to reload the window: open the
Command Palette with `F1` (or the View menu -> Command Palette) and run
"Developer: Reload Window".

To set it by hand, run "Python: Set Project Environment" and pick the one under
`courses/data.ml.100/venv`. Note the command is **not** called "Python:
Select Interpreter" - the Python Environments extension renamed it.

**Pylance says `Object of type "() -> Session" cannot be used with "with"`.**
You wrote `requests.session` where you meant `requests.Session()`. Lowercase
`session` is a _factory function_ — its type is literally `() -> Session`, which
is what the message is quoting back at you. Either call it, `requests.session()`,
or use the class directly:

```python
with requests.Session() as ses:
    rsp = ses.get(url)
```

Same shape of mistake for any `with` statement: the thing after `with` has to be
an _object_, not the function that makes one.

**Pylance says `Type of "DataFrame" is unknown`** (or `Type of "df" is unknown`).
Two things have to be true for this message to appear, and fixing either one
clears it:

1. VS Code is not using the course venv, so `import polars` fails and everything
   reached through `pl.` is an unknown type. Fix the interpreter, above.
2. Type checking is set to `strict`. The course libraries yfinance and pandas
   ship no type information at all, so strict mode has nothing to work with and
   reports every value coming out of them as unknown. This workspace sets
   `python.analysis.typeCheckingMode` to `basic` for that reason.

**A yfinance download fails or returns nothing.**
Yahoo rate-limits heavy use. Wait a moment and retry, and while developing
prefer a short `period` such as `"5d"` over `"max"`.
