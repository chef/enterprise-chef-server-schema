CREATE OR REPLACE FUNCTION test_reporting_schema_info_table()
RETURNS SETOF TEXT
LANGUAGE plpgsql
AS $$
BEGIN

  RETURN QUERY SELECT has_table('reporting_schema_info');

  -- Columns

  RETURN QUERY SELECT has_column('reporting_schema_info', 'version');
  RETURN QUERY SELECT col_not_null('reporting_schema_info', 'version');
  RETURN QUERY SELECT col_type_is('reporting_schema_info', 'version', 'integer');
  RETURN QUERY SELECT col_has_default('reporting_schema_info', 'version');
  RETURN QUERY SELECT col_default_is('reporting_schema_info', 'version', 0);

  -- Keys

  -- TODO: needs a PK!
  RETURN QUERY SELECT hasnt_pk('reporting_schema_info');
  RETURN QUERY SELECT hasnt_fk('reporting_schema_info');

END;
$$;
