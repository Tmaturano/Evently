DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM pg_namespace WHERE nspname = 'attendance') THEN
        CREATE SCHEMA attendance;
    END IF;
END $EF$;
CREATE TABLE IF NOT EXISTS attendance."__EFMigrationsHistory" (
    migration_id character varying(150) NOT NULL,
    product_version character varying(32) NOT NULL,
    CONSTRAINT pk___ef_migrations_history PRIMARY KEY (migration_id)
);

START TRANSACTION;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM pg_namespace WHERE nspname = 'attendance') THEN
        CREATE SCHEMA attendance;
    END IF;
END $EF$;

CREATE TABLE attendance.attendees (
    id uuid NOT NULL,
    email character varying(300) NOT NULL,
    first_name character varying(200) NOT NULL,
    last_name character varying(200) NOT NULL,
    CONSTRAINT pk_attendees PRIMARY KEY (id)
);

CREATE TABLE attendance.event_statistics (
    event_id uuid NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    location text NOT NULL,
    starts_at_utc timestamp with time zone NOT NULL,
    ends_at_utc timestamp with time zone,
    tickets_sold integer NOT NULL,
    attendees_checked_in integer NOT NULL,
    duplicate_check_in_tickets text[] NOT NULL,
    invalid_check_in_tickets text[] NOT NULL,
    CONSTRAINT pk_event_statistics PRIMARY KEY (event_id)
);

CREATE TABLE attendance.events (
    id uuid NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    location text NOT NULL,
    starts_at_utc timestamp with time zone NOT NULL,
    ends_at_utc timestamp with time zone,
    CONSTRAINT pk_events PRIMARY KEY (id)
);

CREATE TABLE attendance.inbox_message_consumers (
    inbox_message_id uuid NOT NULL,
    name character varying(500) NOT NULL,
    CONSTRAINT pk_inbox_message_consumers PRIMARY KEY (inbox_message_id, name)
);

CREATE TABLE attendance.inbox_messages (
    id uuid NOT NULL,
    type text NOT NULL,
    content character varying(2000) NOT NULL,
    occurred_on_utc timestamp with time zone NOT NULL,
    processed_on_utc timestamp with time zone,
    error text,
    CONSTRAINT pk_inbox_messages PRIMARY KEY (id)
);

CREATE TABLE attendance.outbox_message_consumers (
    outbox_message_id uuid NOT NULL,
    name character varying(500) NOT NULL,
    CONSTRAINT pk_outbox_message_consumers PRIMARY KEY (outbox_message_id, name)
);

CREATE TABLE attendance.outbox_messages (
    id uuid NOT NULL,
    type text NOT NULL,
    content character varying(2000) NOT NULL,
    occurred_on_utc timestamp with time zone NOT NULL,
    processed_on_utc timestamp with time zone,
    error text,
    CONSTRAINT pk_outbox_messages PRIMARY KEY (id)
);

CREATE TABLE attendance.tickets (
    id uuid NOT NULL,
    attendee_id uuid NOT NULL,
    event_id uuid NOT NULL,
    code character varying(30) NOT NULL,
    used_at_utc timestamp with time zone,
    CONSTRAINT pk_tickets PRIMARY KEY (id),
    CONSTRAINT fk_tickets_attendees_attendee_id FOREIGN KEY (attendee_id) REFERENCES attendance.attendees (id) ON DELETE CASCADE,
    CONSTRAINT fk_tickets_events_event_id FOREIGN KEY (event_id) REFERENCES attendance.events (id) ON DELETE CASCADE
);

CREATE INDEX ix_tickets_attendee_id ON attendance.tickets (attendee_id);

CREATE UNIQUE INDEX ix_tickets_code ON attendance.tickets (code);

CREATE INDEX ix_tickets_event_id ON attendance.tickets (event_id);

INSERT INTO attendance."__EFMigrationsHistory" (migration_id, product_version)
VALUES ('20240404132040_Create_Database', '8.0.4');

COMMIT;

