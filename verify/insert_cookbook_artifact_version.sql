-- Verify insert_cookbook_artifact_version

BEGIN;

SELECT has_function_privilege(
  'insert_cookbook_artifact_version(varchar(255),
                                    bytea,
                                    bytea,
                                    char(32),
                                    char(32),
                                    text,
                                    char(32),
                                    char(32)[])',
  'execute');

ROLLBACK;
