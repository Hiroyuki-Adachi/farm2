CREATE EXTENSION dblink;
------------------------------------- work_kinds
TRUNCATE TABLE work_kinds;

INSERT INTO work_kinds (id, name, display_order, other_flag, created_at, updated_at, deleted_at)
SELECT id, name, display_order, other_flag, created_at, updated_at, deleted_at
FROM dblink('dbname=farm_production',
'SELECT id, name, display_order, other_flag, created_at, updated_at, deleted_at FROM work_kinds') AS
t1(id integer, name varchar, display_order integer, other_flag boolean, created_at timestamp, updated_at timestamp, deleted_at timestamp);

UPDATE work_kinds SET id = (SELECT MAX(id) FROM work_kinds) + 1 WHERE id = 0;

SELECT SETVAL('work_kinds_id_seq', (SELECT MAX(id) FROM work_kinds));
------------------------------------- works
TRUNCATE TABLE works;

INSERT INTO works (id, term, worked_at, weather_id, work_type_id, name, remarks, start_at, end_at, payed_at, work_kind_id, created_at, updated_at)
SELECT id, year, worked_at, weather, work_type_id, name, remarks, start_at, end_at, payed_at, work_kind_id, created_at, updated_at
FROM dblink('dbname=farm_production',
'SELECT id, year, worked_at, weather, work_type_id, name, remarks, start_at, end_at, payed_at, work_kind_id, created_at, updated_at FROM works') AS
t1(id integer, year integer, worked_at date, weather smallint, work_type_id integer, name varchar, remarks text, start_at timestamp, end_at timestamp, payed_at date , work_kind_id integer, created_at timestamp, updated_at timestamp);

UPDATE works SET work_kind_id = (SELECT MAX(id) FROM work_kinds) WHERE work_kind_id = 0;

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
------------------------------------- sections
TRUNCATE TABLE sections;

INSERT INTO sections (id, name, display_order, work_flag, created_at, updated_at)
SELECT id, name, display_order, work_flag, created_at, updated_at
FROM dblink('dbname=farm_production',
'SELECT id, name, display_order, work_flag, created_at, updated_at FROM sections') AS
t1(id integer, name varchar, display_order integer, work_flag boolean, created_at timestamp, updated_at timestamp);

SELECT SETVAL('sections_id_seq', (SELECT MAX(id) FROM sections));

INSERT INTO sections (name, display_order, work_flag, created_at, updated_at) VALUES ('特別', 99, 'f', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
------------------------------------- homes
TRUNCATE TABLE homes;

INSERT INTO homes (id, phonetic, name, worker_id, zip_code, address1, address2, telephone, fax, section_id, display_order, member_flag, created_at, updated_at, deleted_at)
SELECT id, phonetic, name, worker_id, zip_code, address1, address2, telephone, fax, group_number, display_order, CASE member_flag WHEN 1 THEN true ELSE false END AS member_flag, created_at, updated_at, deleted_at
FROM dblink('dbname=farm_production',
'SELECT id, phonetic, name, worker_id, zip_code, address1, address2, telephone, fax, group_number, display_order, member_flag, created_at, updated_at, deleted_at FROM homes') AS
t1(id integer, phonetic varchar, name varchar, worker_id integer, zip_code varchar, address1 varchar, address2 varchar, telephone varchar, fax varchar, group_number integer, display_order integer, member_flag smallint, created_at timestamp, updated_at timestamp, deleted_at timestamp);

SELECT SETVAL('homes_id_seq', (SELECT MAX(id) FROM homes));

INSERT INTO homes (phonetic, name, section_id, display_order, member_flag, company_flag, created_at, updated_at) VALUES ('えいのうくみあい', '営農組合', (SELECT MAX(id) FROM sections), 99, 'f', 't', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
------------------------------------- lands
TRUNCATE TABLE lands;

INSERT INTO lands (id, place, owner_id, manager_id, area, display_order, target_flag, created_at, updated_at, deleted_at)
SELECT id, place, home_id, home_id, area, display_order, CASE target_flag WHEN 1 THEN true ELSE false END AS target_flag, created_at, updated_at, deleted_at
FROM dblink('dbname=farm_production',
'SELECT id, place, home_id, area, display_order, target_flag, created_at, updated_at, deleted_at FROM lands') AS
t1(id integer, place varchar, home_id integer, area numeric, display_order integer, target_flag integer, created_at timestamp, updated_at timestamp, deleted_at timestamp);

SELECT SETVAL('lands_id_seq', (SELECT MAX(id) FROM lands));
------------------------------------- workers
TRUNCATE TABLE workers;

INSERT INTO workers (id, family_phonetic, family_name, first_phonetic, first_name, birthday, home_id, mobile, mobile_mail, pc_mail, display_order, work_flag, created_at, updated_at, deleted_at)
SELECT id, family_phonetic, family_name, first_phonetic, first_name, birthday, home_id, mobile, mobile_mail, pc_mail, display_order, work_flag, created_at, updated_at, deleted_at
FROM dblink('dbname=farm_production',
'SELECT id, family_phonetic, family_name, first_phonetic, first_name, birthday, home_id, mobile, mobile_mail, pc_mail, display_order, work_flag, created_at, updated_at, deleted_at FROM workers') AS
t1(id integer, family_phonetic varchar, family_name varchar, first_phonetic varchar, first_name varchar, birthday date, home_id integer, mobile varchar, mobile_mail varchar, pc_mail varchar, display_order integer, work_flag boolean, created_at timestamp, updated_at timestamp, deleted_at timestamp);

SELECT SETVAL('workers_id_seq', (SELECT MAX(id) FROM workers));
------------------------------------- work_types
TRUNCATE TABLE work_types;

INSERT INTO work_types (id, genre, name, category_flag, display_order, deleted_at)
SELECT id, genre, name, category_flag, display_order, deleted_at
FROM dblink('dbname=farm_production',
'SELECT id, genre, name, category_flag, display_order, deleted_at FROM work_types') AS
t1(id integer, genre integer, name varchar, category_flag boolean, display_order integer, deleted_at timestamp);

SELECT SETVAL('work_types_id_seq', (SELECT MAX(id) FROM work_types));
------------------------------------- work_kind_types
TRUNCATE TABLE work_kind_types;
SELECT SETVAL('work_kind_types_id_seq', 1);

INSERT INTO work_kind_types (work_type_id, work_kind_id)
SELECT t1.id, t2.id
FROM dblink('dbname=farm_production', 'SELECT id FROM work_types WHERE category_flag = true AND deleted_at IS NULL') AS t1(id integer),
dblink('dbname=farm_production', 'SELECT id FROM work_kinds WHERE deleted_at IS NULL') AS t2(id integer);

UPDATE work_kind_types SET work_kind_id = (SELECT MAX(id) FROM work_kinds) WHERE work_kind_id = 0;
------------------------------------- work_kind_prices
TRUNCATE TABLE work_kind_prices;
SELECT SETVAL('work_kind_prices_id_seq', 1);

INSERT INTO work_kind_prices (term, work_kind_id, price, created_at, updated_at)
SELECT term, work_kind_id, price, created_at, updated_at
FROM dblink('dbname=farm_production', 'SELECT W.term, W.work_kind_id, WK.price, WK.created_at, WK.updated_at FROM (SELECT DISTINCT year AS term, work_kind_id FROM works) W INNER JOIN work_kinds WK ON WK.id = W.work_kind_id') 
AS t1(term integer, work_kind_id integer, price numeric, created_at timestamp, updated_at timestamp);

UPDATE work_kind_prices SET work_kind_id = (SELECT MAX(id) FROM work_kinds) WHERE work_kind_id = 0;
------------------------------------- machines
TRUNCATE TABLE machines;

INSERT INTO machines (id, name, display_order, validity_start_at, validity_end_at, created_at, updated_at)
SELECT id, name, display_order, validity_start_at, validity_end_at, created_at, updated_at
FROM dblink('dbname=farm_production',
'SELECT id, name, display_order, validity_start_at, validity_end_at, created_at, updated_at FROM machines') AS
t1(id integer, name varchar, display_order integer, validity_start_at date, validity_end_at date, created_at timestamp, updated_at timestamp);

SELECT SETVAL('machines_id_seq', (SELECT MAX(id) FROM machines));
------------------------------------- machine_results
TRUNCATE TABLE machine_results;

INSERT INTO machine_results (id, machine_id, work_result_id, display_order, hours, created_at, updated_at)
SELECT id, machine_id, work_result_id, display_order, hours, created_at, updated_at
FROM dblink('dbname=farm_production',
'SELECT id, machine_id, work_result_id, display_order, hours, created_at, updated_at FROM machine_results') AS
t1(id integer, machine_id integer, work_result_id integer, display_order integer, hours numeric, created_at timestamp, updated_at timestamp);

SELECT SETVAL('machine_results_id_seq', (SELECT MAX(id) FROM machine_results));
------------------------------------- systems
TRUNCATE TABLE systems;

INSERT INTO systems (id, target_from, target_to, term, created_at, updated_at)
SELECT id, target_from, target_to, term, created_at, updated_at
FROM dblink('dbname=farm_production',
'SELECT id, target_from, target_to, term, created_at, updated_at FROM systems') AS
t1(id integer,target_from date, target_to date, term integer, created_at timestamp, updated_at timestamp);

SELECT SETVAL('systems_id_seq', (SELECT MAX(id) FROM systems));
------------------------------------- chemicals
TRUNCATE TABLE chemicals;

INSERT INTO chemicals (id, name, display_order, chemical_type_id, created_at, updated_at, deleted_at)
SELECT id, name, display_order, chemical_type_id, created_at, updated_at, deleted_at
FROM dblink('dbname=farm_production',
'SELECT id, name, display_order, chemical_type_id, created_at, updated_at, deleted_at FROM chemicals') AS
t1(id integer, name varchar, display_order integer, chemical_type_id integer, created_at timestamp, updated_at timestamp, deleted_at timestamp);

SELECT SETVAL('chemicals_id_seq', (SELECT MAX(id) FROM chemicals));
------------------------------------- chemical_types
TRUNCATE TABLE chemical_types;

INSERT INTO chemical_types (id, name, display_order, created_at, updated_at)
SELECT id, name, display_order, created_at, updated_at
FROM dblink('dbname=farm_production',
'SELECT id, name, display_order, created_at, updated_at FROM chemical_types') AS
t1(id integer, name varchar, display_order integer, created_at timestamp, updated_at timestamp);

SELECT SETVAL('chemical_types_id_seq', (SELECT MAX(id) FROM chemical_types));
------------------------------------- work_chemicals
TRUNCATE TABLE work_chemicals;

INSERT INTO work_chemicals (id, work_id, chemical_id, quantity, created_at, updated_at)
SELECT id, work_id, chemical_id, quantity, created_at, updated_at
FROM dblink('dbname=farm_production',
'SELECT id, work_id, chemical_id, quantity, created_at, updated_at FROM work_chemicals') AS
t1(id integer, work_id integer, chemical_id integer, quantity integer, created_at timestamp, updated_at timestamp);

SELECT SETVAL('work_chemicals_id_seq', (SELECT MAX(id) FROM work_chemicals));
------------------------------------- organizations
TRUNCATE TABLE organizations;

INSERT INTO organizations (id, show_work1, show_work2, created_at, updated_at)
SELECT id, show_work1, show_work2, created_at, updated_at
FROM dblink('dbname=farm_production',
'SELECT id, show_work1, show_work2, created_at, updated_at FROM organizations') AS
t1(id integer, show_work1 varchar, show_work2 varchar, created_at timestamp, updated_at timestamp);

SELECT SETVAL('organizations_id_seq', (SELECT MAX(id) FROM organizations));
