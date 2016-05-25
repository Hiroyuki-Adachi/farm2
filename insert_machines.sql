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
-- Name: machines; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE machines (
    id integer NOT NULL,
    name character varying(40) NOT NULL,
    display_order integer NOT NULL,
    validity_start_at date,
    validity_end_at date,
    machine_type_id integer DEFAULT 0 NOT NULL,
    home_id integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.machines OWNER TO postgres;

--
-- Name: machines_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE machines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.machines_id_seq OWNER TO postgres;

--
-- Name: machines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE machines_id_seq OWNED BY machines.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY machines ALTER COLUMN id SET DEFAULT nextval('machines_id_seq'::regclass);


--
-- Data for Name: machines; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY machines (id, name, display_order, validity_start_at, validity_end_at, machine_type_id, home_id, created_at, updated_at) FROM stdin;
20	田植機(除草機)	10	2010-01-01	2020-12-31	0	0	2012-07-21 00:06:12.890608	2012-07-21 00:06:51.038704
6	コンバインAR698(No.1)	11	2010-01-01	2015-12-31	0	0	2010-07-15 14:34:42	2013-07-13 02:33:33.249685
7	コンバインERN698(No.2)	12	2010-01-01	2015-12-31	0	0	2010-07-15 14:34:42	2013-07-13 02:34:03.659941
22	ロールべーラ	16	2010-01-01	2015-12-31	0	0	2013-07-13 02:35:43.198642	2013-07-13 02:35:43.198642
8	WCS	17	2010-01-01	2015-12-31	0	0	2010-07-15 14:34:42	2013-07-13 02:36:37.326315
17	タイヤローダー	19	2010-01-01	2015-12-31	0	0	2010-09-19 23:39:04.787005	2013-07-13 02:37:57.180992
16	ラップマシン	18	2010-01-01	2015-12-31	0	0	2010-09-19 23:38:54.697253	2013-07-13 02:38:10.004682
15	集草機	20	2010-01-01	2015-12-31	0	0	2010-09-19 23:38:28.371425	2013-07-13 02:39:24.140077
23	グレイタスローダ	20	2010-01-01	2015-12-31	0	0	2013-07-13 02:40:27.824761	2013-07-13 02:40:27.824761
11	散布機	31	2010-01-01	2015-12-31	0	0	2010-07-19 10:50:19.40446	2013-07-13 02:41:26.993127
10	フォークリフト	32	2010-01-01	2015-12-31	0	0	2010-07-19 10:50:02.251704	2013-07-13 02:41:42.841148
12	バックホー(秋国)	33	2010-01-01	2015-12-31	0	0	2010-07-19 11:04:01.884798	2013-07-13 02:42:10.165049
24	バックホー（稲田）	34	2010-01-01	2015-12-31	0	0	2013-07-13 02:43:49.413117	2013-07-13 02:43:49.413117
9	OKリース(4t)	35	2010-01-01	2015-12-31	0	0	2010-07-19 10:19:32.947907	2013-07-13 02:44:30.225226
14	鶏ふん振り機	36	2010-01-01	2015-12-31	0	0	2010-07-19 11:04:42.738313	2013-07-13 02:44:50.021214
19	田植機(8条)(新EP87)	5	2012-01-01	2015-12-31	0	0	2012-07-14 07:38:38.598912	2014-04-27 01:28:03.037085
2	田植機( 8条)(旧NSU87)	7	2010-01-01	2015-12-31	0	0	2010-07-15 14:34:42	2014-04-27 01:28:18.786737
25	バックホー（石原）	40	2010-01-01	2015-12-31	0	0	2014-07-20 07:36:57.419755	2014-07-20 07:36:57.419755
18	トラクタ（MZ655）　NO、1	1	2010-01-01	2015-12-31	0	0	2011-12-09 10:03:45.696324	2015-06-14 06:59:56.873457
5	トラクタ(ハンクロ：MZ65）NO,2	2	2010-01-01	2015-12-31	0	0	2010-07-15 14:34:42	2015-06-14 07:00:12.506443
4	トラクタ(MZ65幅広T)NO,3	3	2010-01-01	2015-12-31	0	0	2010-07-15 14:34:42	2015-06-14 07:00:45.207516
26	中家トラクター	0	2010-01-01	2015-12-31	0	0	2015-12-17 08:56:43.037151	2015-12-17 08:56:43.037151
27	中家ドウフン	0	2010-01-01	2020-12-31	0	0	2015-12-17 08:59:16.301413	2016-02-25 08:24:45.220315
\.


--
-- Name: machines_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('machines_id_seq', 27, true);


--
-- Name: machines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY machines
    ADD CONSTRAINT machines_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

