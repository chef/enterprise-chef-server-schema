-- revert remove_org_id_not_null_contraint_from_containers.sql

BEGIN;

ALTER TABLE containers ALTER org_id MODIFY NOT NULL;

COMMIT;
