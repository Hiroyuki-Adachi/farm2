CREATE EXTENSION dblink;
------------------------------------- works
TRUNCATE TABLE works;

INSERT INTO works (id, year, worked_at, weather, work_type_id, name, remarks, start_at, end_at, payed_at, work_kind_id, created_at, updated_at)
SELECT id, year, worked_at, weather, work_type_id, name, remarks, start_at, end_at, payed_at, work_kind_id, created_at, updated_at
FROM dblink('dbname=farm_production',
'SELECT id, year, worked_at, weather, work_type_id, name, remarks, start_at, end_at, payed_at, work_kind_id, created_at, updated_at FROM works') AS
t1(id integer, year integer, worked_at date, weather smallint, work_type_id integer, name varchar, remarks text, start_at timestamp, end_at timestamp, payed_at date , work_kind_id integer, created_at timestamp, updated_at timestamp);

SELECT SETVAL('works_id_seq', (SELECT MAX(id) FROM works));
------------------------------------- work_results
TRUNCATE TABLE work_results;

INSERT INTO work_results (id, work_id, worker_id, hours, display_order, created_at, updated_at)
SELECT id, work_id, worker_id, hours, display_order, created_at, updated_at
FROM dblink('dbname=farm_production',
'SELECT id, work_id, worker_id, hours, display_order, created_at, updated_at FROM work_results') AS
t1(id integer, work_id integer, worker_id integer, hours numeric(3,1), display_order integer, created_at timestamp, updated_at timestamp);

SELECT SETVAL('work_results_id_seq', (SELECT MAX(id) FROM work_results));
------------------------------------- work_lands
TRUNCATE TABLE work_lands;

INSERT INTO work_lands (id, work_id, land_id, display_order, created_at, updated_at)
SELECT id, work_id, land_id, display_order, created_at, updated_at
FROM dblink('dbname=farm_production',
'SELECT id, work_id, land_id, display_order, created_at, updated_at FROM work_lands') AS
t1(id integer, work_id integer, land_id integer, display_order integer, created_at timestamp, updated_at timestamp);

SELECT SETVAL('work_lands_id_seq', (SELECT MAX(id) FROM work_lands));
------------------------------------- work_types
TRUNCATE TABLE work_types;

INSERT INTO work_types (id, genre, name, category_flag, display_order, deleted_at)
SELECT id, genre, name, category_flag, display_order, deleted_at
FROM dblink('dbname=farm_production',
'SELECT id, genre, name, category_flag, display_order, deleted_at FROM work_types') AS
t1(id integer, genre integer, name varchar, category_flag boolean, display_order integer, deleted_at timestamp);

SELECT SETVAL('work_types_id_seq', (SELECT MAX(id) FROM work_types));
