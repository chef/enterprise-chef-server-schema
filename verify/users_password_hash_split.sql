-- Verify new columns added to users

SELECT hashed_password, salt, hash_type FROM users WHERE FALSE;

ROLLBACK;
