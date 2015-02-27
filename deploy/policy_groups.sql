-- Deploy policy_groups

BEGIN;

-- Based on release timing, this should be applied at the same time as
-- `policies-revision-id`, which drops all rows from the policies table. Just
-- to be extra extra certain, we do that again here. The alternative would be a
-- data migration to create policy_groups rows for each unique policy_group in
-- the policies table.
DELETE FROM policies;

ALTER TABLE policies DROP CONSTRAINT policies_name_group_org_id_key;
ALTER TABLE policies DROP COLUMN policy_group CASCADE;

CREATE TABLE IF NOT EXISTS policy_groups(
  id VARCHAR(32) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  authz_id CHAR(32) NOT NULL UNIQUE,
  org_id CHAR(32) NOT NULL,
  last_updated_by CHAR(32) NOT NULL,
  serialized_object bytea,
  CONSTRAINT policy_groups_name_org_id_key UNIQUE(name, org_id),
  CONSTRAINT policies_org_id_fkey
    FOREIGN KEY (org_id)
    REFERENCES orgs(id)
    ON DELETE CASCADE
);

COMMIT;
