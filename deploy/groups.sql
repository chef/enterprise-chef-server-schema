-- Deploy groups

BEGIN;

CREATE TABLE IF NOT EXISTS groups(
  id CHAR(36) PRIMARY KEY,

-- We may wish to allow 'null' org_ids in the future to represent
-- global groups (organizations and users). Otherwise we should
-- reserve a GUID or GUID range to represent global groups. (One
-- possibility would be to examine the UUID generation process,
-- and insure that a certain UUID could never be generated
-- normally) Or we could try to insure we never collide at id
-- creation time, but adding a check for an extraordinarly rare
-- chance of collision seems silly. Or we could just create a
-- dummy org GLOBALS with a name that we disallow for users and use that.

  org_id CHAR(32) NOT NULL,
  authz_id CHAR(32) NOT NULL UNIQUE,
  name TEXT NOT NULL,
  CONSTRAINT groups_org_id_name_unique UNIQUE(org_id, name),
  last_updated_by CHAR(32) NOT NULL,
  created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

COMMIT;
