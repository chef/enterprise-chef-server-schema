# The version of the open source schema that this version of the
# enterprise schema depends on.  Change this as new versions become
# available.
OSC_SCHEMA_VERSION=1.0.4

# The name of the database that will be created to run pgTAP tests
# against.
TEST_DB = opscode_chef_test

# Expression that captures all the SQL files that define test
# functions
TEST_FUNCTIONS = $(wildcard t/test_*.sql)

all : setup_schema setup_tests test

clean:
	rm -Rf deps

# Installs dependencies locally; does not run migrations
install: deps/chef-server-schema

deps:
	mkdir deps

deps/chef-server-schema: deps
	# This can be an https URL when we open the open-source schema up
	cd deps; git clone git@github.com:opscode/chef-server-schema.git; cd chef-server-schema; git checkout $(OSC_SCHEMA_VERSION)

# Load up all schema changesets
setup_schema: install
	$(MAKE) -C deps/chef-server-schema setup_schema
	@echo "Deploying Enterprise Chef Server Schema on top..."
	@sqitch --engine pg --db-name $(TEST_DB) deploy

# Load up all testing functions.  pgTAP libraries and open source
# schema test functions are loaded by the open source makefile target
setup_tests: install
	$(MAKE) -C deps/chef-server-schema setup_tests
	psql --dbname $(TEST_DB) \
	     --single-transaction \
	     --set ON_ERROR_STOP=1 \
	     --file t/monkey_patches.sql
	$(foreach file, $(TEST_FUNCTIONS), psql --dbname $(TEST_DB) --single-transaction --set ON_ERROR_STOP=1 --file $(file);)

test:
	@echo "Executing pgTAP tests in database '$(TEST_DB)'"
	@pg_prove --dbname $(TEST_DB) \
		  --verbose \
		  t/enterprise_chef_server_schema.pg

.PHONY: all clean install setup_schema setup_tests test
