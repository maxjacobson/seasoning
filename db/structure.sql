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
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: browser_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.browser_sessions (
    id bigint NOT NULL,
    token character varying NOT NULL,
    human_id bigint NOT NULL,
    last_seen_at timestamp without time zone NOT NULL,
    expires_at timestamp without time zone NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: COLUMN browser_sessions.token; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.browser_sessions.token IS 'The token that will be kept in localstorage and included with API requests';


--
-- Name: COLUMN browser_sessions.last_seen_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.browser_sessions.last_seen_at IS 'When the human last visited during this session';


--
-- Name: COLUMN browser_sessions.expires_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.browser_sessions.expires_at IS 'The time at which we should stop honoring the token and force them to log in again';


--
-- Name: browser_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.browser_sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: browser_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.browser_sessions_id_seq OWNED BY public.browser_sessions.id;


--
-- Name: humans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.humans (
    id bigint NOT NULL,
    handle character varying NOT NULL,
    email character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: COLUMN humans.handle; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.humans.handle IS 'The handle is the human''s nickname, username, or whatever you want to call it';


--
-- Name: COLUMN humans.email; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.humans.email IS 'Their email. This is how they''ll log in. No passwords. Just click a link in your email.';


--
-- Name: humans_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.humans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: humans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.humans_id_seq OWNED BY public.humans.id;


--
-- Name: magic_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.magic_links (
    id bigint NOT NULL,
    email character varying NOT NULL,
    token character varying NOT NULL,
    expires_at timestamp without time zone NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: COLUMN magic_links.email; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.magic_links.email IS 'The email address that the magic link is sent to. Following the link proves they are this human.';


--
-- Name: COLUMN magic_links.token; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.magic_links.token IS 'The thing that makes this link unique, which will be part of the link';


--
-- Name: COLUMN magic_links.expires_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.magic_links.expires_at IS 'When the magic link stops working';


--
-- Name: magic_links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.magic_links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: magic_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.magic_links_id_seq OWNED BY public.magic_links.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: browser_sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.browser_sessions ALTER COLUMN id SET DEFAULT nextval('public.browser_sessions_id_seq'::regclass);


--
-- Name: humans id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.humans ALTER COLUMN id SET DEFAULT nextval('public.humans_id_seq'::regclass);


--
-- Name: magic_links id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.magic_links ALTER COLUMN id SET DEFAULT nextval('public.magic_links_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: browser_sessions browser_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.browser_sessions
    ADD CONSTRAINT browser_sessions_pkey PRIMARY KEY (id);


--
-- Name: humans humans_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.humans
    ADD CONSTRAINT humans_pkey PRIMARY KEY (id);


--
-- Name: magic_links magic_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.magic_links
    ADD CONSTRAINT magic_links_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: humans_email_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX humans_email_unique ON public.humans USING btree (email);


--
-- Name: humans_handle_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX humans_handle_unique ON public.humans USING btree (handle);


--
-- Name: index_browser_sessions_on_human_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_browser_sessions_on_human_id ON public.browser_sessions USING btree (human_id);


--
-- Name: index_magic_links_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_magic_links_on_token ON public.magic_links USING btree (token);


--
-- Name: browser_sessions fk_rails_994ac30d0f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.browser_sessions
    ADD CONSTRAINT fk_rails_994ac30d0f FOREIGN KEY (human_id) REFERENCES public.humans(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20210310054759'),
('20210310055137'),
('20210310061023'),
('20210310073728');


