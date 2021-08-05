

SELECT * FROM home;

INSERT INTO home (home_name, home_number, stamp_count, create_datetime) VALUES
	('บ้านสิรินธร', '1/1', 0, NOW()),
	('บ้านสิรินธร', '1/2', 0, NOW()),
	('บ้านสิรินธร', '1/3', 0, NOW()),
	('บ้านไลฟ์สไตล์', '2/1', 0, NOW()),
	('บ้านไลฟ์สไตล์', '2/2', 0, NOW()),
	('บ้านไลฟ์สไตล์', '2/3', 0, NOW())

DROP TABLE if exists home cascade;