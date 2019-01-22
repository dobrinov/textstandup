SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: report_item_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.report_item_type AS ENUM (
    'DeliveredReportItem',
    'OngoingReportItem',
    'PlannedReportItem',
    'BlockerReportItem',
    'AnnouncementReportItem'
);


--
-- Name: report_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.report_type AS ENUM (
    'DeliveryReport',
    'MorningReport'
);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: companies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.companies (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: companies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.companies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.companies_id_seq OWNED BY public.companies.id;


--
-- Name: employments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employments (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    company_id bigint NOT NULL,
    admin boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: employments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.employments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.employments_id_seq OWNED BY public.employments.id;


--
-- Name: invitation_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invitation_links (
    id bigint NOT NULL,
    company_id bigint NOT NULL,
    inviting_user_id bigint NOT NULL,
    invited_user_id bigint,
    code character varying NOT NULL,
    used_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: invitation_links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.invitation_links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invitation_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.invitation_links_id_seq OWNED BY public.invitation_links.id;


--
-- Name: report_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.report_items (
    id bigint NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    type public.report_item_type NOT NULL,
    report_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: report_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.report_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: report_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.report_items_id_seq OWNED BY public.report_items.id;


--
-- Name: reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reports (
    id bigint NOT NULL,
    type public.report_type NOT NULL,
    user_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reports_id_seq OWNED BY public.reports.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subscriptions (
    id bigint NOT NULL,
    follower_id bigint NOT NULL,
    followee_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.subscriptions_id_seq OWNED BY public.subscriptions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    email character varying NOT NULL,
    encrypted_password character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    manager_id bigint,
    company_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: companies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies ALTER COLUMN id SET DEFAULT nextval('public.companies_id_seq'::regclass);


--
-- Name: employments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employments ALTER COLUMN id SET DEFAULT nextval('public.employments_id_seq'::regclass);


--
-- Name: invitation_links id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invitation_links ALTER COLUMN id SET DEFAULT nextval('public.invitation_links_id_seq'::regclass);


--
-- Name: report_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.report_items ALTER COLUMN id SET DEFAULT nextval('public.report_items_id_seq'::regclass);


--
-- Name: reports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports ALTER COLUMN id SET DEFAULT nextval('public.reports_id_seq'::regclass);


--
-- Name: subscriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions ALTER COLUMN id SET DEFAULT nextval('public.subscriptions_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: companies companies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- Name: employments employments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employments
    ADD CONSTRAINT employments_pkey PRIMARY KEY (id);


--
-- Name: invitation_links invitation_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invitation_links
    ADD CONSTRAINT invitation_links_pkey PRIMARY KEY (id);


--
-- Name: report_items report_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.report_items
    ADD CONSTRAINT report_items_pkey PRIMARY KEY (id);


--
-- Name: reports reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_employments_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_employments_on_company_id ON public.employments USING btree (company_id);


--
-- Name: index_employments_on_company_id_and_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_employments_on_company_id_and_user_id ON public.employments USING btree (company_id, user_id);


--
-- Name: index_employments_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_employments_on_user_id ON public.employments USING btree (user_id);


--
-- Name: index_invitation_links_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invitation_links_on_company_id ON public.invitation_links USING btree (company_id);


--
-- Name: index_invitation_links_on_invited_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invitation_links_on_invited_user_id ON public.invitation_links USING btree (invited_user_id);


--
-- Name: index_invitation_links_on_inviting_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invitation_links_on_inviting_user_id ON public.invitation_links USING btree (inviting_user_id);


--
-- Name: index_report_items_on_report_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_report_items_on_report_id ON public.report_items USING btree (report_id);


--
-- Name: index_report_items_on_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_report_items_on_type ON public.report_items USING btree (type);


--
-- Name: index_reports_on_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reports_on_type ON public.reports USING btree (type);


--
-- Name: index_reports_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reports_on_user_id ON public.reports USING btree (user_id);


--
-- Name: index_subscriptions_on_followee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_subscriptions_on_followee_id ON public.subscriptions USING btree (followee_id);


--
-- Name: index_subscriptions_on_follower_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_subscriptions_on_follower_id ON public.subscriptions USING btree (follower_id);


--
-- Name: index_subscriptions_on_follower_id_and_followee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_subscriptions_on_follower_id_and_followee_id ON public.subscriptions USING btree (follower_id, followee_id);


--
-- Name: index_users_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_company_id ON public.users USING btree (company_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_manager_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_manager_id ON public.users USING btree (manager_id);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: employments fk_rails_0022565859; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employments
    ADD CONSTRAINT fk_rails_0022565859 FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: report_items fk_rails_052dc35a5a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.report_items
    ADD CONSTRAINT fk_rails_052dc35a5a FOREIGN KEY (report_id) REFERENCES public.reports(id) ON DELETE CASCADE;


--
-- Name: invitation_links fk_rails_05557c43f2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invitation_links
    ADD CONSTRAINT fk_rails_05557c43f2 FOREIGN KEY (invited_user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: employments fk_rails_19190a6ae4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employments
    ADD CONSTRAINT fk_rails_19190a6ae4 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: invitation_links fk_rails_1d9faac17d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invitation_links
    ADD CONSTRAINT fk_rails_1d9faac17d FOREIGN KEY (inviting_user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: invitation_links fk_rails_420ec9b6b5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invitation_links
    ADD CONSTRAINT fk_rails_420ec9b6b5 FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: subscriptions fk_rails_9c831c3900; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT fk_rails_9c831c3900 FOREIGN KEY (followee_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: reports fk_rails_c7699d537d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT fk_rails_c7699d537d FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: subscriptions fk_rails_d91935f0cb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT fk_rails_d91935f0cb FOREIGN KEY (follower_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20180805540840'),
('20180806212446'),
('20181007195157'),
('20181016132210'),
('20181121215809'),
('20181210202631'),
('20181210202632'),
('20181210202707'),
('20181210202708');


