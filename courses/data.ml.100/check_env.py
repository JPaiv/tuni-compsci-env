"""Smoke test for the DATA.ML.100 environment.

Imports every library from requirements.txt, runs one small thing with each of
them and writes an Altair chart to chart.html. If this script finishes without
an error, the environment is ready.
"""

import altair as alt
import polars as pl
import pydantic
import requests
import yfinance as yf
from pydantic import BaseModel


class Observation(BaseModel):
    """A single measurement. Pydantic checks the types when we build one."""

    day: int
    value: float


def check_versions() -> None:
    print(f"polars   {pl.__version__}")
    print(f"pydantic {pydantic.VERSION}")
    print(f"requests {requests.__version__}")
    print(f"altair   {alt.__version__}")
    print(f"yfinance {yf.__version__}")


def check_offline() -> pl.DataFrame:
    """Pydantic validation -> polars DataFrame -> Altair chart. No network."""
    # Pydantic validates raw data. "3" becomes 3, a non-number would raise.
    raw = [{"day": d, "value": str(d * d)} for d in range(1, 11)]
    observations = [Observation(**item) for item in raw]

    df = pl.DataFrame([obs.model_dump() for obs in observations])

    # Altair describes the chart; save() renders it to a standalone HTML file.
    chart = (
        alt.Chart(df)
        .mark_line(point=True)
        .encode(x="day:Q", y="value:Q", tooltip=["day", "value"])
        .properties(title="Environment check", width=400, height=250)
    )
    chart.save("chart.html")
    return df


def check_online() -> None:
    """Download real prices and hand the pandas result over to polars.

    pl.from_pandas needs pyarrow here, because yfinance returns a timezone-aware
    datetime index that is not a plain numpy column.
    """
    prices = yf.Ticker("AAPL").history(period="5d").reset_index()
    df = pl.from_pandas(prices)
    print(df.select(["Date", "Open", "Close"]))


def main() -> None:
    check_versions()

    print()
    print(check_offline())

    print()
    try:
        check_online()
    except Exception as exc:  # noqa: BLE001 - any failure here means "no data"
        print(f"Skipped the yfinance download ({type(exc).__name__}: {exc}).")
        print("The rest of the environment is fine; check your network.")

    print()
    print("Wrote chart.html - open it in VS Code to view the chart.")


if __name__ == "__main__":
    main()
