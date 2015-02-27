-- Verify policies-revision-id

BEGIN;

SELECT revision_id
FROM policies
WHERE FALSE;

ROLLBACK;
