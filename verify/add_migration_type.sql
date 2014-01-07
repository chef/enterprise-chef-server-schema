-- Verify add_migration_type

BEGIN;

SELECT hashed_password, salt, hash_type FROM users WHERE FALSE;

ROLLBACK;
