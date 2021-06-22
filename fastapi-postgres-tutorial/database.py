from databases import Database

host_server = "localhost"
db_server_port = "5432"
database_name = "api"
db_username = "peet"
db_password = "10042541"
ssl_mode = "prefer"

DATABASE_URL = 'postgresql://{}:{}@{}:{}/{}?sslmode={}'.format(
    db_username, db_password, host_server, db_server_port, database_name, ssl_mode)

database = Database(DATABASE_URL)
