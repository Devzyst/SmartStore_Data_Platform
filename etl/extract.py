"""Extract helpers for SmartStore ETL jobs."""

from pathlib import Path

import pandas as pd

def read_csv_dataset(path: str | Path) -> pd.DataFrame:
    """Read a CSV file into a DataFrame with a clear error if it is missing."""
    csv_path = Path(path)
    if not csv_path.exists():
        raise FileNotFoundError(f"Input dataset not found: {csv_path}")
    return pd.read_csv(csv_path)
