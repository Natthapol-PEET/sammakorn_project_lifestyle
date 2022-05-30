from datetime import datetime
from sqlalchemy import MetaData, create_engine, Column, Table, Integer, String, Boolean, \
    Date, DateTime, ForeignKey

# database config
from data.database import DATABASE_URL


metadata = MetaData()

resident_account = Table(
    "resident_account",
    metadata,
    Column("resident_id", Integer, primary_key=True, autoincrement=True),
    Column("firstname", String),
    Column("lastname", String),
    Column("username", String),
    Column("password", String),
    Column("email", String),
    Column("device_token", String(255)),
    Column("device_id", String),
    Column("is_login", Boolean),
    Column("home_id", Integer),
    Column("id_card", String),
    Column("card_info", String),
    Column("card_scan_position", String),       # entrance, exit
    Column("active_user", Boolean),
    Column("login_datetime", DateTime),
    Column("create_datetime", DateTime, default=datetime.now()),
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
    Column("id_card", String),
    Column("active_user", Boolean),
    Column("role", String),
    Column("login_datetime", DateTime),
    Column("create_datetime", DateTime, default=datetime.now()),
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
    Column("id_card", String),
    Column("active_user", Boolean),
    Column("role", String),
    Column("profile_path", String),
    Column("phone_number", String),
    Column("login_datetime", DateTime),
    Column("create_datetime", DateTime, default=datetime.now()),
)

blacklist_token = Table(
    "blacklist_token",
    metadata,
    Column("TOKEN", String, primary_key=True)
)

visitor = Table(
    "visitor",
    metadata,
    Column("visitor_id", Integer, primary_key=True, autoincrement=True),
    Column("home_id", Integer, ForeignKey("home.home_id")),
    Column("class", String),
    Column("class_id", Integer),
    Column("firstname", String),
    Column("lastname", String),
    Column("license_plate", String),
    Column("id_card", String),
    Column("invite_date", Date),
    Column("qr_gen_id", String),
    Column("create_datetime", DateTime, default=datetime.now()),
)

blacklist = Table(
    "blacklist",
    metadata,
    Column("blacklist_id", Integer, primary_key=True, autoincrement=True),
    Column("home_id", Integer, ForeignKey("home.home_id")),
    Column("class", String),
    Column("class_id", Integer),
    Column("firstname", String),
    Column("lastname", String),
    Column("resident_add_reason", String),
    Column("admin_datetime", DateTime),
    Column("admin_approve", Boolean),
    Column("admin_reason", String),
    Column("resident_remove_reason", String),
    Column("resident_remove_datetime", DateTime),
    Column("admin_decline_remove_reason", String),
    Column("admin_decline_remove_datetime", DateTime),
    Column("license_plate", String),
    Column("id_card", String),
    Column("create_datetime", DateTime, default=datetime.now()),
)

whitelist = Table(
    "whitelist",
    metadata,
    Column("whitelist_id", Integer, primary_key=True, autoincrement=True),
    Column("home_id", Integer, ForeignKey("home.home_id")),
    Column("class", String),
    Column("class_id", Integer),
    Column("firstname", String),
    Column("lastname", String),
    Column("resident_add_reason", String),
    Column("admin_datetime", DateTime),
    Column("admin_approve", Boolean),
    Column("admin_reason", String),
    Column("resident_remove_reason", String),
    Column("resident_remove_datetime", DateTime),
    Column("admin_decline_remove_reason", String),
    Column("admin_decline_remove_datetime", DateTime),
    Column("license_plate", String),
    Column("qr_gen_id", String),
    Column("id_card", String),
    Column("email", String),
    Column("create_datetime", DateTime, default=datetime.now()),
)


history_log = Table(
    "history_log",
    metadata,
    Column("log_id", Integer, primary_key=True, index=True),
    Column("class", String),
    Column("class_id", Integer),
    Column("datetime_in", DateTime),
    Column("resident_stamp", DateTime),
    Column("resident_send_admin", DateTime),
    Column("resident_reason", String),
    Column("admin_datetime", DateTime),
    Column("admin_approve", Boolean),
    Column("admin_reason", String),
    Column("datetime_out", DateTime),
    Column("create_datetime", DateTime, default=datetime.now()),
)


home = Table(
    "home",
    metadata,
    Column("home_id", Integer, primary_key=True, index=True),
    Column("home_name", String),
    Column("home_number", String),
    Column("stamp_count", Integer),
    Column("create_datetime", DateTime, default=datetime.now()),
    Column("update_datetime", DateTime),
)

resident_home = Table(
    "resident_home",
    metadata,
    Column("resident_id", Integer, ForeignKey("resident_account.resident_id")),
    Column("home_id", Integer, ForeignKey("home.home_id")),
    Column("create_datetime", DateTime, default=datetime.now()),
)

resident_car = Table(
    "resident_car",
    metadata,
    Column("resident_id", Integer, ForeignKey("resident_account.resident_id")),
    Column("license_plate", String),
    Column("create_datetime", DateTime, default=datetime.now()),
)

reset_password = Table(
    "reset_password",
    metadata,
    Column("key", String),
    Column("role", String),
    Column("role_id", Integer),
    Column("is_use", Boolean),
    Column("create_datetime", DateTime, default=datetime.now()),
)

# web walk in
walkin = Table(
    "walkin",
    metadata,
    Column("walkin_id", Integer, primary_key=True, index=True),
    Column("firstname", String),
    Column("lastname", String),
    Column("id_card", String),
    Column("gender", String),
    Column("address", String(255)),
    Column("license_plate", String),
    Column("goto_home_address", String),
    Column("datetime_in", DateTime),
    Column("datetime_out", DateTime),
    Column("path_image", String),
    Column("qr_gen_id", String),
)


# ALPR models
sync_alpr = Table(
    "sync_alpr",
    metadata,
    Column("sync_id", Integer, primary_key=True, index=True),
    Column("vehicle_id", String, primary_key=True),
    Column("id", Integer),
    Column("type", String),
    Column("plate_number", String),
    Column("region_code", String),
    Column("family_id", String),
    Column("permission_begin", DateTime),
    Column("permission_end", DateTime),
    Column("action", String),
    Column("status_success", Boolean),
)


engine = create_engine(
    DATABASE_URL, pool_size=3, max_overflow=0
)

metadata.create_all(engine)
