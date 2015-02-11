-- Verify cookbook_artifact_versions

BEGIN;

SELECT id, identifier,
       meta_attributes, meta_long_desc,
       metadata, serialized_object, created_at
       last_updated_by, cookbook_artifact_id
FROM cookbook_artifact_versions
WHERE FALSE;

ROLLBACK;
