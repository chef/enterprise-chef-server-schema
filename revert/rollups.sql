-- Revert rollups table

BEGIN;

DROP TABLE IF EXISTS rollups;

COMMIT;
