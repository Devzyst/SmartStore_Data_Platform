import logging
import os
import sys
from pathlib import Path

from extract import read_csv_dataset
from load import load_dataframe
from transform import clean_orders

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")


def run_orders_pipeline(csv_path: str | Path, target_table: str = "orders_staging") -> None:
    """Extract, transform, and load generated order records."""
    logging.info("Extracting order dataset from %s", csv_path)
    raw_orders = read_csv_dataset(csv_path)
    clean_orders_df = clean_orders(raw_orders)
    logging.info("Loading %s clean order rows into %s", len(clean_orders_df), target_table)
    load_dataframe(clean_orders_df, target_table, if_exists="replace")
    logging.info("ETL pipeline completed successfully")


if __name__ == "__main__":
    default_path = Path(os.getenv("DATA_OUTPUT_DIR", "generated_data")) / "orders.csv"
    input_path = Path(sys.argv[1]) if len(sys.argv) > 1 else default_path

    if len(sys.argv) == 1 and not input_path.exists():
        from pathlib import Path as _Path
        from sys import path as _sys_path

        _sys_path.append(str(_Path(__file__).resolve().parents[1] / "data_generation"))
        from generate_orders import generate_orders

        logging.info("No default order dataset found; generating a small Docker demo dataset at %s", input_path)
        input_path.parent.mkdir(parents=True, exist_ok=True)
        generate_orders(10_000).to_csv(input_path, index=False)

    run_orders_pipeline(input_path)
