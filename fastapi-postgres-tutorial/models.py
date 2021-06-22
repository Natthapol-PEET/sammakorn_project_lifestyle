from sqlalchemy import Column, Table, Integer, String, Boolean, \
    Date, Time, DateTime, TIMESTAMP, ForeignKey
from sqlalchemy import MetaData, create_engine
from database import DATABASE_URL


metadata = MetaData()

notes = Table(
    "notes",
    metadata,
    Column("id", Integer, primary_key=True, autoincrement=True),
    Column("text", String, nullable=False),
    Column("completed", Boolean, nullable=False),
)

visitor = Table(
    "visitor",
    metadata,
    Column("visitor_id", Integer, primary_key=True, autoincrement=True),
    Column("firstname", String, nullable=False),
    Column("lastname", String, nullable=False),
    Column("home_number", String, nullable=False),
    Column("license_plate", String, nullable=False),
    Column("date", Date, nullable=False),
    Column("start_time", Time, nullable=False),
    Column("end_time", Time, nullable=False),
    Column("timestamp", DateTime),
)

blacklist = Table(
    "blacklist",
    metadata,
    Column("blacklist_id", Integer, primary_key=True, autoincrement=True),
    Column("firstname", String, nullable=False),
    Column("lastname", String, nullable=False),
    Column("home_number", String, nullable=False),
    Column("license_plate", String, nullable=False),
)

whitelist = Table(
    "whitelist",
    metadata,
    Column("whitelist_id", Integer, primary_key=True, autoincrement=True),
    Column("firstname", String, nullable=False),
    Column("lastname", String, nullable=False),
    Column("home_number", String, nullable=False),
    Column("license_plate", String, nullable=False),
)

whitelist_log = Table(
    "whitelist_log",
    metadata,
    Column("whitelist_log_id", Integer, primary_key=True, index=True),
    Column("firstname", String, nullable=False),
    Column("lastname", String, nullable=False),
    Column("home_number", String, nullable=False),
    Column("license_plate", String, nullable=False),
    Column("timestamp", DateTime, nullable=False),
)


engine = create_engine(
    DATABASE_URL, pool_size=3, max_overflow=0
)

metadata.create_all(engine)
