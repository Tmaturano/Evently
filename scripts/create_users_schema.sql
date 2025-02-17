DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM pg_namespace WHERE nspname = 'users') THEN
        CREATE SCHEMA users;
    END IF;
END $EF$;
CREATE TABLE IF NOT EXISTS users."__EFMigrationsHistory" (
    migration_id character varying(150) NOT NULL,
    product_version character varying(32) NOT NULL,
    CONSTRAINT pk___ef_migrations_history PRIMARY KEY (migration_id)
);

START TRANSACTION;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM pg_namespace WHERE nspname = 'users') THEN
        CREATE SCHEMA users;
    END IF;
END $EF$;

CREATE TABLE users.inbox_message_consumers (
    inbox_message_id uuid NOT NULL,
    name character varying(500) NOT NULL,
    CONSTRAINT pk_inbox_message_consumers PRIMARY KEY (inbox_message_id, name)
);

CREATE TABLE users.inbox_messages (
    id uuid NOT NULL,
    type text NOT NULL,
    content character varying(2000) NOT NULL,
    occurred_on_utc timestamp with time zone NOT NULL,
    processed_on_utc timestamp with time zone,
    error text,
    CONSTRAINT pk_inbox_messages PRIMARY KEY (id)
);

CREATE TABLE users.outbox_message_consumers (
    outbox_message_id uuid NOT NULL,
    name character varying(500) NOT NULL,
    CONSTRAINT pk_outbox_message_consumers PRIMARY KEY (outbox_message_id, name)
);

CREATE TABLE users.outbox_messages (
    id uuid NOT NULL,
    type text NOT NULL,
    content character varying(2000) NOT NULL,
    occurred_on_utc timestamp with time zone NOT NULL,
    processed_on_utc timestamp with time zone,
    error text,
    CONSTRAINT pk_outbox_messages PRIMARY KEY (id)
);

CREATE TABLE users.permissions (
    code character varying(100) NOT NULL,
    CONSTRAINT pk_permissions PRIMARY KEY (code)
);

CREATE TABLE users.roles (
    name character varying(50) NOT NULL,
    CONSTRAINT pk_roles PRIMARY KEY (name)
);

CREATE TABLE users.users (
    id uuid NOT NULL,
    email character varying(300) NOT NULL,
    first_name character varying(200) NOT NULL,
    last_name character varying(200) NOT NULL,
    identity_id text NOT NULL,
    CONSTRAINT pk_users PRIMARY KEY (id)
);

CREATE TABLE users.role_permissions (
    permission_code character varying(100) NOT NULL,
    role_name character varying(50) NOT NULL,
    CONSTRAINT pk_role_permissions PRIMARY KEY (permission_code, role_name),
    CONSTRAINT fk_role_permissions_permissions_permission_code FOREIGN KEY (permission_code) REFERENCES users.permissions (code) ON DELETE CASCADE,
    CONSTRAINT fk_role_permissions_roles_role_name FOREIGN KEY (role_name) REFERENCES users.roles (name) ON DELETE CASCADE
);

CREATE TABLE users.user_roles (
    role_name character varying(50) NOT NULL,
    user_id uuid NOT NULL,
    CONSTRAINT pk_user_roles PRIMARY KEY (role_name, user_id),
    CONSTRAINT fk_user_roles_roles_roles_name FOREIGN KEY (role_name) REFERENCES users.roles (name) ON DELETE CASCADE,
    CONSTRAINT fk_user_roles_users_user_id FOREIGN KEY (user_id) REFERENCES users.users (id) ON DELETE CASCADE
);

INSERT INTO users.permissions (code)
VALUES ('carts:add');
INSERT INTO users.permissions (code)
VALUES ('carts:read');
INSERT INTO users.permissions (code)
VALUES ('carts:remove');
INSERT INTO users.permissions (code)
VALUES ('categories:read');
INSERT INTO users.permissions (code)
VALUES ('categories:update');
INSERT INTO users.permissions (code)
VALUES ('event-statistics:read');
INSERT INTO users.permissions (code)
VALUES ('events:read');
INSERT INTO users.permissions (code)
VALUES ('events:search');
INSERT INTO users.permissions (code)
VALUES ('events:update');
INSERT INTO users.permissions (code)
VALUES ('orders:create');
INSERT INTO users.permissions (code)
VALUES ('orders:read');
INSERT INTO users.permissions (code)
VALUES ('ticket-types:read');
INSERT INTO users.permissions (code)
VALUES ('ticket-types:update');
INSERT INTO users.permissions (code)
VALUES ('tickets:check-in');
INSERT INTO users.permissions (code)
VALUES ('tickets:read');
INSERT INTO users.permissions (code)
VALUES ('users:read');
INSERT INTO users.permissions (code)
VALUES ('users:update');

INSERT INTO users.roles (name)
VALUES ('Administrator');
INSERT INTO users.roles (name)
VALUES ('Member');

INSERT INTO users.role_permissions (permission_code, role_name)
VALUES ('carts:add', 'Administrator');
INSERT INTO users.role_permissions (permission_code, role_name)
VALUES ('carts:add', 'Member');
INSERT INTO users.role_permissions (permission_code, role_name)
VALUES ('carts:read', 'Administrator');
INSERT INTO users.role_permissions (permission_code, role_name)
VALUES ('carts:read', 'Member');
INSERT INTO users.role_permissions (permission_code, role_name)
VALUES ('carts:remove', 'Administrator');
INSERT INTO users.role_permissions (permission_code, role_name)
VALUES ('carts:remove', 'Member');
INSERT INTO users.role_permissions (permission_code, role_name)
VALUES ('categories:read', 'Administrator');
INSERT INTO users.role_permissions (permission_code, role_name)
VALUES ('categories:update', 'Administrator');
INSERT INTO users.role_permissions (permission_code, role_name)
VALUES ('event-statistics:read', 'Administrator');
INSERT INTO users.role_permissions (permission_code, role_name)
VALUES ('events:read', 'Administrator');
INSERT INTO users.role_permissions (permission_code, role_name)
VALUES ('events:search', 'Administrator');
INSERT INTO users.role_permissions (permission_code, role_name)
VALUES ('events:search', 'Member');
INSERT INTO users.role_permissions (permission_code, role_name)
VALUES ('events:update', 'Administrator');
INSERT INTO users.role_permissions (permission_code, role_name)
VALUES ('orders:create', 'Administrator');
INSERT INTO users.role_permissions (permission_code, role_name)
VALUES ('orders:create', 'Member');
INSERT INTO users.role_permissions (permission_code, role_name)
VALUES ('orders:read', 'Administrator');
INSERT INTO users.role_permissions (permission_code, role_name)
VALUES ('orders:read', 'Member');
INSERT INTO users.role_permissions (permission_code, role_name)
VALUES ('ticket-types:read', 'Administrator');
INSERT INTO users.role_permissions (permission_code, role_name)
VALUES ('ticket-types:read', 'Member');
INSERT INTO users.role_permissions (permission_code, role_name)
VALUES ('ticket-types:update', 'Administrator');
INSERT INTO users.role_permissions (permission_code, role_name)
VALUES ('tickets:check-in', 'Administrator');
INSERT INTO users.role_permissions (permission_code, role_name)
VALUES ('tickets:check-in', 'Member');
INSERT INTO users.role_permissions (permission_code, role_name)
VALUES ('tickets:read', 'Administrator');
INSERT INTO users.role_permissions (permission_code, role_name)
VALUES ('tickets:read', 'Member');
INSERT INTO users.role_permissions (permission_code, role_name)
VALUES ('users:read', 'Administrator');
INSERT INTO users.role_permissions (permission_code, role_name)
VALUES ('users:read', 'Member');
INSERT INTO users.role_permissions (permission_code, role_name)
VALUES ('users:update', 'Administrator');
INSERT INTO users.role_permissions (permission_code, role_name)
VALUES ('users:update', 'Member');

CREATE INDEX ix_role_permissions_role_name ON users.role_permissions (role_name);

CREATE INDEX ix_user_roles_user_id ON users.user_roles (user_id);

CREATE UNIQUE INDEX ix_users_email ON users.users (email);

CREATE UNIQUE INDEX ix_users_identity_id ON users.users (identity_id);

INSERT INTO users."__EFMigrationsHistory" (migration_id, product_version)
VALUES ('20240404131817_Create_Database', '8.0.4');

COMMIT;

