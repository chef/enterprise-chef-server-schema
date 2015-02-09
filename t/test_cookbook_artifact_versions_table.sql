CREATE OR REPLACE FUNCTION test_cookbook_artifact_versions_table()
RETURNS SETOF TEXT
LANGUAGE plpgsql
AS $$
BEGIN

  RETURN QUERY SELECT has_table('cookbook_artifact_versions');

  -- Columns
  RETURN QUERY SELECT columns_are('cookbook_artifact_versions', ARRAY['id',
                                                                      'identifier',
                                                                      'meta_attributes',
                                                                      'meta_long_desc',
                                                                      'metadata',
                                                                      'serialized_object',
                                                                      'updated_at',
                                                                      'created_at',
                                                                      'last_updated_by',
                                                                      'cookbook_id']);

  RETURN QUERY SELECT chef_pgtap.col_is_uuid('cookbook_artifact_versions', 'id');
  RETURN QUERY SELECT col_is_pk('cookbook_artifact_versions', 'id');

  RETURN QUERY SELECT chef_pgtap.col_is_blob('cookbook_artifact_versions', 'meta_attributes');
  RETURN QUERY SELECT chef_pgtap.col_is_blob('cookbook_artifact_versions', 'metadata');
  RETURN QUERY SELECT chef_pgtap.col_is_blob('cookbook_artifact_versions', 'serialized_object');
  RETURN QUERY SELECT chef_pgtap.col_is_timestamp('cookbook_artifact_versions', 'updated_at');
  RETURN QUERY SELECT chef_pgtap.col_is_timestamp('cookbook_artifact_versions', 'created_at');

  RETURN QUERY SELECT chef_pgtap.col_is_uuid('cookbook_artifact_versions', 'last_updated_by');

  RETURN QUERY SELECT col_not_null('cookbook_artifact_versions', 'cookbook_id');
  RETURN QUERY SELECT col_type_is('cookbook_artifact_versions', 'cookbook_id', 'integer');
  RETURN QUERY SELECT col_hasnt_default('cookbook_artifact_versions', 'cookbook_id');


  -- Indexes
  RETURN QUERY SELECT col_is_unique('cookbook_artifact_versions',
                                     ARRAY['cookbook_id', 'identifier']);

  -- Keys
  RETURN QUERY SELECT has_pk('cookbook_artifact_versions');
  RETURN QUERY SELECT has_fk('cookbook_artifact_versions');

  RETURN QUERY SELECT fk_ok('cookbook_artifact_versions', 'cookbook_id',
                            'cookbooks', 'id');
  RETURN QUERY SELECT chef_pgtap.fk_update_action_is('cookbook_artifact_versions_cookbook_id_fkey', 'NO ACTION');
  RETURN QUERY SELECT chef_pgtap.fk_delete_action_is('cookbook_artifact_versions_cookbook_id_fkey', 'RESTRICT');

END;
$$;