DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM pg_namespace WHERE nspname = 'events') THEN
        CREATE SCHEMA events;
    END IF;
END $EF$;
CREATE TABLE IF NOT EXISTS events."__EFMigrationsHistory" (
    migration_id character varying(150) NOT NULL,
    product_version character varying(32) NOT NULL,
    CONSTRAINT pk___ef_migrations_history PRIMARY KEY (migration_id)
);

START TRANSACTION;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM pg_namespace WHERE nspname = 'events') THEN
        CREATE SCHEMA events;
    END IF;
END $EF$;

CREATE TABLE events.categories (
    id uuid NOT NULL,
    name text NOT NULL,
    is_archived boolean NOT NULL,
    CONSTRAINT pk_categories PRIMARY KEY (id)
);

CREATE TABLE events.inbox_message_consumers (
    inbox_message_id uuid NOT NULL,
    name character varying(500) NOT NULL,
    CONSTRAINT pk_inbox_message_consumers PRIMARY KEY (inbox_message_id, name)
);

CREATE TABLE events.inbox_messages (
    id uuid NOT NULL,
    type text NOT NULL,
    content character varying(2000) NOT NULL,
    occurred_on_utc timestamp with time zone NOT NULL,
    processed_on_utc timestamp with time zone,
    error text,
    CONSTRAINT pk_inbox_messages PRIMARY KEY (id)
);

CREATE TABLE events.outbox_message_consumers (
    outbox_message_id uuid NOT NULL,
    name character varying(500) NOT NULL,
    CONSTRAINT pk_outbox_message_consumers PRIMARY KEY (outbox_message_id, name)
);

CREATE TABLE events.outbox_messages (
    id uuid NOT NULL,
    type text NOT NULL,
    content character varying(2000) NOT NULL,
    occurred_on_utc timestamp with time zone NOT NULL,
    processed_on_utc timestamp with time zone,
    error text,
    CONSTRAINT pk_outbox_messages PRIMARY KEY (id)
);

CREATE TABLE events.events (
    id uuid NOT NULL,
    category_id uuid NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    location text NOT NULL,
    starts_at_utc timestamp with time zone NOT NULL,
    ends_at_utc timestamp with time zone,
    status integer NOT NULL,
    CONSTRAINT pk_events PRIMARY KEY (id),
    CONSTRAINT fk_events_categories_category_id FOREIGN KEY (category_id) REFERENCES events.categories (id) ON DELETE CASCADE
);

CREATE TABLE events.ticket_types (
    id uuid NOT NULL,
    event_id uuid NOT NULL,
    name text NOT NULL,
    price numeric NOT NULL,
    currency text NOT NULL,
    quantity numeric NOT NULL,
    CONSTRAINT pk_ticket_types PRIMARY KEY (id),
    CONSTRAINT fk_ticket_types_events_event_id FOREIGN KEY (event_id) REFERENCES events.events (id) ON DELETE CASCADE
);

CREATE INDEX ix_events_category_id ON events.events (category_id);

CREATE INDEX ix_ticket_types_event_id ON events.ticket_types (event_id);

INSERT INTO events."__EFMigrationsHistory" (migration_id, product_version)
VALUES ('20240402131624_Create_Database', '8.0.4');

COMMIT;

