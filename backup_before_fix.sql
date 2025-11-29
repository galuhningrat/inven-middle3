--
-- PostgreSQL database dump
--

\restrict ycybewZ7IKVllIj5sfmsJaz6wRCathjg4amhXPYsQap7imfbvUzAieAKCjfxMwk

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: asset_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_requests (
    id bigint NOT NULL,
    request_id character varying(255) NOT NULL,
    requester_id bigint NOT NULL,
    asset_name character varying(255) NOT NULL,
    asset_type_id bigint NOT NULL,
    quantity integer NOT NULL,
    estimated_price numeric(12,2),
    priority character varying(255) DEFAULT 'Sedang'::character varying NOT NULL,
    reason text NOT NULL,
    status character varying(255) DEFAULT 'Pending'::character varying NOT NULL,
    approved_by bigint,
    approved_at timestamp(0) without time zone,
    approval_notes text,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone,
    CONSTRAINT asset_requests_priority_check CHECK (((priority)::text = ANY ((ARRAY['Rendah'::character varying, 'Sedang'::character varying, 'Tinggi'::character varying, 'Urgent'::character varying])::text[]))),
    CONSTRAINT asset_requests_status_check CHECK (((status)::text = ANY ((ARRAY['Pending'::character varying, 'Disetujui'::character varying, 'Ditolak'::character varying])::text[])))
);


ALTER TABLE public.asset_requests OWNER TO postgres;

--
-- Name: asset_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.asset_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.asset_requests_id_seq OWNER TO postgres;

--
-- Name: asset_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.asset_requests_id_seq OWNED BY public.asset_requests.id;


--
-- Name: asset_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_types (
    id bigint NOT NULL,
    code character varying(3) NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.asset_types OWNER TO postgres;

--
-- Name: asset_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.asset_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.asset_types_id_seq OWNER TO postgres;

--
-- Name: asset_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.asset_types_id_seq OWNED BY public.asset_types.id;


--
-- Name: assets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assets (
    id bigint NOT NULL,
    asset_id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    asset_type_id bigint NOT NULL,
    brand character varying(255) NOT NULL,
    serial_number character varying(255) NOT NULL,
    price numeric(12,2) NOT NULL,
    purchase_date date NOT NULL,
    location character varying(255) NOT NULL,
    condition character varying(255) DEFAULT 'Baik'::character varying NOT NULL,
    status character varying(255) DEFAULT 'Tersedia'::character varying NOT NULL,
    image character varying(255),
    qr_code character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone,
    CONSTRAINT assets_condition_check CHECK (((condition)::text = ANY ((ARRAY['Baik'::character varying, 'Rusak Ringan'::character varying, 'Rusak Berat'::character varying])::text[]))),
    CONSTRAINT assets_status_check CHECK (((status)::text = ANY ((ARRAY['Tersedia'::character varying, 'Dipinjam'::character varying, 'Maintenance'::character varying])::text[])))
);


ALTER TABLE public.assets OWNER TO postgres;

--
-- Name: assets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.assets_id_seq OWNER TO postgres;

--
-- Name: assets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assets_id_seq OWNED BY public.assets.id;


--
-- Name: borrowings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.borrowings (
    id bigint NOT NULL,
    borrowing_id character varying(255) NOT NULL,
    asset_id bigint NOT NULL,
    borrower_name character varying(255) NOT NULL,
    borrower_role character varying(255) NOT NULL,
    borrow_date date NOT NULL,
    return_date date NOT NULL,
    actual_return_date date,
    purpose text NOT NULL,
    status character varying(255) DEFAULT 'Aktif'::character varying NOT NULL,
    approved_by bigint,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone,
    CONSTRAINT borrowings_borrower_role_check CHECK (((borrower_role)::text = ANY ((ARRAY['Dosen'::character varying, 'Mahasiswa'::character varying, 'Staff'::character varying, 'Karyawan'::character varying])::text[]))),
    CONSTRAINT borrowings_status_check CHECK (((status)::text = ANY ((ARRAY['Aktif'::character varying, 'Selesai'::character varying, 'Terlambat'::character varying])::text[])))
);


ALTER TABLE public.borrowings OWNER TO postgres;

--
-- Name: borrowings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.borrowings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.borrowings_id_seq OWNER TO postgres;

--
-- Name: borrowings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.borrowings_id_seq OWNED BY public.borrowings.id;


--
-- Name: cache; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cache (
    key character varying(255) NOT NULL,
    value text NOT NULL,
    expiration integer NOT NULL
);


ALTER TABLE public.cache OWNER TO postgres;

--
-- Name: cache_locks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cache_locks (
    key character varying(255) NOT NULL,
    owner character varying(255) NOT NULL,
    expiration integer NOT NULL
);


ALTER TABLE public.cache_locks OWNER TO postgres;

--
-- Name: failed_jobs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.failed_jobs (
    id bigint NOT NULL,
    uuid character varying(255) NOT NULL,
    connection text NOT NULL,
    queue text NOT NULL,
    payload text NOT NULL,
    exception text NOT NULL,
    failed_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.failed_jobs OWNER TO postgres;

--
-- Name: failed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.failed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.failed_jobs_id_seq OWNER TO postgres;

--
-- Name: failed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.failed_jobs_id_seq OWNED BY public.failed_jobs.id;


--
-- Name: job_batches; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job_batches (
    id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    total_jobs integer NOT NULL,
    pending_jobs integer NOT NULL,
    failed_jobs integer NOT NULL,
    failed_job_ids text NOT NULL,
    options text,
    cancelled_at integer,
    created_at integer NOT NULL,
    finished_at integer
);


ALTER TABLE public.job_batches OWNER TO postgres;

--
-- Name: jobs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jobs (
    id bigint NOT NULL,
    queue character varying(255) NOT NULL,
    payload text NOT NULL,
    attempts smallint NOT NULL,
    reserved_at integer,
    available_at integer NOT NULL,
    created_at integer NOT NULL
);


ALTER TABLE public.jobs OWNER TO postgres;

--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.jobs_id_seq OWNER TO postgres;

--
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.jobs_id_seq OWNED BY public.jobs.id;


--
-- Name: maintenances; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.maintenances (
    id bigint NOT NULL,
    maintenance_id character varying(255) NOT NULL,
    asset_id bigint NOT NULL,
    type character varying(255) NOT NULL,
    maintenance_date date NOT NULL,
    cost numeric(12,2) NOT NULL,
    description text NOT NULL,
    technician character varying(255) NOT NULL,
    status character varying(255) DEFAULT 'Selesai'::character varying NOT NULL,
    recorded_by bigint NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone,
    CONSTRAINT maintenances_status_check CHECK (((status)::text = ANY ((ARRAY['Pending'::character varying, 'Dalam Proses'::character varying, 'Selesai'::character varying])::text[]))),
    CONSTRAINT maintenances_type_check CHECK (((type)::text = ANY ((ARRAY['Preventif'::character varying, 'Corrective'::character varying, 'Predictive'::character varying, 'Emergency'::character varying])::text[])))
);


ALTER TABLE public.maintenances OWNER TO postgres;

--
-- Name: maintenances_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.maintenances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.maintenances_id_seq OWNER TO postgres;

--
-- Name: maintenances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.maintenances_id_seq OWNED BY public.maintenances.id;


--
-- Name: migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);


ALTER TABLE public.migrations OWNER TO postgres;

--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.migrations_id_seq OWNER TO postgres;

--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- Name: qr_codes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qr_codes (
    id bigint NOT NULL,
    qr_code_id character varying(255) NOT NULL,
    asset_id bigint NOT NULL,
    code_content character varying(255) NOT NULL,
    status character varying(255) DEFAULT 'Aktif'::character varying NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone,
    CONSTRAINT qr_codes_status_check CHECK (((status)::text = ANY ((ARRAY['Aktif'::character varying, 'Nonaktif'::character varying])::text[])))
);


ALTER TABLE public.qr_codes OWNER TO postgres;

--
-- Name: qr_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.qr_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.qr_codes_id_seq OWNER TO postgres;

--
-- Name: qr_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.qr_codes_id_seq OWNED BY public.qr_codes.id;


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sessions (
    id character varying(255) NOT NULL,
    user_id bigint,
    ip_address character varying(45),
    user_agent text,
    payload text NOT NULL,
    last_activity integer NOT NULL
);


ALTER TABLE public.sessions OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    username character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    email_verified_at timestamp(0) without time zone,
    password character varying(255) NOT NULL,
    level character varying(255) DEFAULT 'Sarpras'::character varying NOT NULL,
    avatar character varying(255),
    status character varying(255) DEFAULT 'Aktif'::character varying NOT NULL,
    remember_token character varying(100),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone,
    CONSTRAINT users_level_check CHECK (((level)::text = ANY ((ARRAY['Admin'::character varying, 'Sarpras'::character varying, 'Keuangan'::character varying, 'Kaprodi'::character varying, 'Rektor'::character varying])::text[]))),
    CONSTRAINT users_status_check CHECK (((status)::text = ANY ((ARRAY['Aktif'::character varying, 'Nonaktif'::character varying])::text[])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: asset_requests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_requests ALTER COLUMN id SET DEFAULT nextval('public.asset_requests_id_seq'::regclass);


--
-- Name: asset_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_types ALTER COLUMN id SET DEFAULT nextval('public.asset_types_id_seq'::regclass);


--
-- Name: assets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets ALTER COLUMN id SET DEFAULT nextval('public.assets_id_seq'::regclass);


--
-- Name: borrowings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.borrowings ALTER COLUMN id SET DEFAULT nextval('public.borrowings_id_seq'::regclass);


--
-- Name: failed_jobs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);


--
-- Name: jobs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs ALTER COLUMN id SET DEFAULT nextval('public.jobs_id_seq'::regclass);


--
-- Name: maintenances id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maintenances ALTER COLUMN id SET DEFAULT nextval('public.maintenances_id_seq'::regclass);


--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- Name: qr_codes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qr_codes ALTER COLUMN id SET DEFAULT nextval('public.qr_codes_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: asset_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_requests (id, request_id, requester_id, asset_name, asset_type_id, quantity, estimated_price, priority, reason, status, approved_by, approved_at, approval_notes, created_at, updated_at, deleted_at) FROM stdin;
1	REQ-001	1	LCD Asus	1	1	400000.00	Sedang	Sudah burik.	Pending	\N	\N	\N	2025-11-29 16:15:11	2025-11-29 16:15:11	\N
\.


--
-- Data for Name: asset_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_types (id, code, name, description, created_at, updated_at) FROM stdin;
1	KOM	Komputer & Periferal	Laptop, PC, Monitor, Printer, dll	2025-11-27 12:06:00	2025-11-27 12:06:00
2	ELK	Elektronik Umum	Sensor, Modul, Komponen Elektronika	2025-11-27 12:06:00	2025-11-27 12:06:00
3	JAR	Jaringan	Router, Switch, Kabel LAN, FO	2025-11-27 12:06:00	2025-11-27 12:06:00
4	FUR	Furniture	Meja, Kursi, Lemari, Papan Tulis	2025-11-27 12:06:00	2025-11-27 12:06:00
5	ATK	Alat & Perkakas	Obeng, Tang, Crimping Tool	2025-11-27 12:06:00	2025-11-27 12:06:00
6	LAN	Lainnya	Barang-barang umum lainnya	2025-11-27 12:06:00	2025-11-27 12:06:00
\.


--
-- Data for Name: assets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.assets (id, asset_id, name, asset_type_id, brand, serial_number, price, purchase_date, location, condition, status, image, qr_code, created_at, updated_at, deleted_at) FROM stdin;
2	2024/01/KOM-0002	Proyektor Epson	1	Epson	EP789012	5000000.00	2024-01-12	Aula	Baik	Dipinjam	assets/proyektor-epson.jpeg	EP789012345	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
3	2024/01/FUR-0001	Meja Kerja	4	Olympic	OL345678	2500000.00	2024-01-10	Ruang Dosen	Rusak Ringan	Maintenance	assets/meja-kerja.jpeg	OL345678901	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
4	2024/01/KOM-0003	Deskbook	1	Hp	DBHP001	10000000.00	2024-01-01	9 di lab TI, 1 di R. TI	Baik	Tersedia	assets/deskbook.jpg	DBHP001BC	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
5	2024/01/KOM-0004	Keyboard	1	Logitech, Hp	KB001	125000.00	2024-01-01	Gudang	Baik	Tersedia	assets/keyboard.png	KB001BC	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
7	2024/01/KOM-0006	Monitor DELL E2211H	1	Dell	MNDELL001	780000.00	2024-01-01	17 di lab TI	Baik	Tersedia	assets/monitor-dell.png	MNDELL001BC	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
8	2024/01/KOM-0007	PC Rakitan	1	Asrock	PCRAK001	3000000.00	2024-01-01	17 di lab TI	Baik	Tersedia	assets/pc-rakitan.jpg	PCRAK001BC	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
9	2024/01/KOM-0008	Headphones JETE	1	JETE	HPJETE001	0.00	2024-01-01	Gudang	Baik	Tersedia	assets/headphones-jete.jpg	HPJETE001BC	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
10	2024/01/JAR-0001	Splicer	3	Fusion	SPLCR001	15000000.00	2024-01-01	Ruang Server	Baik	Tersedia	https://via.placeholder.com/400x300/e2e8f0/64748b?text=Splicer	SPLCR001BC	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
11	2024/01/JAR-0002	Fiber optic 250 meter	3	Generic	FO250M001	240000.00	2024-01-01	Gudang	Baik	Tersedia	https://via.placeholder.com/400x300/e2e8f0/64748b?text=Fiber+Optic	FO250M001BC	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
12	2024/01/JAR-0003	Switch tplink	3	tp-link	SWTPLINK001	750000.00	2024-01-01	Ruang Server	Baik	Tersedia	https://via.placeholder.com/400x300/e2e8f0/64748b?text=Switch+TPLink	SWTPLINK001BC	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
13	2024/01/JAR-0004	HTB	3	Netlink	HTB001	100000.00	2024-01-01	Gudang	Baik	Tersedia	https://via.placeholder.com/400x300/e2e8f0/64748b?text=HTB	HTB001BC	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
14	2024/01/FUR-0002	Rak rako	4	Raaco	RAKRAKO001	450000.00	2024-01-01	Gudang	Baik	Tersedia	https://via.placeholder.com/400x300/e2e8f0/64748b?text=Rak+Raako	RAKRAKO001BC	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
15	2024/01/ATK-0001	CRIMPING BIRU schneider	5	Schneider	CRIMPSCH001	350000.00	2024-01-01	Toolbox	Baik	Tersedia	https://via.placeholder.com/400x300/e2e8f0/64748b?text=Crimping+Schneider	CRIMPSCH001BC	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
16	2024/01/LAN-0001	Container Box cb 82 hijau	6	Shinpo	CBH001	140000.00	2024-01-01	Gudang	Baik	Tersedia	https://via.placeholder.com/400x300/e2e8f0/64748b?text=Container+Box	CBH001BC	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
17	2024/01/ELK-0025	Sensor LDR	2	Generic	SNSRLDR001	400.00	2024-01-01	Laci Biru A	Baik	Tersedia	https://via.placeholder.com/400x300/e2e8f0/64748b?text=Sensor+LDR	SNSRLDR001BC	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
18	2024/01/ELK-0135	ARDUINO UNO R3	2	Arduino	ARDUINOUNOR3001	99900.00	2024-01-01	Lemari Komponen	Baik	Tersedia	https://via.placeholder.com/400x300/e2e8f0/64748b?text=Arduino+Uno+R3	ARDUINOUNOR3001BC	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
19	2024/01/ELK-0116	NodeMCU (ESP8266)	2	Amica	NODEMCUESP8266001	39500.00	2024-01-01	Lemari Komponen	Baik	Tersedia	https://via.placeholder.com/400x300/e2e8f0/64748b?text=NodeMCU+ESP8266	NODEMCUESP8266001BC	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
20	2025/11/LAN-0002	Karpet	6	Tidak ada merek	LAN-t6dx8g-XYYIP	200000.00	2025-11-27	Ruang IT	Baik	Tersedia	\N	LAN-t6dx8m-V4AEC	2025-11-27 12:26:46	2025-11-27 12:27:33	2025-11-27 12:27:33
6	2024/01/KOM-0005	Mouse	1	Logitech, Hp	MS001	70000.00	2024-01-01	Gudang	Baik	Tersedia	assets/mouse.jpg	MS001BC	2025-11-27 12:06:02	2025-11-27 22:30:46	\N
1	2024/01/KOM-0001	Laptop HP ProBook	1	HP	HP123456	8000000.00	2024-01-15	Ruang IT	Baik	Tersedia	assets/ZdtrgkjxBZnYkwKAO9GARhjfk0HuiZXyKW6ZbFzS.jpg	HP123456789	2025-11-27 12:06:02	2025-11-27 23:04:05	\N
21	2025/11/FUR-0002	Papan Tulis	4	Tidak Ada Merek	FUR-t6fptb-WHVAH	130000.00	2025-11-28	Ruang IT	Baik	Tersedia	\N	FUR-t6fpu2-Y29D9	2025-11-28 11:42:02	2025-11-28 11:42:02	\N
22	2025/11/FUR-0003	Papan Tulis	4	anu	FUR-t6fqon-QWXHI	60000.00	2025-11-28	Ruang IT	Baik	Tersedia	\N	FUR-t6fqos-ME1ZJ	2025-11-28 12:00:28	2025-11-28 12:10:09	2025-11-28 12:10:09
\.


--
-- Data for Name: borrowings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.borrowings (id, borrowing_id, asset_id, borrower_name, borrower_role, borrow_date, return_date, actual_return_date, purpose, status, approved_by, created_at, updated_at, deleted_at) FROM stdin;
1	BRW-001	6	Bayu	Staff	2025-11-27	2025-12-04	2025-11-27	minjem aja	Selesai	1	2025-11-27 22:30:14	2025-11-27 22:30:46	\N
\.


--
-- Data for Name: cache; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cache (key, value, expiration) FROM stdin;
\.


--
-- Data for Name: cache_locks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cache_locks (key, owner, expiration) FROM stdin;
\.


--
-- Data for Name: failed_jobs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
\.


--
-- Data for Name: job_batches; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job_batches (id, name, total_jobs, pending_jobs, failed_jobs, failed_job_ids, options, cancelled_at, created_at, finished_at) FROM stdin;
\.


--
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.jobs (id, queue, payload, attempts, reserved_at, available_at, created_at) FROM stdin;
\.


--
-- Data for Name: maintenances; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.maintenances (id, maintenance_id, asset_id, type, maintenance_date, cost, description, technician, status, recorded_by, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.migrations (id, migration, batch) FROM stdin;
1	0001_01_01_000001_create_cache_table	1
2	0001_01_01_000002_create_jobs_table	1
3	2025_11_21_025007_create_users_table	1
4	2025_11_21_025019_create_asset_types_table	1
5	2025_11_21_025021_create_assets_table	1
6	2025_11_21_025024_create_borrowings_table	1
7	2025_11_21_025027_create_maintenances_table	1
8	2025_11_21_025030_create_asset_requests_table	1
9	2025_11_21_025541_create_qr_codes_table	1
10	2025_11_21_104445_create_sessions_table	1
\.


--
-- Data for Name: qr_codes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.qr_codes (id, qr_code_id, asset_id, code_content, status, created_at, updated_at, deleted_at) FROM stdin;
1	QCD-001	1	HP123456789	Aktif	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
2	QCD-002	2	EP789012345	Aktif	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
3	QCD-003	3	OL345678901	Aktif	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
4	QCD-004	4	DBHP001BC	Aktif	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
5	QCD-005	5	KB001BC	Aktif	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
6	QCD-006	6	MS001BC	Aktif	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
7	QCD-007	7	MNDELL001BC	Aktif	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
8	QCD-008	8	PCRAK001BC	Aktif	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
9	QCD-009	9	HPJETE001BC	Aktif	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
10	QCD-010	10	SPLCR001BC	Aktif	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
11	QCD-011	11	FO250M001BC	Aktif	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
12	QCD-012	12	SWTPLINK001BC	Aktif	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
13	QCD-013	13	HTB001BC	Aktif	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
14	QCD-014	14	RAKRAKO001BC	Aktif	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
15	QCD-015	15	CRIMPSCH001BC	Aktif	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
16	QCD-016	16	CBH001BC	Aktif	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
17	QCD-017	17	SNSRLDR001BC	Aktif	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
18	QCD-018	18	ARDUINOUNOR3001BC	Aktif	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
19	QCD-019	19	NODEMCUESP8266001BC	Aktif	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
20	QCD-020	20	LAN-t6dx8m-V4AEC	Aktif	2025-11-27 12:26:46	2025-11-27 12:27:33	2025-11-27 12:27:33
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sessions (id, user_id, ip_address, user_agent, payload, last_activity) FROM stdin;
Xw9XnRho1MTM5krTbVLJ7XBbeqeZ6VGBT9p01T3J	1	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36	YTo0OntzOjY6Il90b2tlbiI7czo0MDoiMVh1bElsUXc4VnJOTGhNZmxYUjVuQmVzMHk2OGJnMWtGWlR3YTNCTSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzI6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hc3NldHMtaW52IjtzOjU6InJvdXRlIjtzOjE2OiJhc3NldHMtaW52LmluZGV4Ijt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6MTt9	1764433298
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, username, email, email_verified_at, password, level, avatar, status, remember_token, created_at, updated_at, deleted_at) FROM stdin;
1	Administrator	admin	admin@stti.ac.id	\N	$2y$12$ENbfhPujuJLweEcZHXq9eeZ4LJmK/9YASpX/1/hvBwVamy3xpTi/i	Admin	assets/admin.png	Aktif	\N	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
2	Staff Sarpras	sarpras	sarpras@stti.ac.id	\N	$2y$12$GaOF.dRzzq0rNAojTN91sO1zFGK8gqbUMlN07wxdq9IQH6PdhpAX6	Sarpras	assets/sarpras.png	Aktif	\N	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
3	Muhammad Sugiarto, S.E., M.M.	rektor	rektor@stti.ac.id	\N	$2y$12$VlDGE8DX/2rLSVBxInKAA.wCKXC/3y9YYJWijVMdcJpP9WlM5q4Am	Rektor	assets/rektor.png	Aktif	\N	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
4	Bima Azis Kusuma, S.T., M.T.	kaprodi	kaprodi@stti.ac.id	\N	$2y$12$OIe3NFe3cPFT.fYYhs3lI.1FgC365bXimXPXkiFwmA7RLIa8yiuFG	Kaprodi	assets/kaprodi.png	Aktif	\N	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
5	Mrs. Nazilah	keuangan	mrsnazilah@stti.ac.id	\N	$2y$12$qjIVJ0id1k7dmA1XarTpfuZtH1og9S1TG19ZcHnst1JtQ4iV.Esn6	Keuangan	assets/keuangan.png	Aktif	\N	2025-11-27 12:06:02	2025-11-27 12:06:02	\N
\.


--
-- Name: asset_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.asset_requests_id_seq', 1, true);


--
-- Name: asset_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.asset_types_id_seq', 7, true);


--
-- Name: assets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.assets_id_seq', 33, true);


--
-- Name: borrowings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.borrowings_id_seq', 1, true);


--
-- Name: failed_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);


--
-- Name: jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.jobs_id_seq', 1, false);


--
-- Name: maintenances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.maintenances_id_seq', 1, false);


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.migrations_id_seq', 10, true);


--
-- Name: qr_codes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.qr_codes_id_seq', 28, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 5, true);


--
-- Name: asset_requests asset_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_requests
    ADD CONSTRAINT asset_requests_pkey PRIMARY KEY (id);


--
-- Name: asset_requests asset_requests_request_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_requests
    ADD CONSTRAINT asset_requests_request_id_unique UNIQUE (request_id);


--
-- Name: asset_types asset_types_code_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_types
    ADD CONSTRAINT asset_types_code_unique UNIQUE (code);


--
-- Name: asset_types asset_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_types
    ADD CONSTRAINT asset_types_pkey PRIMARY KEY (id);


--
-- Name: assets assets_asset_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_asset_id_unique UNIQUE (asset_id);


--
-- Name: assets assets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (id);


--
-- Name: assets assets_qr_code_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_qr_code_unique UNIQUE (qr_code);


--
-- Name: assets assets_serial_number_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_serial_number_unique UNIQUE (serial_number);


--
-- Name: borrowings borrowings_borrowing_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.borrowings
    ADD CONSTRAINT borrowings_borrowing_id_unique UNIQUE (borrowing_id);


--
-- Name: borrowings borrowings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.borrowings
    ADD CONSTRAINT borrowings_pkey PRIMARY KEY (id);


--
-- Name: cache_locks cache_locks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cache_locks
    ADD CONSTRAINT cache_locks_pkey PRIMARY KEY (key);


--
-- Name: cache cache_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cache
    ADD CONSTRAINT cache_pkey PRIMARY KEY (key);


--
-- Name: failed_jobs failed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);


--
-- Name: failed_jobs failed_jobs_uuid_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);


--
-- Name: job_batches job_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_batches
    ADD CONSTRAINT job_batches_pkey PRIMARY KEY (id);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: maintenances maintenances_maintenance_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maintenances
    ADD CONSTRAINT maintenances_maintenance_id_unique UNIQUE (maintenance_id);


--
-- Name: maintenances maintenances_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maintenances
    ADD CONSTRAINT maintenances_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: qr_codes qr_codes_code_content_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qr_codes
    ADD CONSTRAINT qr_codes_code_content_unique UNIQUE (code_content);


--
-- Name: qr_codes qr_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qr_codes
    ADD CONSTRAINT qr_codes_pkey PRIMARY KEY (id);


--
-- Name: qr_codes qr_codes_qr_code_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qr_codes
    ADD CONSTRAINT qr_codes_qr_code_id_unique UNIQUE (qr_code_id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_unique UNIQUE (username);


--
-- Name: asset_requests_request_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX asset_requests_request_id_index ON public.asset_requests USING btree (request_id);


--
-- Name: asset_requests_status_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX asset_requests_status_index ON public.asset_requests USING btree (status);


--
-- Name: assets_asset_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assets_asset_id_index ON public.assets USING btree (asset_id);


--
-- Name: assets_qr_code_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assets_qr_code_index ON public.assets USING btree (qr_code);


--
-- Name: assets_serial_number_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assets_serial_number_index ON public.assets USING btree (serial_number);


--
-- Name: assets_status_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assets_status_index ON public.assets USING btree (status);


--
-- Name: borrowings_borrowing_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX borrowings_borrowing_id_index ON public.borrowings USING btree (borrowing_id);


--
-- Name: borrowings_status_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX borrowings_status_index ON public.borrowings USING btree (status);


--
-- Name: jobs_queue_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX jobs_queue_index ON public.jobs USING btree (queue);


--
-- Name: maintenances_maintenance_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX maintenances_maintenance_id_index ON public.maintenances USING btree (maintenance_id);


--
-- Name: maintenances_status_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX maintenances_status_index ON public.maintenances USING btree (status);


--
-- Name: qr_codes_code_content_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX qr_codes_code_content_index ON public.qr_codes USING btree (code_content);


--
-- Name: qr_codes_qr_code_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX qr_codes_qr_code_id_index ON public.qr_codes USING btree (qr_code_id);


--
-- Name: sessions_last_activity_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_last_activity_index ON public.sessions USING btree (last_activity);


--
-- Name: sessions_user_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_user_id_index ON public.sessions USING btree (user_id);


--
-- Name: asset_requests asset_requests_approved_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_requests
    ADD CONSTRAINT asset_requests_approved_by_foreign FOREIGN KEY (approved_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: asset_requests asset_requests_asset_type_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_requests
    ADD CONSTRAINT asset_requests_asset_type_id_foreign FOREIGN KEY (asset_type_id) REFERENCES public.asset_types(id) ON DELETE RESTRICT;


--
-- Name: asset_requests asset_requests_requester_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_requests
    ADD CONSTRAINT asset_requests_requester_id_foreign FOREIGN KEY (requester_id) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: assets assets_asset_type_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_asset_type_id_foreign FOREIGN KEY (asset_type_id) REFERENCES public.asset_types(id) ON DELETE RESTRICT;


--
-- Name: borrowings borrowings_approved_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.borrowings
    ADD CONSTRAINT borrowings_approved_by_foreign FOREIGN KEY (approved_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: borrowings borrowings_asset_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.borrowings
    ADD CONSTRAINT borrowings_asset_id_foreign FOREIGN KEY (asset_id) REFERENCES public.assets(id) ON DELETE RESTRICT;


--
-- Name: maintenances maintenances_asset_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maintenances
    ADD CONSTRAINT maintenances_asset_id_foreign FOREIGN KEY (asset_id) REFERENCES public.assets(id) ON DELETE RESTRICT;


--
-- Name: maintenances maintenances_recorded_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maintenances
    ADD CONSTRAINT maintenances_recorded_by_foreign FOREIGN KEY (recorded_by) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: qr_codes qr_codes_asset_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qr_codes
    ADD CONSTRAINT qr_codes_asset_id_foreign FOREIGN KEY (asset_id) REFERENCES public.assets(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict ycybewZ7IKVllIj5sfmsJaz6wRCathjg4amhXPYsQap7imfbvUzAieAKCjfxMwk

