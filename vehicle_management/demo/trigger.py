import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT
import select
import time


host_server = "13.229.234.126"
db_server_port = "5432"
database_name = "vehicle_management"
db_username = "lifestyle"
db_password = "lifestyle_tech"
ssl_mode = "prefer"

DATABASE_URL = 'postgresql://{}:{}@{}:{}/{}?sslmode={}'.format(
    db_username, db_password, host_server, db_server_port, database_name, ssl_mode)


def dblisten():
    connection = psycopg2.connect(DATABASE_URL)
    connection.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
    cur = connection.cursor()
    cur.execute("LISTEN new_id;")

    start_time = time.time()

    while True:
        try:
            select.select([connection], [], [])
            connection.poll()

            while connection.notifies:
                notify = connection.notifies.pop().payload
                print(notify)
            
        except:
            print(time.time() - start_time)
            break


if __name__ == '__main__':
    dblisten()
