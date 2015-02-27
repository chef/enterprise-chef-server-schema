

CREATE OR REPLACE FUNCTION test_policies_table()
RETURNS SETOF TEXT
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY SELECT has_table('policies');
  RETURN QUERY SELECT col_type_is('policies', 'name', 'character varying(256)');
  RETURN QUERY SELECT col_type_is('policies', 'policy_group', 'character varying(256)');
  RETURN QUERY SELECT col_type_is('policies', 'org_id', 'character(32)');
  RETURN QUERY SELECT chef_pgtap.col_is_uuid('policies', 'authz_id', TRUE);
  RETURN QUERY SELECT col_is_pk('policies', 'id');
  RETURN QUERY SELECT fk_ok('policies', 'org_id', 'orgs', 'id');
  RETURN QUERY SELECT chef_pgtap.col_is_uuid('policies', 'last_updated_by');
  RETURN QUERY SELECT chef_pgtap.has_index('policies', 'policies_name_group_org_id_key', ARRAY['name', 'policy_group', 'org_id']);

  RETURN QUERY SELECT col_type_is('policies', 'revision_id', 'character varying(255)');
  RETURN QUERY SELECT col_is_unique('policies', ARRAY['org_id', 'name', 'revision_id']);
END;
$$
