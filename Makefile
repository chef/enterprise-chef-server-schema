TEST_DB = opscode_chef_test

all : setup_schema setup_tests test

TEST_FUNCTIONS = $(wildcard t/test_*.sql)

setup_schema:
	cd ../chef-server-schema && make setup_schema
	@echo "Deploying Enterprise Chef Server Schema on top..."
	@sqitch --engine pg --db-name $(TEST_DB) deploy

setup_tests:
	cd ../chef-server-schema && make setup_tests
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
