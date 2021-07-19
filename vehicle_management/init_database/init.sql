drop table notes;
drop table visitor;
drop table blacklist;
drop table whitelist;
drop table whitelist_log;



docker exec -ti supabase_db_1 psql -U postgres

@@ Creating a role in Postgres
postgres=# CREATE ROLE peet WITH LOGIN PASSWORD '10042541';
postgres=# ALTER ROLE peet CREATEDB;

\du

@@ Creating a database in Postgres
CREATE DATABASE sammakorn_api;

\q | Exit psql connection
\c | Connect to a new database
\dt | List all tables
\du | List all roles
\list | List databases

\conninfo

# list database
\list

# use database
\c sammakorn_api

@@ Creating a table in Postgres

# TABLE visitor
CREATE TABLE visitor (
  visitor_id SERIAL PRIMARY KEY,
  firstname VARCHAR(30),
  lastname VARCHAR(30),
  home_number VARCHAR(30),
  license_plate VARCHAR(30),
  date date,
  start_time time,
  end_time time,
  timestamp timestamp
);

INSERT INTO visitor (firstname, lastname, home_number, license_plate, date, start_time, end_time, timestamp)
  VALUES ('Mr. natthapol', 'nonthasri', '10/1', '123กข', '1996-12-02', '12.00', '13.00', now());

SELECT * FROM visitor;

# TABLE whitelist
CREATE TABLE whitelist (
  whitelist_id SERIAL PRIMARY KEY,
  firstname VARCHAR(30),
  lastname VARCHAR(30),
  home_number VARCHAR(30),
  license_plate VARCHAR(30)
);

INSERT INTO whitelist (firstname, lastname, home_number, license_plate)
  VALUES ('Mr. natthapol', 'nonthasri', '10/1', '123กข');

SELECT * FROM whitelist;

# TABLE blacklist
CREATE TABLE blacklist (
  blacklist_id SERIAL PRIMARY KEY,
  firstname VARCHAR(30),
  lastname VARCHAR(30),
  home_number VARCHAR(30),
  license_plate VARCHAR(30)
);

INSERT INTO blacklist (firstname, lastname, home_number, license_plate)
  VALUES ('Mr. natthapol', 'nonthasri', '10/1', '123กข');

SELECT * FROM blacklist;