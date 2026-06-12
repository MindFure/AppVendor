--
-- PostgreSQL database dump
--

\restrict TmbASIoenhFsX2KRaACfHI3cXbnLuIcHsTQ4JdFJnnC6dSL7gKdbB98W8Ie8GlY

-- Dumped from database version 16.13 (Ubuntu 16.13-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.13 (Ubuntu 16.13-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: order_status; Type: TYPE; Schema: public; Owner: myuser
--

CREATE TYPE public.order_status AS ENUM (
    'new',
    'processing',
    'completed',
    'cancelled'
);


ALTER TYPE public.order_status OWNER TO myuser;

--
-- Name: user_role; Type: TYPE; Schema: public; Owner: myuser
--

CREATE TYPE public.user_role AS ENUM (
    'user',
    'admin'
);


ALTER TYPE public.user_role OWNER TO myuser;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cart; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.cart (
    id integer NOT NULL,
    user_id integer,
    session_id character varying(255),
    product_id integer NOT NULL,
    quantity integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.cart OWNER TO myuser;

--
-- Name: cart_id_seq; Type: SEQUENCE; Schema: public; Owner: myuser
--

CREATE SEQUENCE public.cart_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cart_id_seq OWNER TO myuser;

--
-- Name: cart_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myuser
--

ALTER SEQUENCE public.cart_id_seq OWNED BY public.cart.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.categories OWNER TO myuser;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categories_id_seq OWNER TO myuser;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: order_items; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.order_items (
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    product_name character varying(255) NOT NULL,
    id integer NOT NULL,
    quantity integer NOT NULL,
    price numeric(10,2)
);


ALTER TABLE public.order_items OWNER TO myuser;

--
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: myuser
--

CREATE SEQUENCE public.order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_items_id_seq OWNER TO myuser;

--
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myuser
--

ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    user_id integer,
    order_number character varying(50),
    status public.order_status DEFAULT 'new'::public.order_status,
    name character varying(100),
    phone character varying(20),
    address text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    total numeric(10,2) NOT NULL
);


ALTER TABLE public.orders OWNER TO myuser;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: myuser
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_id_seq OWNER TO myuser;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myuser
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.products (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    sku character varying(100),
    category_id integer NOT NULL,
    quantity integer DEFAULT 0,
    description text,
    image character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    price numeric(10,2)
);


ALTER TABLE public.products OWNER TO myuser;

--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: myuser
--

CREATE SEQUENCE public.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.products_id_seq OWNER TO myuser;

--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myuser
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: products_id_seq1; Type: SEQUENCE; Schema: public; Owner: myuser
--

ALTER TABLE public.products ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.products_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    role public.user_role DEFAULT 'user'::public.user_role,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO myuser;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: myuser
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO myuser;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myuser
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: cart id; Type: DEFAULT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.cart ALTER COLUMN id SET DEFAULT nextval('public.cart_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: order_items id; Type: DEFAULT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: cart; Type: TABLE DATA; Schema: public; Owner: myuser
--

COPY public.cart (id, user_id, session_id, product_id, quantity, created_at) FROM stdin;
2	\N	8bf924f47e236a466256bad3aaa3534c	25	1	2026-03-27 13:39:51.067167
3	\N	8bf924f47e236a466256bad3aaa3534c	23	1	2026-03-27 13:50:47.479905
36	\N	30bc028804802f375f6bf1419d1910e7	20	3	2026-03-27 14:24:07.278564
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories (id, name, created_at) FROM stdin;
1	Двигатель	2026-03-27 13:29:43.908487
2	Масла и жидкости	2026-03-27 13:29:43.91131
3	Фильтры	2026-03-27 13:29:43.913183
4	Тормозная система	2026-03-27 13:29:43.915522
5	Подвеска	2026-03-27 13:29:43.918649
6	Электроника	2026-03-27 13:29:43.920814
7	Кузовные запчасти	2026-03-27 13:29:43.922965
8	Выхлопная система	2026-03-27 13:29:43.925908
9	Трансмиссия	2026-03-27 13:29:43.928255
10	Охлаждение	2026-03-27 13:29:43.931698
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: myuser
--

COPY public.order_items (order_id, product_id, product_name, id, quantity, price) FROM stdin;
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: myuser
--

COPY public.orders (id, user_id, order_number, status, name, phone, address, created_at, total) FROM stdin;
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: myuser
--

COPY public.products (id, name, sku, category_id, quantity, description, image, created_at, price) FROM stdin;
14	Масло моторное 5W-30 4л	OIL-001	2	50	Синтетическое моторное масло для бензиновых и дизельных двигателей	oil-5w30.jpg	2026-03-27 13:37:33.370004	2500.00
15	Масло моторное 10W-40 4л	OIL-002	2	45	Полусинтетическое моторное масло	oil-10w40.jpg	2026-03-27 13:37:33.3729	2200.00
16	Фильтр масляный	FIL-001	3	100	Масляный фильтр для легковых автомобилей	oil-filter.jpg	2026-03-27 13:37:33.375193	450.00
17	Фильтр воздушный	FIL-002	3	80	Воздушный фильтр двигателя	air-filter.jpg	2026-03-27 13:37:33.377349	350.00
18	Фильтр салона	FIL-003	3	120	Салонный фильтр с активированным углем	cabin-filter.jpg	2026-03-27 13:37:33.379171	280.00
19	Колодки тормозные передние	BRK-001	4	30	Тормозные колодки для передних колес	brake-pads.jpg	2026-03-27 13:37:33.380819	1800.00
20	Диск тормозной передний	BRK-002	4	25	Вентилируемый тормозной диск	brake-disc.jpg	2026-03-27 13:37:33.382685	3200.00
21	Амортизатор передний	SUS-001	5	20	Газомасляный амортизатор	shock-absorber.jpg	2026-03-27 13:37:33.384916	4500.00
22	Сайлентблок	SUS-002	5	60	Сайлентблок переднего рычага	silentblock.jpg	2026-03-27 13:37:33.386338	650.00
23	Аккумулятор 60 Ач	ELE-001	6	15	Автомобильный аккумулятор 60 Ач	battery.jpg	2026-03-27 13:37:33.389127	5500.00
24	Лампа H7	ELE-002	6	200	Галогенная лампа ближнего света	lamp-h7.jpg	2026-03-27 13:37:33.391015	350.00
25	Свеча зажигания	ELE-003	6	150	Иридиевая свеча зажигания	spark-plug.jpg	2026-03-27 13:37:33.393766	280.00
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: myuser
--

COPY public.users (id, username, email, password, role, created_at) FROM stdin;
2	user	user@mail.ru	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	user	2026-03-27 13:37:33.397754
4	admin	admin@shop.ru	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	admin	2026-03-27 14:20:57.621426
3	dima	dima-zop2012@yandex.ru	$2y$12$3M8SvX./ND4DhTIr3WNjBebdD.PUcI18vTVaG.M.dRf4CHkgGsfoq	admin	2026-03-27 13:39:33.762936
\.


--
-- Name: cart_id_seq; Type: SEQUENCE SET; Schema: public; Owner: myuser
--

SELECT pg_catalog.setval('public.cart_id_seq', 36, true);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categories_id_seq', 10, true);


--
-- Name: order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: myuser
--

SELECT pg_catalog.setval('public.order_items_id_seq', 1, false);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: myuser
--

SELECT pg_catalog.setval('public.orders_id_seq', 1, false);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: myuser
--

SELECT pg_catalog.setval('public.products_id_seq', 1, false);


--
-- Name: products_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: myuser
--

SELECT pg_catalog.setval('public.products_id_seq1', 25, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: myuser
--

SELECT pg_catalog.setval('public.users_id_seq', 4, true);


--
-- Name: cart cart_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: orders orders_order_number_key; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_order_number_key UNIQUE (order_number);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id) INCLUDE (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_email_key; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_email_key UNIQUE (username, email);


--
-- Name: idx_cart_session; Type: INDEX; Schema: public; Owner: myuser
--

CREATE INDEX idx_cart_session ON public.cart USING btree (session_id);


--
-- Name: idx_cart_user; Type: INDEX; Schema: public; Owner: myuser
--

CREATE INDEX idx_cart_user ON public.cart USING btree (user_id);


--
-- Name: idx_order_items_order; Type: INDEX; Schema: public; Owner: myuser
--

CREATE INDEX idx_order_items_order ON public.order_items USING btree (order_id);


--
-- Name: idx_order_items_product; Type: INDEX; Schema: public; Owner: myuser
--

CREATE INDEX idx_order_items_product ON public.order_items USING btree (product_id);


--
-- Name: idx_orders_created; Type: INDEX; Schema: public; Owner: myuser
--

CREATE INDEX idx_orders_created ON public.orders USING btree (created_at);


--
-- Name: idx_orders_status; Type: INDEX; Schema: public; Owner: myuser
--

CREATE INDEX idx_orders_status ON public.orders USING btree (status);


--
-- Name: idx_orders_user; Type: INDEX; Schema: public; Owner: myuser
--

CREATE INDEX idx_orders_user ON public.orders USING btree (user_id);


--
-- Name: idx_products_category; Type: INDEX; Schema: public; Owner: myuser
--

CREATE INDEX idx_products_category ON public.products USING btree (category_id);


--
-- Name: idx_products_sku; Type: INDEX; Schema: public; Owner: myuser
--

CREATE INDEX idx_products_sku ON public.products USING btree (sku);


--
-- Name: products fk_category_id; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT fk_category_id FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE SET NULL NOT VALID;


--
-- Name: order_items order_id; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_id FOREIGN KEY (order_id) REFERENCES public.orders(id) NOT VALID;


--
-- Name: orders orders_key; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_key FOREIGN KEY (user_id) REFERENCES public.users(id) NOT VALID;


--
-- Name: cart prod_id; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT prod_id FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE NOT VALID;


--
-- Name: order_items product_id; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT product_id FOREIGN KEY (product_id) REFERENCES public.products(id) NOT VALID;


--
-- Name: cart user_id; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT user_id FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE NOT VALID;


--
-- Name: TABLE categories; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.categories TO myuser;


--
-- Name: SEQUENCE categories_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.categories_id_seq TO myuser;


--
-- PostgreSQL database dump complete
--

\unrestrict TmbASIoenhFsX2KRaACfHI3cXbnLuIcHsTQ4JdFJnnC6dSL7gKdbB98W8Ie8GlY

