DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM pg_namespace WHERE nspname = 'ticketing') THEN
        CREATE SCHEMA ticketing;
    END IF;
END $EF$;
CREATE TABLE IF NOT EXISTS ticketing."__EFMigrationsHistory" (
    migration_id character varying(150) NOT NULL,
    product_version character varying(32) NOT NULL,
    CONSTRAINT pk___ef_migrations_history PRIMARY KEY (migration_id)
);

START TRANSACTION;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM pg_namespace WHERE nspname = 'ticketing') THEN
        CREATE SCHEMA ticketing;
    END IF;
END $EF$;

CREATE TABLE ticketing.customers (
    id uuid NOT NULL,
    email character varying(300) NOT NULL,
    first_name character varying(200) NOT NULL,
    last_name character varying(200) NOT NULL,
    CONSTRAINT pk_customers PRIMARY KEY (id)
);

CREATE TABLE ticketing.events (
    id uuid NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    location text NOT NULL,
    starts_at_utc timestamp with time zone NOT NULL,
    ends_at_utc timestamp with time zone,
    canceled boolean NOT NULL,
    CONSTRAINT pk_events PRIMARY KEY (id)
);

CREATE TABLE ticketing.inbox_message_consumers (
    inbox_message_id uuid NOT NULL,
    name character varying(500) NOT NULL,
    CONSTRAINT pk_inbox_message_consumers PRIMARY KEY (inbox_message_id, name)
);

CREATE TABLE ticketing.inbox_messages (
    id uuid NOT NULL,
    type text NOT NULL,
    content character varying(2000) NOT NULL,
    occurred_on_utc timestamp with time zone NOT NULL,
    processed_on_utc timestamp with time zone,
    error text,
    CONSTRAINT pk_inbox_messages PRIMARY KEY (id)
);

CREATE TABLE ticketing.outbox_message_consumers (
    outbox_message_id uuid NOT NULL,
    name character varying(500) NOT NULL,
    CONSTRAINT pk_outbox_message_consumers PRIMARY KEY (outbox_message_id, name)
);

CREATE TABLE ticketing.outbox_messages (
    id uuid NOT NULL,
    type text NOT NULL,
    content character varying(2000) NOT NULL,
    occurred_on_utc timestamp with time zone NOT NULL,
    processed_on_utc timestamp with time zone,
    error text,
    CONSTRAINT pk_outbox_messages PRIMARY KEY (id)
);

CREATE TABLE ticketing.orders (
    id uuid NOT NULL,
    customer_id uuid NOT NULL,
    status integer NOT NULL,
    total_price numeric NOT NULL,
    currency text NOT NULL,
    tickets_issued boolean NOT NULL,
    created_at_utc timestamp with time zone NOT NULL,
    CONSTRAINT pk_orders PRIMARY KEY (id),
    CONSTRAINT fk_orders_customers_customer_id FOREIGN KEY (customer_id) REFERENCES ticketing.customers (id) ON DELETE CASCADE
);

CREATE TABLE ticketing.ticket_types (
    id uuid NOT NULL,
    event_id uuid NOT NULL,
    name text NOT NULL,
    price numeric NOT NULL,
    currency text NOT NULL,
    quantity numeric NOT NULL,
    available_quantity numeric NOT NULL,
    CONSTRAINT pk_ticket_types PRIMARY KEY (id),
    CONSTRAINT fk_ticket_types_events_event_id FOREIGN KEY (event_id) REFERENCES ticketing.events (id) ON DELETE CASCADE
);

CREATE TABLE ticketing.payments (
    id uuid NOT NULL,
    order_id uuid NOT NULL,
    transaction_id uuid NOT NULL,
    amount numeric NOT NULL,
    currency text NOT NULL,
    amount_refunded numeric,
    created_at_utc timestamp with time zone NOT NULL,
    refunded_at_utc timestamp with time zone,
    CONSTRAINT pk_payments PRIMARY KEY (id),
    CONSTRAINT fk_payments_orders_order_id FOREIGN KEY (order_id) REFERENCES ticketing.orders (id) ON DELETE CASCADE
);

CREATE TABLE ticketing.order_items (
    id uuid NOT NULL,
    order_id uuid NOT NULL,
    ticket_type_id uuid NOT NULL,
    quantity numeric NOT NULL,
    unit_price numeric NOT NULL,
    price numeric NOT NULL,
    currency text NOT NULL,
    CONSTRAINT pk_order_items PRIMARY KEY (id),
    CONSTRAINT fk_order_items_orders_order_id FOREIGN KEY (order_id) REFERENCES ticketing.orders (id) ON DELETE CASCADE,
    CONSTRAINT fk_order_items_ticket_types_ticket_type_id FOREIGN KEY (ticket_type_id) REFERENCES ticketing.ticket_types (id) ON DELETE CASCADE
);

CREATE TABLE ticketing.tickets (
    id uuid NOT NULL,
    customer_id uuid NOT NULL,
    order_id uuid NOT NULL,
    event_id uuid NOT NULL,
    ticket_type_id uuid NOT NULL,
    code character varying(30) NOT NULL,
    created_at_utc timestamp with time zone NOT NULL,
    archived boolean NOT NULL,
    CONSTRAINT pk_tickets PRIMARY KEY (id),
    CONSTRAINT fk_tickets_customers_customer_id FOREIGN KEY (customer_id) REFERENCES ticketing.customers (id) ON DELETE CASCADE,
    CONSTRAINT fk_tickets_events_event_id FOREIGN KEY (event_id) REFERENCES ticketing.events (id) ON DELETE CASCADE,
    CONSTRAINT fk_tickets_orders_order_id FOREIGN KEY (order_id) REFERENCES ticketing.orders (id) ON DELETE CASCADE,
    CONSTRAINT fk_tickets_ticket_types_ticket_type_id FOREIGN KEY (ticket_type_id) REFERENCES ticketing.ticket_types (id) ON DELETE CASCADE
);

CREATE INDEX ix_order_items_order_id ON ticketing.order_items (order_id);

CREATE INDEX ix_order_items_ticket_type_id ON ticketing.order_items (ticket_type_id);

CREATE INDEX ix_orders_customer_id ON ticketing.orders (customer_id);

CREATE INDEX ix_payments_order_id ON ticketing.payments (order_id);

CREATE UNIQUE INDEX ix_payments_transaction_id ON ticketing.payments (transaction_id);

CREATE INDEX ix_ticket_types_event_id ON ticketing.ticket_types (event_id);

CREATE UNIQUE INDEX ix_tickets_code ON ticketing.tickets (code);

CREATE INDEX ix_tickets_customer_id ON ticketing.tickets (customer_id);

CREATE INDEX ix_tickets_event_id ON ticketing.tickets (event_id);

CREATE INDEX ix_tickets_order_id ON ticketing.tickets (order_id);

CREATE INDEX ix_tickets_ticket_type_id ON ticketing.tickets (ticket_type_id);

INSERT INTO ticketing."__EFMigrationsHistory" (migration_id, product_version)
VALUES ('20240404211044_Create_Database', '8.0.4');

COMMIT;

