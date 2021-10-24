# from databases import Database
from databases import Database

# host_server = "db"
host_server = "54.255.225.178"
db_server_port = "5432"
database_name = "vehicle_management"
db_username = "lifestyle"
db_password = "lifestyle_tech"
ssl_mode = "prefer"

DATABASE_URL = 'postgresql://{}:{}@{}:{}/{}?sslmode={}'.format(
    db_username, db_password, host_server, db_server_port, database_name, ssl_mode)

database = Database(DATABASE_URL)
