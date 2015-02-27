-- Deploy policies-revision-id
-- requires: policies

BEGIN;

-- We have to nuke everything in order to be able to enforce NOT NULL on
-- revision_id
DELETE FROM policies;

ALTER TABLE policies ADD COLUMN revision_id VARCHAR(255) NOT NULL;
ALTER TABLE policies ADD CONSTRAINT unique_name_and_revision_id UNIQUE(org_id, name, revision_id);

COMMIT;
