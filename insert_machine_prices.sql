--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: machine_price_headers; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

--
-- Data for Name: machine_price_headers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY machine_price_headers (id, validated_at, machine_id, machine_type_id, created_at, updated_at) FROM stdin;
4	2016-01-01	0	1	2016-05-25 13:33:37.200683	2016-05-25 14:09:40.612282
7	2016-01-01	0	2	2016-05-25 21:54:04.372182	2016-05-25 21:54:04.372182
8	2016-02-01	0	3	2016-05-25 21:57:02.827158	2016-05-25 21:57:02.827158
\.


--
-- Name: machine_price_headers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('machine_price_headers_id_seq', 8, true);


--
--

--
-- Data for Name: machine_price_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY machine_price_details (id, machine_price_header_id, lease_id, work_kind_id, adjust_id, price, created_at, updated_at) FROM stdin;
1	4	1	0	2	4500	2016-05-25 13:33:37.243451	2016-05-25 13:33:37.243451
2	4	1	3	2	4500	2016-05-25 13:33:37.267882	2016-05-25 13:33:37.267882
3	4	1	2	2	5000	2016-05-25 13:33:37.271736	2016-05-25 13:33:37.271736
4	4	2	0	3	10000	2016-05-25 13:33:37.274469	2016-05-25 13:33:37.274469
5	4	2	3	3	10000	2016-05-25 13:33:37.278106	2016-05-25 13:33:37.278106
6	4	2	2	3	10000	2016-05-25 13:33:37.280762	2016-05-25 13:33:37.280762
9	7	1	0	2	4000	2016-05-25 21:54:04.378524	2016-05-25 21:54:04.378524
10	7	2	0	3	20000	2016-05-25 21:54:04.389073	2016-05-25 21:54:04.389073
11	8	1	0	2	15000	2016-05-25 21:57:02.835209	2016-05-25 21:57:02.835209
12	8	2	0	3	30000	2016-05-25 21:57:02.847855	2016-05-25 21:57:02.847855
\.


--
-- Name: machine_price_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('machine_price_details_id_seq', 12, true);


