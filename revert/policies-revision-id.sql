-- Revert policies-revision-id

BEGIN;

ALTER TABLE policies DROP CONSTRAINT unique_name_and_revision_id;
ALTER TABLE policies DROP COLUMN revision_id CASCADE;

COMMIT;