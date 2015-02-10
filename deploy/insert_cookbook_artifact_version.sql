-- Deploy insert_cookbook_artifact_version
-- requires: cookbook_artifact_version_checksums
-- requires: checksums

BEGIN;

CREATE OR REPLACE FUNCTION insert_cookbook_artifact_version(
  p_identifier cookbook_artifact_versions.identifier%TYPE,
  p_meta_attributes cookbook_artifact_versions.meta_attributes%TYPE,
  p_meta_long_desc cookbook_artifact_versions.meta_long_desc%TYPE,
  p_metadata cookbook_artifact_versions.metadata%TYPE,
  p_serialized_object cookbook_artifact_versions.serialized_object%TYPE,
  p_updated_at cookbook_artifact_versions.updated_at%TYPE,
  p_created_at cookbook_artifact_versions.created_at%TYPE,
  p_last_updated_by cookbook_artifact_versions.last_updated_by%TYPE,
  p_org_id cookbook_artifacts.org_id%TYPE,
  p_name cookbook_artifacts.name%TYPE,
  p_authz_id cookbook_artifacts.authz_id%TYPE,
  p_checksums char(32)[]
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
  v_cookbook_artifact_id cookbook_artifacts.id%TYPE;
  v_cookbook_artifact_version_id cookbook_artifact_versions.id%TYPE;
  v_checksum char(32);
BEGIN
  -- first let's create the cookbook_artifact record if needed
  SELECT id
  FROM cookbook_artifacts
  WHERE org_id = p_org_id
  AND name = p_name
  -- TODO: and authz_id = ?
  INTO v_cookbook_artifact_id;
  IF NOT FOUND THEN
    INSERT INTO cookbook_artifacts(org_id, name, authz_id)
    VALUES (p_org_id, p_name, p_authz_id)
    RETURNING id
    INTO v_cookbook_artifact_id;
  END IF;

  -- then create the cookbook_artifact_version record
  INSERT INTO cookbook_artifact_versions(identifier,
                                         meta_attributes,
                                         meta_long_desc,
                                         metadata,
                                         serialized_object,
                                         updated_at,
                                         created_at,
                                         last_updated_by,
                                         cookbook_artifact_id)
  VALUES (p_identifier,
          p_meta_attributes,
          p_meta_long_desc,
          p_metadata,
          p_serialized_object,
          p_updated_at,
          p_created_at,
          p_last_updated_by,
          v_cookbook_artifact_id)
  RETURNING id
  INTO v_cookbook_artifact_version_id;

  -- and finally we can proceed to creating the
  -- cookbook_artifact_version_checksum records,
  -- throwing a custom exception if a checksum is missing
  -- to allow for a graceful handling at the client's level
  BEGIN
    FOREACH v_checksum IN ARRAY p_checksums
    LOOP
      INSERT INTO cookbook_artifact_version_checksums(cookbook_artifact_version_id, org_id, checksum)
      VALUES (v_cookbook_artifact_version_id, p_org_id, v_checksum);
    END LOOP;
  EXCEPTION
    WHEN foreign_key_violation THEN
      RAISE EXCEPTION
      USING ERRCODE = 'CS001',
            MESSAGE = 'Missing checksum';
  END;

END;
$$;

COMMIT;
