from pathlib import Path

import numpy as np
import pandas as pd


def generate_products(row_count: int = 5_000) -> pd.DataFrame:
    return pd.DataFrame({
        "sku": [f"SKU-{product_id:06d}" for product_id in range(1, row_count + 1)],
        "product_name": [f"SmartStore Product {product_id}" for product_id in range(1, row_count + 1)],
        "category_id": np.random.randint(1, 5, size=row_count),
        "supplier_id": np.random.randint(1, 3, size=row_count),
        "unit_price": np.round(np.random.uniform(5, 500, size=row_count), 2),
        "cost_price": np.round(np.random.uniform(3, 300, size=row_count), 2),
    })

