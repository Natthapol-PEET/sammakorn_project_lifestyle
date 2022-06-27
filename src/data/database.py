# from databases import Database
from databases import Database
from configs import config

host_server = config.db_server
db_server_port = "5432"
db_username = "lifestyle"
db_password = "lifestyle_tech"
database_name = "vehicle_management"
ssl_mode = "prefer"

DATABASE_URL = 'postgresql://{}:{}@{}:{}/{}?sslmode={}'.format(
    db_username, db_password, host_server, db_server_port, database_name, ssl_mode)

database = Database(DATABASE_URL)
