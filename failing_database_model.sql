DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE public.media_diffusion (
    id bigint NOT NULL,
    seller_id bigint,
    currency_id bigint NOT NULL,
    subscribed boolean DEFAULT false NOT NULL,
    ex_subscribed boolean DEFAULT false NOT NULL,
    interested boolean NOT NULL,
    certified boolean NOT NULL,
    scheduled_date timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    sent_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    message text,
    amount numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    reduced_price_offer integer,
    duration_offer character varying(100) DEFAULT NULL::character varying,
    status character varying(255) DEFAULT 'scheduled'::character varying NOT NULL,
    count_subscribed bigint DEFAULT 0 NOT NULL,
    count_ex_subscribed bigint DEFAULT 0 NOT NULL,
    count_interested bigint DEFAULT 0 NOT NULL,
    data jsonb,
    created_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    updated_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    uuid character varying(36) DEFAULT public.uuid_generate_v4() NOT NULL,
    available_as_mod boolean DEFAULT false NOT NULL
);

CREATE TABLE public.media_diffusion_medias (
    media_diffusion_id bigint NOT NULL,
    seller_media_id bigint NOT NULL
);


CREATE TABLE public.chat (
    id bigint NOT NULL,
    "user" bigint NOT NULL,
    seller bigint NOT NULL,
    last_message_date timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    muted_by_seller boolean NOT NULL,
    muted_by_user boolean NOT NULL,
    enabled boolean NOT NULL,
    read_by_seller boolean DEFAULT false NOT NULL,
    read_by_user boolean DEFAULT false NOT NULL,
    up_by_user_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    deleted_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    created_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    updated_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone
);


CREATE TABLE public.chat_medias (
    chat_message_id bigint NOT NULL,
    media_id bigint NOT NULL
);


CREATE TABLE public.chat_message (
    id bigint NOT NULL,
    chat_id bigint,
    private_media_id bigint,
    media_diffusion_id bigint,
    read_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    received_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    sent_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    send_to character varying(10) NOT NULL,
    message text,
    media_diffusion_target character varying(50) DEFAULT NULL::character varying,
    deleted_for_user_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    deleted_for_seller_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    deleted_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    created_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    updated_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    compliance integer DEFAULT 1 NOT NULL
);

CREATE SEQUENCE IF NOT EXISTS public.country_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE public.country (
    id bigint DEFAULT nextval('public.country_id_seq'::regclass) NOT NULL,
    currency_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    iso2 character varying(2) NOT NULL,
    iso3 character varying(3) NOT NULL,
    vat numeric(10,2) NOT NULL
);


CREATE TABLE public.seller (
    id bigint NOT NULL,
    parent_seller_id bigint,
    country_id bigint,
    account_type character varying(25) DEFAULT 'private'::character varying NOT NULL,
    company_name character varying(100) DEFAULT NULL::character varying,
    company_siret character varying(100) DEFAULT NULL::character varying,
    company_vat character varying(20) DEFAULT NULL::character varying,
    company_num_vat character varying(100) DEFAULT NULL::character varying,
    birthday date,
    profile_type character varying(50) DEFAULT NULL::character varying,
    balance numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    turnover numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    profit numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    sponsor_profit numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    visits_this_day bigint DEFAULT 0 NOT NULL,
    rfm character varying(5) DEFAULT NULL::character varying,
    bio character varying(1500) DEFAULT NULL::character varying,
    bio_city character varying(150) DEFAULT NULL::character varying,
    tag1 character varying(50) DEFAULT NULL::character varying,
    tag2 character varying(50) DEFAULT NULL::character varying,
    tag3 character varying(50) DEFAULT NULL::character varying,
    instagram character varying(100) DEFAULT NULL::character varying,
    instagram_count bigint DEFAULT 0 NOT NULL,
    facebook character varying(256) DEFAULT NULL::character varying,
    twitter character varying(256) DEFAULT NULL::character varying,
    snapchat character varying(256) DEFAULT NULL::character varying,
    tiktok character varying(256) DEFAULT NULL::character varying,
    offer smallint,
    offer_semi_annual_disable boolean,
    supermodel boolean DEFAULT false NOT NULL,
    rating character varying(20) DEFAULT 'unclassified'::character varying NOT NULL,
    charity_percent_offer smallint DEFAULT 0 NOT NULL,
    last_refresh_hour_date timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    last_refresh_day_date timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    facebook_id character varying(256) DEFAULT NULL::character varying,
    google_id character varying(256) DEFAULT NULL::character varying,
    opt_in_hide_account boolean DEFAULT false NOT NULL,
    opt_in_hide_subs_count boolean DEFAULT false NOT NULL,
    payouts_frequency character varying(20) DEFAULT 'bimonthly'::character varying NOT NULL,
    origin character varying(50) DEFAULT NULL::character varying,
    youtube character varying(256) DEFAULT NULL::character varying,
    enable_chat_for_all boolean DEFAULT true NOT NULL,
    uuid character varying(255) NOT NULL,
    username character varying(150) DEFAULT NULL::character varying,
    first_name character varying(100) DEFAULT NULL::character varying,
    last_name character varying(100) DEFAULT NULL::character varying,
    email character varying(256) NOT NULL,
    password character varying(255),
    roles json NOT NULL,
    time_zone character varying(255) DEFAULT 'Europe/Paris'::character varying,
    double_authentication boolean DEFAULT false,
    status character varying(100) DEFAULT 'pending'::character varying NOT NULL,
    gender character varying(255) DEFAULT NULL::character varying,
    lang character varying(3) DEFAULT 'en'::character varying,
    registration_date timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_connection_date timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    accept_terms_date timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    address character varying(255) DEFAULT NULL::character varying,
    zip_code character varying(20) DEFAULT NULL::character varying,
    city character varying(255) DEFAULT NULL::character varying,
    phone character varying(50) DEFAULT NULL::character varying,
    opt_in_emails character varying(50) DEFAULT 'not_confirmed'::character varying NOT NULL,
    notifications_disabled character varying(255) DEFAULT NULL::character varying,
    currency character varying(5) DEFAULT 'EUR'::character varying NOT NULL,
    note_trust smallint DEFAULT 0 NOT NULL,
    ip character varying(50) DEFAULT NULL::character varying,
    token character varying(100) DEFAULT NULL::character varying,
    password_updated_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    created_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    updated_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    media_watermarks jsonb DEFAULT '[]'::jsonb NOT NULL,
    apple_id character varying(256) DEFAULT NULL::character varying,
    front_page boolean,
    image_name character varying(255) DEFAULT NULL::character varying,
    image_original_name character varying(255) DEFAULT NULL::character varying,
    image_mime_type character varying(255) DEFAULT NULL::character varying,
    image_size integer,
    image_dimensions text,
    is_certified boolean DEFAULT false,
    phone_verified boolean,
    featured_videos jsonb DEFAULT '[]'::jsonb NOT NULL,
    waiting_currency character varying(5),
    last_online_date timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    seller_sponsoring_cut smallint DEFAULT 10 NOT NULL,
    notification_viewdate timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    privacy_agreement_date timestamp(0) with time zone DEFAULT NULL::timestamp with time zone,
    certification_status character varying(50),
    hashtags character varying[],
    subscription_offer_id character varying(36),
    ai_profile boolean DEFAULT false NOT NULL
);


COMMENT ON COLUMN public.seller.registration_date IS '(DC2Type:datetime_immutable)';


COMMENT ON COLUMN public.seller.image_dimensions IS '(DC2Type:simple_array)';


CREATE TABLE public.media__media (
    id bigint NOT NULL,
    file_path character varying(255) DEFAULT NULL::character varying,
    blurry_path character varying(255) DEFAULT NULL::character varying,
    file_type character varying(255) DEFAULT 'other'::character varying NOT NULL,
    media_type character varying(255) NOT NULL,
    comment text,
    status smallint DEFAULT 0 NOT NULL,
    size integer,
    chat_media boolean DEFAULT false NOT NULL,
    transformations json DEFAULT '[]'::json NOT NULL,
    extra_data json DEFAULT '[]'::json NOT NULL,
    uuid character varying(36) NOT NULL,
    feed_media_public boolean DEFAULT false NOT NULL,
    feed_media_likes_count bigint DEFAULT 0 NOT NULL,
    feed_homepage_compliance smallint DEFAULT 0 NOT NULL,
    scheduled_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    identified_sellers json DEFAULT '[]'::json NOT NULL,
    compliance smallint DEFAULT 0 NOT NULL,
    compliance_date timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    owner bigint NOT NULL,
    created_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    updated_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    user_type character varying(255) NOT NULL,
    rating text,
    last_public_at timestamp(0) with time zone DEFAULT NULL::timestamp with time zone,
    third_party_consent_at timestamp without time zone
);


COMMENT ON COLUMN public.media__media.scheduled_at IS '(DC2Type:datetime_immutable)';


COMMENT ON COLUMN public.media__media.compliance_date IS '(DC2Type:datetime_immutable)';


CREATE TABLE public.currency (
    id bigint NOT NULL,
    current_rate numeric(10,2),
    code character varying(10) NOT NULL,
    sign character varying(10) NOT NULL,
    created_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    updated_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    active boolean
);


CREATE TABLE public.user (
    id bigint NOT NULL,
    country_id bigint,
    facebook_id character varying(256) DEFAULT NULL::character varying,
    checkout_id character varying(100) DEFAULT NULL::character varying,
    client_intranet_id bigint NOT NULL,
    reminder_id bigint NOT NULL,
    last_refresh_date timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    birthday date,
    turnover numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    age_confirmed boolean DEFAULT false,
    uuid character varying(255) NOT NULL,
    username character varying(150) DEFAULT NULL::character varying,
    first_name character varying(100) DEFAULT NULL::character varying,
    last_name character varying(100) DEFAULT NULL::character varying,
    email character varying(256) NOT NULL,
    password character varying(255),
    roles json NOT NULL,
    time_zone character varying(255) DEFAULT 'Europe/Paris'::character varying,
    double_authentication boolean DEFAULT false,
    status character varying(100) DEFAULT 'pending'::character varying NOT NULL,
    gender character varying(255) DEFAULT NULL::character varying,
    lang character varying(3) DEFAULT 'en'::character varying,
    registration_date timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_connection_date timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    accept_terms_date timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    address character varying(255) DEFAULT NULL::character varying,
    zip_code character varying(20) DEFAULT NULL::character varying,
    city character varying(255) DEFAULT NULL::character varying,
    phone character varying(50) DEFAULT NULL::character varying,
    opt_in_emails character varying(50) DEFAULT 'not_confirmed'::character varying NOT NULL,
    notifications_disabled character varying(255) DEFAULT NULL::character varying,
    currency character varying(5) DEFAULT 'EUR'::character varying NOT NULL,
    note_trust smallint DEFAULT 0 NOT NULL,
    ip character varying(50) DEFAULT NULL::character varying,
    token character varying(100) DEFAULT NULL::character varying,
    password_updated_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    created_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    updated_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    seller_origin_id character varying(255) DEFAULT NULL::character varying,
    google_id character varying(256) DEFAULT NULL::character varying,
    apple_id character varying(256) DEFAULT NULL::character varying,
    is_certified boolean DEFAULT false,
    phone_verified boolean,
    last_online_date timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    notification_viewdate timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    age_verified boolean DEFAULT false,
    privacy_agreement_date timestamp(0) with time zone DEFAULT NULL::timestamp with time zone,
    view_sensitive_content boolean DEFAULT true NOT NULL
);


COMMENT ON COLUMN public.user.registration_date IS '(DC2Type:datetime_immutable)';


CREATE TABLE public.media__like (
    id bigint NOT NULL,
    media_id bigint,
    uuid character varying(36) NOT NULL,
    owner bigint NOT NULL,
    user_type character varying(255) DEFAULT NULL::character varying,
    created_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    updated_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone
);


CREATE TABLE public.orders (
    id bigint NOT NULL,
    seller_id bigint NOT NULL,
    user_id bigint NOT NULL,
    payment_card_id bigint,
    subscription_id bigint,
    private_media_id bigint,
    uuid character varying(255) NOT NULL,
    user_ip character varying(255) DEFAULT NULL::character varying,
    price_excl_tax numeric(10,2) NOT NULL,
    tax_percentage numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    price_excl_tax_euro numeric(10,2) NOT NULL,
    price_including_tax numeric(10,2) NOT NULL,
    price_including_tax_euro numeric(10,2) NOT NULL,
    currency character varying(255) NOT NULL,
    currency_rate numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    payment_method character varying(255) NOT NULL,
    payment_type character varying(255) DEFAULT NULL::character varying,
    invoice_id bigint,
    invoice_number character varying(255) DEFAULT NULL::character varying,
    invoice_secure character varying(255) DEFAULT NULL::character varying,
    credit_id integer,
    credit_number character varying(255) DEFAULT NULL::character varying,
    credit_secure character varying(255) DEFAULT NULL::character varying,
    status character varying(255) NOT NULL,
    refunded_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    bank_rate_type character varying(255) DEFAULT 'HR'::character varying NOT NULL,
    refund_reason character varying(255) DEFAULT NULL::character varying,
    old_subscription_date timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    new_subscription_date timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    deleted_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    created_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    updated_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    type character varying(255) NOT NULL,
    invoice_ready boolean DEFAULT false NOT NULL,
    date_purchase timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    subscription_period character varying(20) DEFAULT NULL::character varying,
    context character varying(255) DEFAULT NULL::character varying
);

CREATE TABLE public.payment_card (
    id bigint NOT NULL,
    user_id bigint,
    ip_add character varying(40) DEFAULT NULL::character varying,
    terminal character varying(50) DEFAULT NULL::character varying,
    source_id character varying(100) DEFAULT NULL::character varying,
    last_used_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    status smallint DEFAULT 1 NOT NULL,
    card_type character varying(20) NOT NULL,
    card_number character varying(20) NOT NULL,
    card_expiry_month character varying(2) NOT NULL,
    card_expiry_year character varying(4) NOT NULL,
    deleted_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    created_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    updated_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    initial_transaction_scheme_id character varying(50) DEFAULT NULL::character varying,
    provider_customer_id character varying(50) DEFAULT NULL::character varying
);


CREATE TABLE public.payment (
    id bigint NOT NULL,
    order_id bigint,
    voucher_id integer,
    payment_response_id character varying(255) DEFAULT NULL::character varying,
    amount_excluding_tax numeric(10,2) NOT NULL,
    amount_including_tax numeric(10,2) NOT NULL,
    currency character varying(3) NOT NULL,
    status smallint NOT NULL,
    reason_payment_cancelled character varying(255) DEFAULT NULL::character varying,
    deleted_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    created_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    updated_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    discount_amount_excluding_tax numeric(10,2) DEFAULT NULL::numeric,
    discount_amount_including_tax numeric(10,2) DEFAULT NULL::numeric
);


CREATE TABLE public.payment_request (
    id bigint NOT NULL,
    payment_id bigint,
    payment_response_id character varying(250) DEFAULT NULL::character varying,
    type_method character varying(50) DEFAULT NULL::character varying,
    errors text,
    status character varying(50),
    deleted_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    created_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    updated_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    buyer_ip character varying(50) DEFAULT NULL::character varying,
    payment_session_id character varying(50) DEFAULT NULL::character varying
);


CREATE TABLE public.private_media (
    id bigint NOT NULL,
    seller_id bigint,
    user_id bigint,
    uuid character varying(255) NOT NULL,
    type character varying(255) DEFAULT NULL::character varying,
    content text,
    accepted_by_seller_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    refused_by_seller_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    accepted_by_user_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    refused_by_user_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    files_uploaded_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    compliance boolean DEFAULT false NOT NULL,
    price_excluding_vat numeric(10,2) NOT NULL,
    price_including_vat numeric(10,2) NOT NULL,
    currency character varying(3) NOT NULL,
    media_receivers character varying(20) NOT NULL,
    status character varying(255) DEFAULT 'delivered'::character varying NOT NULL,
    deleted_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    created_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    updated_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    media_diffusion_id bigint,
    media_diffusion_target character varying(50) DEFAULT NULL::character varying,
    reminder_production_sent_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone
);


CREATE TABLE public.private_media_medias (
    private_media_id bigint NOT NULL,
    seller_media_id bigint NOT NULL
);


CREATE TABLE public.subscription (
    id bigint NOT NULL,
    seller_id bigint NOT NULL,
    user_id bigint NOT NULL,
    uuid character varying(255) NOT NULL,
    end_date timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    renewal boolean DEFAULT false NOT NULL,
    last_failure_date timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    payment_card_id bigint,
    currency character varying(255) DEFAULT 'EUR'::character varying NOT NULL,
    paypal_id character varying(100) DEFAULT NULL::character varying,
    epoch_id character varying(100) DEFAULT NULL::character varying,
    checkout_id character varying(100) DEFAULT NULL::character varying,
    subscription_period character varying(20) DEFAULT NULL::character varying,
    reminder_id1 bigint,
    reminder_id2 bigint,
    price_including_tax numeric(10,2) NOT NULL,
    price_excluding_tax numeric(10,2) NOT NULL,
    created_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    updated_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    muted boolean NOT NULL,
    renew_price_including_tax numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    ccbill_id character varying(100) DEFAULT NULL::character varying
);


CREATE TABLE public.transaction_history (
    id bigint NOT NULL,
    order_id bigint,
    affiliate_seller_id bigint,
    seller_id bigint,
    user_id bigint,
    uuid character varying(255) NOT NULL,
    validation_date timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    amount numeric(10,2) NOT NULL,
    balance numeric(10,2) NOT NULL,
    currency character varying(255) NOT NULL,
    deleted_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    created_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    updated_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    user_type character varying(255) NOT NULL,
    amount_charity numeric(10,2) DEFAULT NULL::numeric,
    amount_tax numeric(10,2) DEFAULT NULL::numeric,
    amount_bank numeric(10,2) DEFAULT NULL::numeric,
    amount_euro numeric(10,2) DEFAULT NULL::numeric
);


ALTER TABLE ONLY public.media_diffusion_medias
    ADD CONSTRAINT media_diffusion_medias_pkey PRIMARY KEY (media_diffusion_id, seller_media_id);


ALTER TABLE ONLY public.media_diffusion
    ADD CONSTRAINT media_diffusion_pkey PRIMARY KEY (id);


ALTER TABLE ONLY public.chat_medias
    ADD CONSTRAINT chat_medias_pkey PRIMARY KEY (chat_message_id, media_id);

ALTER TABLE ONLY public.chat_message
    ADD CONSTRAINT chat_message_pkey PRIMARY KEY (id);


ALTER TABLE ONLY public.chat
    ADD CONSTRAINT chat_pkey PRIMARY KEY (id);


ALTER TABLE ONLY public.country
    ADD CONSTRAINT country_pkey PRIMARY KEY (id);


ALTER TABLE ONLY public.seller
    ADD CONSTRAINT seller_pkey PRIMARY KEY (id);


ALTER TABLE ONLY public.currency
    ADD CONSTRAINT currency_pkey PRIMARY KEY (id);


ALTER TABLE ONLY public.user
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


ALTER TABLE ONLY public.media__like
    ADD CONSTRAINT media__like_pkey PRIMARY KEY (id);


ALTER TABLE ONLY public.media__media
    ADD CONSTRAINT media__media_pkey PRIMARY KEY (id);


ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (id);


ALTER TABLE ONLY public.payment_request
    ADD CONSTRAINT payment_request_pkey PRIMARY KEY (id);


ALTER TABLE ONLY public.private_media_medias
    ADD CONSTRAINT private_media_medias_pkey PRIMARY KEY (private_media_id, seller_media_id);


ALTER TABLE ONLY public.private_media
    ADD CONSTRAINT private_media_pkey PRIMARY KEY (id);


ALTER TABLE ONLY public.subscription
    ADD CONSTRAINT subscription_pkey PRIMARY KEY (id);


ALTER TABLE ONLY public.transaction_history
    ADD CONSTRAINT transaction_history_pkey PRIMARY KEY (id);


ALTER TABLE ONLY public.payment_card
    ADD CONSTRAINT payment_card_pkey PRIMARY KEY (id);



CREATE INDEX idx_22de81754c3a3bb ON public.payment_request USING btree (payment_id);


CREATE INDEX idx_4665fdf361220ea6 ON public.private_media USING btree (seller_id);


CREATE INDEX idx_4665fdf389c48f0b ON public.private_media USING btree (user_id);


CREATE INDEX idx_4665fdf38a89ec94 ON public.private_media USING btree (media_diffusion_id);


CREATE INDEX idx_51104ca950ad465b ON public.transaction_history USING btree (affiliate_seller_id);


CREATE INDEX idx_51104ca961220ea6 ON public.transaction_history USING btree (seller_id);


CREATE INDEX idx_51104ca989c48f0b ON public.transaction_history USING btree (user_id);


CREATE INDEX idx_51104ca98d9f6d38 ON public.transaction_history USING btree (order_id);


CREATE INDEX idx_5373c96638248176 ON public.country USING btree (currency_id);


CREATE INDEX idx_5c6dd74ecf60e67c ON public.media__media USING btree (owner);


CREATE INDEX idx_659df2aa65f77839 ON public.chat USING btree ("user");


CREATE INDEX idx_659df2aabc06ea63 ON public.chat USING btree (seller);


CREATE INDEX idx_65f77839f92f3e70 ON public.user USING btree (country_id);


CREATE INDEX idx_750e98a0948b568f ON public.chat_medias USING btree (chat_message_id);


CREATE INDEX idx_750e98a0ea9fdd75 ON public.chat_medias USING btree (media_id);


CREATE INDEX idx_a3c664d3538594ca ON public.subscription USING btree (payment_card_id);


CREATE INDEX idx_a3c664d361220ea6 ON public.subscription USING btree (seller_id);


CREATE INDEX idx_a3c664d389c48f0b ON public.subscription USING btree (user_id);


CREATE INDEX idx_b4eb482a8a89ec94 ON public.media_diffusion_medias USING btree (media_diffusion_id);


CREATE INDEX idx_b4eb482abd79fae9 ON public.media_diffusion_medias USING btree (seller_media_id);


CREATE INDEX idx_bc06ea6326618af6 ON public.seller USING btree (parent_seller_id);


CREATE INDEX idx_bc06ea63f92f3e70 ON public.seller USING btree (country_id);


CREATE INDEX idx_bf36088e38248176 ON public.media_diffusion USING btree (currency_id);


CREATE INDEX idx_bf36088e61220ea6 ON public.media_diffusion USING btree (seller_id);


CREATE INDEX idx_e52ffdee4d0902d8 ON public.orders USING btree (private_media_id);


CREATE INDEX idx_e52ffdee538594ca ON public.orders USING btree (payment_card_id);


CREATE INDEX idx_e52ffdee61220ea6 ON public.orders USING btree (seller_id);


CREATE INDEX idx_e52ffdee89c48f0b ON public.orders USING btree (user_id);


CREATE INDEX idx_e52ffdee9a1887dc ON public.orders USING btree (subscription_id);


CREATE INDEX idx_ee5ff419ea9fdd75 ON public.media__like USING btree (media_id);


CREATE INDEX idx_f8d69d5d4d0902d8 ON public.private_media_medias USING btree (private_media_id);


CREATE INDEX idx_f8d69d5dbd79fae9 ON public.private_media_medias USING btree (seller_media_id);


CREATE INDEX idx_fab3fc161a9a7125 ON public.chat_message USING btree (chat_id);


CREATE INDEX idx_fab3fc164d0902d8 ON public.chat_message USING btree (private_media_id);


CREATE INDEX idx_fab3fc168a89ec94 ON public.chat_message USING btree (media_diffusion_id);


CREATE INDEX idx_37970fa789c48f0b ON public.payment_card USING btree (user_id);


CREATE UNIQUE INDEX uniq_4665fdf3d17f50a6 ON public.private_media USING btree (uuid);


CREATE UNIQUE INDEX uniq_51104ca9d17f50a6 ON public.transaction_history USING btree (uuid);


CREATE UNIQUE INDEX uniq_5c6dd74ed17f50a6 ON public.media__media USING btree (uuid);


CREATE UNIQUE INDEX uniq_65f77839d17f50a6 ON public.user USING btree (uuid);


CREATE UNIQUE INDEX uniq_6d28840d8d9f6d38 ON public.payment USING btree (order_id);


CREATE UNIQUE INDEX uniq_a3c664d3d17f50a6 ON public.subscription USING btree (uuid);


CREATE UNIQUE INDEX uniq_bc06ea63d17f50a6 ON public.seller USING btree (uuid);


CREATE UNIQUE INDEX uniq_e52ffdeed17f50a6 ON public.orders USING btree (uuid);


CREATE UNIQUE INDEX uniq_ee5ff419d17f50a6 ON public.media__like USING btree (uuid);


ALTER TABLE ONLY public.payment_request
    ADD CONSTRAINT fk_22de81754c3a3bb FOREIGN KEY (payment_id) REFERENCES public.payment(id);


ALTER TABLE ONLY public.private_media
    ADD CONSTRAINT fk_4665fdf361220ea6 FOREIGN KEY (seller_id) REFERENCES public.seller(id);


ALTER TABLE ONLY public.private_media
    ADD CONSTRAINT fk_4665fdf389c48f0b FOREIGN KEY (user_id) REFERENCES public.user(id);


ALTER TABLE ONLY public.private_media
    ADD CONSTRAINT fk_4665fdf38a89ec94 FOREIGN KEY (media_diffusion_id) REFERENCES public.media_diffusion(id) ON DELETE SET NULL;



ALTER TABLE ONLY public.transaction_history
    ADD CONSTRAINT fk_51104ca950ad465b FOREIGN KEY (affiliate_seller_id) REFERENCES public.seller(id);


ALTER TABLE ONLY public.transaction_history
    ADD CONSTRAINT fk_51104ca961220ea6 FOREIGN KEY (seller_id) REFERENCES public.seller(id);


ALTER TABLE ONLY public.transaction_history
    ADD CONSTRAINT fk_51104ca989c48f0b FOREIGN KEY (user_id) REFERENCES public.user(id);


ALTER TABLE ONLY public.transaction_history
    ADD CONSTRAINT fk_51104ca98d9f6d38 FOREIGN KEY (order_id) REFERENCES public.orders(id);


ALTER TABLE ONLY public.country
    ADD CONSTRAINT fk_5373c96638248176 FOREIGN KEY (currency_id) REFERENCES public.currency(id);


ALTER TABLE ONLY public.chat
    ADD CONSTRAINT fk_659df2aa65f77839 FOREIGN KEY ("user") REFERENCES public.user(id);


ALTER TABLE ONLY public.chat
    ADD CONSTRAINT fk_659df2aabc06ea63 FOREIGN KEY (seller) REFERENCES public.seller(id);



ALTER TABLE ONLY public.user
    ADD CONSTRAINT fk_65f77839f92f3e70 FOREIGN KEY (country_id) REFERENCES public.country(id);



ALTER TABLE ONLY public.payment
    ADD CONSTRAINT fk_6d28840d8d9f6d38 FOREIGN KEY (order_id) REFERENCES public.orders(id);


ALTER TABLE ONLY public.chat_medias
    ADD CONSTRAINT fk_750e98a0948b568f FOREIGN KEY (chat_message_id) REFERENCES public.chat_message(id) ON DELETE CASCADE;


ALTER TABLE ONLY public.chat_medias
    ADD CONSTRAINT fk_750e98a0ea9fdd75 FOREIGN KEY (media_id) REFERENCES public.media__media(id) ON DELETE CASCADE;


ALTER TABLE ONLY public.subscription
    ADD CONSTRAINT fk_a3c664d3538594ca FOREIGN KEY (payment_card_id) REFERENCES public.payment_card(id);


ALTER TABLE ONLY public.subscription
    ADD CONSTRAINT fk_a3c664d361220ea6 FOREIGN KEY (seller_id) REFERENCES public.seller(id);


ALTER TABLE ONLY public.subscription
    ADD CONSTRAINT fk_a3c664d389c48f0b FOREIGN KEY (user_id) REFERENCES public.user(id);


ALTER TABLE ONLY public.media_diffusion_medias
    ADD CONSTRAINT fk_b4eb482a8a89ec94 FOREIGN KEY (media_diffusion_id) REFERENCES public.media_diffusion(id) ON DELETE CASCADE;


ALTER TABLE ONLY public.media_diffusion_medias
    ADD CONSTRAINT fk_b4eb482abd79fae9 FOREIGN KEY (seller_media_id) REFERENCES public.media__media(id) ON DELETE CASCADE;


ALTER TABLE ONLY public.seller
    ADD CONSTRAINT fk_bc06ea6326618af6 FOREIGN KEY (parent_seller_id) REFERENCES public.seller(id) ON DELETE SET NULL;


ALTER TABLE ONLY public.seller
    ADD CONSTRAINT fk_bc06ea63f92f3e70 FOREIGN KEY (country_id) REFERENCES public.country(id);


ALTER TABLE ONLY public.media_diffusion
    ADD CONSTRAINT fk_bf36088e38248176 FOREIGN KEY (currency_id) REFERENCES public.currency(id);


ALTER TABLE ONLY public.media_diffusion
    ADD CONSTRAINT fk_bf36088e61220ea6 FOREIGN KEY (seller_id) REFERENCES public.seller(id) ON DELETE CASCADE;


ALTER TABLE ONLY public.orders
    ADD CONSTRAINT fk_e52ffdee4d0902d8 FOREIGN KEY (private_media_id) REFERENCES public.private_media(id);


ALTER TABLE ONLY public.orders
    ADD CONSTRAINT fk_e52ffdee538594ca FOREIGN KEY (payment_card_id) REFERENCES public.payment_card(id);


ALTER TABLE ONLY public.orders
    ADD CONSTRAINT fk_e52ffdee61220ea6 FOREIGN KEY (seller_id) REFERENCES public.seller(id);


ALTER TABLE ONLY public.orders
    ADD CONSTRAINT fk_e52ffdee89c48f0b FOREIGN KEY (user_id) REFERENCES public.user(id);


ALTER TABLE ONLY public.orders
    ADD CONSTRAINT fk_e52ffdee9a1887dc FOREIGN KEY (subscription_id) REFERENCES public.subscription(id);


ALTER TABLE ONLY public.media__like
    ADD CONSTRAINT fk_ee5ff419ea9fdd75 FOREIGN KEY (media_id) REFERENCES public.media__media(id);


ALTER TABLE ONLY public.private_media_medias
    ADD CONSTRAINT fk_f8d69d5d4d0902d8 FOREIGN KEY (private_media_id) REFERENCES public.private_media(id) ON DELETE CASCADE;


ALTER TABLE ONLY public.private_media_medias
    ADD CONSTRAINT fk_f8d69d5dbd79fae9 FOREIGN KEY (seller_media_id) REFERENCES public.media__media(id) ON DELETE CASCADE;


ALTER TABLE ONLY public.chat_message
    ADD CONSTRAINT fk_fab3fc161a9a7125 FOREIGN KEY (chat_id) REFERENCES public.chat(id);


ALTER TABLE ONLY public.chat_message
    ADD CONSTRAINT fk_fab3fc164d0902d8 FOREIGN KEY (private_media_id) REFERENCES public.private_media(id) ON DELETE SET NULL;


ALTER TABLE ONLY public.chat_message
    ADD CONSTRAINT fk_fab3fc168a89ec94 FOREIGN KEY (media_diffusion_id) REFERENCES public.media_diffusion(id) ON DELETE SET NULL;
    
ALTER TABLE ONLY public.payment_card
    ADD CONSTRAINT fk_37970fa789c48f0b FOREIGN KEY (user_id) REFERENCES public.user(id);