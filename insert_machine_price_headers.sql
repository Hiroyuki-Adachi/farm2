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

CREATE TABLE machine_price_headers (
    id integer NOT NULL,
    validated_at date NOT NULL,
    machine_id integer DEFAULT 0 NOT NULL,
    machine_type_id integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.machine_price_headers OWNER TO postgres;

--
-- Name: machine_price_headers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE machine_price_headers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.machine_price_headers_id_seq OWNER TO postgres;

--
-- Name: machine_price_headers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE machine_price_headers_id_seq OWNED BY machine_price_headers.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY machine_price_headers ALTER COLUMN id SET DEFAULT nextval('machine_price_headers_id_seq'::regclass);


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
-- Name: machine_price_headers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY machine_price_headers
    ADD CONSTRAINT machine_price_headers_pkey PRIMARY KEY (id);


--
-- Name: machine_price_headers_2nd_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX machine_price_headers_2nd_key ON machine_price_headers USING btree (validated_at, machine_id, machine_type_id);


--
-- PostgreSQL database dump complete
--

