import os

from dotenv import load_dotenv
from sqlalchemy import create_engine

load_dotenv()


def build_mysql_engine():
    """Create a SQLAlchemy engine from environment variables."""
    user = os.getenv("MYSQL_USER", "smartstore_user")
    password = os.getenv("MYSQL_PASSWORD", "smartstore_password")
    host = os.getenv("MYSQL_HOST", "localhost")
    port = os.getenv("MYSQL_PORT", "3306")
    database = os.getenv("MYSQL_DATABASE", "smartstore")
    return create_engine(f"mysql+pymysql://{user}:{password}@{host}:{port}/{database}")


def load_dataframe(df, table_name: str, if_exists: str = "append") -> None:
    """Load a DataFrame into MySQL."""
    engine = build_mysql_engine()
    df.to_sql(table_name, engine, if_exists=if_exists, index=False)
