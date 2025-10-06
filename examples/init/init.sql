-- IaC Learning Template - PostgreSQL Initialization
-- Educational example of database setup with best practices

-- === Create Application Database ===
-- Note: POSTGRES_DB env var already creates the database
-- This script runs after database creation

-- === Create Application Schema ===
CREATE SCHEMA IF NOT EXISTS app;

-- === Create Example Tables ===

-- Users table
CREATE TABLE IF NOT EXISTS app.users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Sessions table (for Redis cache backup)
CREATE TABLE IF NOT EXISTS app.sessions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES app.users(id) ON DELETE CASCADE,
    session_token VARCHAR(255) UNIQUE NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Application logs table
CREATE TABLE IF NOT EXISTS app.logs (
    id SERIAL PRIMARY KEY,
    level VARCHAR(50) NOT NULL,
    message TEXT NOT NULL,
    metadata JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- === Create Indexes ===
CREATE INDEX IF NOT EXISTS idx_users_email ON app.users(email);
CREATE INDEX IF NOT EXISTS idx_users_username ON app.users(username);
CREATE INDEX IF NOT EXISTS idx_sessions_token ON app.sessions(session_token);
CREATE INDEX IF NOT EXISTS idx_sessions_user ON app.sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_logs_created ON app.logs(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_logs_level ON app.logs(level);

-- === Create Example Data ===
INSERT INTO app.users (username, email) VALUES
    ('admin', 'admin@example.com'),
    ('demo', 'demo@example.com'),
    ('test', 'test@example.com')
ON CONFLICT (username) DO NOTHING;

-- === Create Functions ===

-- Update timestamp trigger function
CREATE OR REPLACE FUNCTION app.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger for users table
DROP TRIGGER IF EXISTS update_users_updated_at ON app.users;
CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON app.users
    FOR EACH ROW
    EXECUTE FUNCTION app.update_updated_at_column();

-- === Grant Permissions ===
-- Note: The user is already created via POSTGRES_USER env var

GRANT USAGE ON SCHEMA app TO ${POSTGRES_USER};
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA app TO ${POSTGRES_USER};
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA app TO ${POSTGRES_USER};
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA app TO ${POSTGRES_USER};

-- === Success Message ===
DO $$
BEGIN
    RAISE NOTICE '✅ Database initialization complete!';
    RAISE NOTICE '📊 Schema: app';
    RAISE NOTICE '📋 Tables: users, sessions, logs';
    RAISE NOTICE '👤 User: ${POSTGRES_USER}';
END $$;
