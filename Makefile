# The version of the open source schema that this version of the
# enterprise schema depends on.  Change this as new versions become
# available.
OSS_SCHEMA_VERSION=1.0.3

# The name of the open source schema directory.  Don't change this;
# it's just here for consolidation purposes.
OSS_SCHEMA_DIR = chef-server-schema

# The name of the database that will be created to run pgTAP tests
# against.
TEST_DB = opscode_chef_test

# Expression that captures all the SQL files that define test
# functions
TEST_FUNCTIONS = $(wildcard t/test_*.sql)

all : setup_schema setup_tests test

# Perform basic sanity checks; is the open source schema available and
# checked out to the expected version?
$(OSS_SCHEMA_DIR):
ifneq ($(shell [ -d ../$(OSS_SCHEMA_DIR) ] && echo 1 || echo 0 ), 1)
	$(error "Missing $(OSS_SCHEMA_DIR) directory as a sibling of this directory!")
endif
ifneq ($(shell git --git-dir=../$(OSS_SCHEMA_DIR)/.git describe --exact-match HEAD), $(OSS_SCHEMA_VERSION))
	$(error "Please checkout tag $(OSS_SCHEMA_VERSION) in ../$(OSS_SCHEMA_DIR) first")
endif

# Load up all schema changesets
setup_schema: $(OSS_SCHEMA_DIR)
	cd ../$(OSS_SCHEMA_DIR) && make setup_schema
	@echo "Deploying Enterprise Chef Server Schema on top..."
	@sqitch --engine pg --db-name $(TEST_DB) deploy

# Load up all testing functions.  pgTAP libraries and open source
# schema test functions are loaded by the open source makefile target
setup_tests: $(OSS_SCHEMA_DIR)
	cd ../$(OSS_SCHEMA_DIR) && make setup_tests
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
