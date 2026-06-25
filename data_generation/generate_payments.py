from pathlib import Path

import numpy as np
import pandas as pd


def generate_payments(row_count: int = 120_000) -> pd.DataFrame:
    return pd.DataFrame({
        "order_id": range(1, row_count + 1),
        "payment_method": np.random.choice(["CARD", "PAYPAL", "APPLE_PAY", "BANK_TRANSFER"], size=row_count, p=[0.68, 0.18, 0.1, 0.04]),
        "payment_status": np.random.choice(["SUCCESS", "FAILED", "REFUNDED"], size=row_count, p=[0.95, 0.04, 0.01]),
    })
