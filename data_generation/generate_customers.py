from pathlib import Path

import numpy as np
import pandas as pd


def generate_orders(row_count: int = 120_000) -> pd.DataFrame:
    seasonality = np.random.choice([0.8, 1.0, 1.2, 1.6], size=row_count, p=[0.2, 0.5, 0.2, 0.1])
    base_order_value = np.random.uniform(20, 450, size=row_count)
    total_amount = np.round(base_order_value * seasonality, 2)
    return pd.DataFrame({
        "order_id": range(1, row_count + 1),
        "customer_id": np.random.randint(1, 50_001, size=row_count),
        "order_status": np.random.choice(
            ["PLACED", "PAID", "SHIPPED", "DELIVERED", "CANCELLED", "REFUNDED"],
            size=row_count,
            p=[0.08, 0.12, 0.2, 0.55, 0.04, 0.01],
        ),
        "total_amount": total_amount,
    })

if __name__ == "__main__":
    output = Path("generated_data/orders.csv")
    output.parent.mkdir(parents=True, exist_ok=True)
    generate_orders().to_csv(output, index=False)
