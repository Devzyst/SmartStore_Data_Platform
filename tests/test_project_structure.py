from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parents[1]


def test_simplified_top_level_files_exist():
    expected_files = [
        "database/schema.sql",
        "database/warehouse.sql",
        "database/procedures.sql",
        "database/triggers.sql",
        "database/views.sql",
        "etl/extract.py",
        "etl/transform.py",
        "etl/load.py",
        "etl/pipeline.py",
        "analytics/sales_queries.sql",
        "analytics/customer_queries.sql",
        "analytics/inventory_queries.sql",
        "analytics/revenue_queries.sql",
        "docs/architecture.md",
        "docs/database_design.md",
        "docs/setup_guide.md",
        "CONTRIBUTING.md",
    ]
    missing = [file_path for file_path in expected_files if not (PROJECT_ROOT / file_path).exists()]
    assert missing == []


def test_legacy_nested_database_directories_removed():
    legacy_directories = [
        "database/schema",
        "database/procedures",
        "database/triggers",
        "database/views",
        "database/seed",
        "etl/pipelines",
    ]
    assert all(not (PROJECT_ROOT / directory).exists() for directory in legacy_directories)
