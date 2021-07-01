from sqlalchemy import Column, Table, Integer, String, Boolean, \
    Date, Time, DateTime, TIMESTAMP, ForeignKey
from sqlalchemy import MetaData, create_engine
from .database import DATABASE_URL


metadata = MetaData()

resident_account = Table(
    "resident_account",
    metadata,
    Column("res_id", Integer, primary_key=True, autoincrement=True),
    Column("firstname", String),
    Column("lastname", String),
    Column("username", String),
    Column("password", String),
    Column("email", String),
    Column("login_datetime", DateTime),
    Column("create_datetime", DateTime),
)

admin_account = Table(
    "admin_account",
    metadata,
    Column("admin_id", Integer, primary_key=True, autoincrement=True),
    Column("firstname", String),
    Column("lastname", String),
    Column("username", String),
    Column("password", String),
    Column("email", String),
    Column("login_datetime", DateTime),
    Column("create_datetime", DateTime),
)

guard_account = Table(
    "guard_account",
    metadata,
    Column("guard_id", Integer, primary_key=True, autoincrement=True),
    Column("firstname", String),
    Column("lastname", String),
    Column("username", String),
    Column("password", String),
    Column("email", String),
    Column("login_datetime", DateTime),
    Column("create_datetime", DateTime),
)

blacklist_token = Table(
    "blacklist_token",
    metadata,
    Column("TOKEN", String)
)

# notes = Table(
#     "notes",
#     metadata,
#     Column("id", Integer, primary_key=True, autoincrement=True),
#     Column("text", String, nullable=False),
#     Column("completed", Boolean, nullable=False),
# )

# visitor = Table(
#     "visitor",
#     metadata,
#     Column("visitor_id", Integer, primary_key=True, autoincrement=True),
#     Column("firstname", String, nullable=False),
#     Column("lastname", String, nullable=False),
#     Column("home_number", String, nullable=False),
#     Column("license_plate", String, nullable=False),
#     Column("date", Date, nullable=False),
#     Column("start_time", Time, nullable=False),
#     Column("end_time", Time, nullable=False),
#     Column("timestamp", DateTime),
# )

# blacklist = Table(
#     "blacklist",
#     metadata,
#     Column("blacklist_id", Integer, primary_key=True, autoincrement=True),
#     Column("firstname", String, nullable=False),
#     Column("lastname", String, nullable=False),
#     Column("home_number", String, nullable=False),
#     Column("license_plate", String, nullable=False),
# )

# whitelist = Table(
#     "whitelist",
#     metadata,
#     Column("whitelist_id", Integer, primary_key=True, autoincrement=True),
#     Column("firstname", String, nullable=False),
#     Column("lastname", String, nullable=False),
#     Column("home_number", String, nullable=False),
#     Column("license_plate", String, nullable=False),
# )

# whitelist_log = Table(
#     "whitelist_log",
#     metadata,
#     Column("whitelist_log_id", Integer, primary_key=True, index=True),
#     Column("firstname", String, nullable=False),
#     Column("lastname", String, nullable=False),
#     Column("home_number", String, nullable=False),
#     Column("license_plate", String, nullable=False),
#     Column("timestamp", DateTime, nullable=False),
# )


engine = create_engine(
    DATABASE_URL, pool_size=3, max_overflow=0
)

metadata.create_all(engine)
