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
-- Name: task_states; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.task_states AS ENUM (
    'planned',
    'in_progress',
    'delivered'
);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: announcements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.announcements (
    id bigint NOT NULL,
    title character varying NOT NULL,
    summary character varying NOT NULL,
    daily_report_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: announcements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.announcements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: announcements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.announcements_id_seq OWNED BY public.announcements.id;


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
-- Name: blockers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.blockers (
    id bigint NOT NULL,
    title character varying NOT NULL,
    summary character varying NOT NULL,
    daily_report_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: blockers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.blockers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: blockers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.blockers_id_seq OWNED BY public.blockers.id;


--
-- Name: daily_reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.daily_reports (
    id bigint NOT NULL,
    day integer NOT NULL,
    month integer NOT NULL,
    year integer NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: daily_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.daily_reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: daily_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.daily_reports_id_seq OWNED BY public.daily_reports.id;


--
-- Name: invitation_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invitation_links (
    id bigint NOT NULL,
    team_id bigint NOT NULL,
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
-- Name: memberships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.memberships (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    team_id bigint NOT NULL,
    admin boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.memberships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.memberships_id_seq OWNED BY public.memberships.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tasks (
    id bigint NOT NULL,
    state public.task_states NOT NULL,
    title character varying NOT NULL,
    summary character varying NOT NULL,
    daily_report_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tasks_id_seq OWNED BY public.tasks.id;


--
-- Name: teams; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.teams (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.teams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.teams_id_seq OWNED BY public.teams.id;


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
-- Name: announcements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.announcements ALTER COLUMN id SET DEFAULT nextval('public.announcements_id_seq'::regclass);


--
-- Name: blockers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blockers ALTER COLUMN id SET DEFAULT nextval('public.blockers_id_seq'::regclass);


--
-- Name: daily_reports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_reports ALTER COLUMN id SET DEFAULT nextval('public.daily_reports_id_seq'::regclass);


--
-- Name: invitation_links id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invitation_links ALTER COLUMN id SET DEFAULT nextval('public.invitation_links_id_seq'::regclass);


--
-- Name: memberships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships ALTER COLUMN id SET DEFAULT nextval('public.memberships_id_seq'::regclass);


--
-- Name: tasks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks ALTER COLUMN id SET DEFAULT nextval('public.tasks_id_seq'::regclass);


--
-- Name: teams id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams ALTER COLUMN id SET DEFAULT nextval('public.teams_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: announcements announcements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: blockers blockers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blockers
    ADD CONSTRAINT blockers_pkey PRIMARY KEY (id);


--
-- Name: daily_reports daily_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_reports
    ADD CONSTRAINT daily_reports_pkey PRIMARY KEY (id);


--
-- Name: invitation_links invitation_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invitation_links
    ADD CONSTRAINT invitation_links_pkey PRIMARY KEY (id);


--
-- Name: memberships memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT memberships_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_announcements_on_daily_report_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_announcements_on_daily_report_id ON public.announcements USING btree (daily_report_id);


--
-- Name: index_blockers_on_daily_report_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_blockers_on_daily_report_id ON public.blockers USING btree (daily_report_id);


--
-- Name: index_daily_reports_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_daily_reports_on_user_id ON public.daily_reports USING btree (user_id);


--
-- Name: index_daily_reports_on_user_id_and_day_and_month_and_year; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_daily_reports_on_user_id_and_day_and_month_and_year ON public.daily_reports USING btree (user_id, day, month, year);


--
-- Name: index_invitation_links_on_invited_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invitation_links_on_invited_user_id ON public.invitation_links USING btree (invited_user_id);


--
-- Name: index_invitation_links_on_inviting_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invitation_links_on_inviting_user_id ON public.invitation_links USING btree (inviting_user_id);


--
-- Name: index_invitation_links_on_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invitation_links_on_team_id ON public.invitation_links USING btree (team_id);


--
-- Name: index_memberships_on_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_memberships_on_team_id ON public.memberships USING btree (team_id);


--
-- Name: index_memberships_on_team_id_and_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_memberships_on_team_id_and_user_id ON public.memberships USING btree (team_id, user_id);


--
-- Name: index_memberships_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_memberships_on_user_id ON public.memberships USING btree (user_id);


--
-- Name: index_tasks_on_daily_report_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tasks_on_daily_report_id ON public.tasks USING btree (daily_report_id);


--
-- Name: index_tasks_on_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tasks_on_state ON public.tasks USING btree (state);


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
-- Name: invitation_links fk_rails_05557c43f2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invitation_links
    ADD CONSTRAINT fk_rails_05557c43f2 FOREIGN KEY (invited_user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: tasks fk_rails_06f523c085; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT fk_rails_06f523c085 FOREIGN KEY (daily_report_id) REFERENCES public.daily_reports(id) ON DELETE CASCADE;


--
-- Name: invitation_links fk_rails_1d9faac17d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invitation_links
    ADD CONSTRAINT fk_rails_1d9faac17d FOREIGN KEY (inviting_user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: announcements fk_rails_7c5e3eab4d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT fk_rails_7c5e3eab4d FOREIGN KEY (daily_report_id) REFERENCES public.daily_reports(id) ON DELETE CASCADE;


--
-- Name: invitation_links fk_rails_8a6e852545; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invitation_links
    ADD CONSTRAINT fk_rails_8a6e852545 FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE;


--
-- Name: memberships fk_rails_99326fb65d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT fk_rails_99326fb65d FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: memberships fk_rails_ae2aedcfaf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT fk_rails_ae2aedcfaf FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE;


--
-- Name: blockers fk_rails_c594661a11; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blockers
    ADD CONSTRAINT fk_rails_c594661a11 FOREIGN KEY (daily_report_id) REFERENCES public.daily_reports(id) ON DELETE CASCADE;


--
-- Name: daily_reports fk_rails_eeb337e825; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_reports
    ADD CONSTRAINT fk_rails_eeb337e825 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20180806212446'),
('20180828180000'),
('20180828180004'),
('20180828180434'),
('20180828180445'),
('20180828204326'),
('20181006092141'),
('20181007195157'),
('20181016132210');


