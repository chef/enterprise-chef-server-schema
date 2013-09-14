-- Note that this replaces the 'test_users_table' function from the
-- Open Source schema tests, making it appropriate for Enterprise
-- Chef.

CREATE OR REPLACE FUNCTION test_users_table()
RETURNS SETOF TEXT
LANGUAGE plpgsql
AS $$
BEGIN

  RETURN QUERY SELECT has_table('users');

  -- Columns

  RETURN QUERY SELECT chef_pgtap.col_is_uuid('users', 'id');
  RETURN QUERY SELECT col_is_pk('users', 'id');

  RETURN QUERY SELECT chef_pgtap.col_is_uuid('users', 'authz_id', TRUE);

  RETURN QUERY SELECT chef_pgtap.col_is_name('users', 'username');
  RETURN QUERY SELECT col_is_unique('users', 'username');

  RETURN QUERY SELECT has_column('users', 'email');
  RETURN QUERY SELECT col_is_null('users', 'email');
  RETURN QUERY SELECT col_is_unique('users', 'email');
  RETURN QUERY SELECT col_type_is('users', 'email', 'text');
  RETURN QUERY SELECT col_hasnt_default('users', 'email');

  RETURN QUERY SELECT has_column('users', 'pubkey_version');
  RETURN QUERY SELECT col_not_null('users', 'pubkey_version');
  RETURN QUERY SELECT col_type_is('users', 'pubkey_version', 'integer'); -- TODO: different from clients; extract this test into something common
  RETURN QUERY SELECT col_hasnt_default('users', 'pubkey_version');

  RETURN QUERY SELECT has_column('users', 'public_key');
  RETURN QUERY SELECT col_is_null('users', 'public_key');
  RETURN QUERY SELECT col_type_is('users', 'public_key', 'text');
  RETURN QUERY SELECT col_hasnt_default('users', 'public_key');

  RETURN QUERY SELECT chef_pgtap.col_is_uuid('users', 'last_updated_by');

  RETURN QUERY SELECT chef_pgtap.col_is_timestamp('users', 'created_at');
  RETURN QUERY SELECT chef_pgtap.col_is_timestamp('users', 'updated_at');

  RETURN QUERY SELECT has_column('users', 'external_authentication_uid');
  RETURN QUERY SELECT col_is_null('users', 'external_authentication_uid');
  RETURN QUERY SELECT col_type_is('users', 'external_authentication_uid', 'text');
  RETURN QUERY SELECT col_hasnt_default('users', 'external_authentication_uid');

  RETURN QUERY SELECT has_column('users', 'recovery_authentication_enabled');
  RETURN QUERY SELECT col_is_null('users', 'recovery_authentication_enabled'); -- TODO: this should be NOT NULL, with a default
  RETURN QUERY SELECT col_type_is('users', 'recovery_authentication_enabled', 'boolean');
  RETURN QUERY SELECT col_hasnt_default('users', 'recovery_authentication_enabled'); -- TODO: default = false

  RETURN QUERY SELECT chef_pgtap.col_is_flag('users', 'admin', FALSE);

  -- Indexes

  RETURN QUERY SELECT chef_pgtap.has_index('users', 'users_authz_id_key', 'authz_id');
  RETURN QUERY SELECT chef_pgtap.has_index('users', 'users_username_key', 'username');
  RETURN QUERY SELECT chef_pgtap.has_index('users', 'users_email_key', 'email');

  -- Keys

  RETURN QUERY SELECT has_pk('users');
  RETURN QUERY SELECT hasnt_fk('users');

END;
$$;
