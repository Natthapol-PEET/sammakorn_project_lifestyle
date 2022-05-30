# from databases import Database
from databases import Database

host_server = "localhost"
# host_server = "dev-postgres"
db_server_port = "5432"
database_name = "vehicle_management"
db_username = "postgres"
db_password = "postgres"
# db_username = "kong"
# db_password = "kong"
ssl_mode = "prefer"

DATABASE_URL = 'postgresql://{}:{}@{}:{}/{}?sslmode={}'.format(
    db_username, db_password, host_server, db_server_port, database_name, ssl_mode)

database = Database(DATABASE_URL)
