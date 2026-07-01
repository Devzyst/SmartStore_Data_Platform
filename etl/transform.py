import pandas as pd

VALID_ORDER_STATUSES = {"PLACED", "PAID", "SHIPPED", "DELIVERED", "CANCELLED", "REFUNDED"}


def clean_orders(df: pd.DataFrame) -> pd.DataFrame:
    """Normalize order data, remove duplicates, and reject invalid records."""
    clean = df.copy()
    clean = clean.drop_duplicates(subset=["order_id"])
    clean["order_status"] = clean["order_status"].astype(str).str.upper().str.strip()
    clean = clean[clean["order_status"].isin(VALID_ORDER_STATUSES)]
    clean = clean[clean["total_amount"] > 0]
    return clean
