from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker
import dotenv
import os

dotenv.load_dotenv()

user = os.getenv("DB_USER")
password = os.getenv("DB_PASSWORD")
host = os.getenv("DB_HOST")
port = os.getenv("DB_PORT")
database_name = os.getenv("DB_NAME")

url = f"postgresql://{user}:{password}@{host}:{port}/{database_name}"

Base = declarative_base()
engine = create_engine(url)
Session = sessionmaker(bind=engine)

