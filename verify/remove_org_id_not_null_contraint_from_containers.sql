-- Verify remove_org_id_not_null_contraint_from_containers

BEGIN;

SELECT 1/COUNT(is_nullable) FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'containers' AND column_name = 'org_id' AND is_nullable = 'YES';

ROLLBACK;
