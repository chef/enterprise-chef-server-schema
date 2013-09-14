Enterprise Chef Server PostgreSQL Schema
========================================

This repository defines additions to the
[Open Source Chef Server schema][] that will create an Enterprise Chef
database schema.

All instructions for the open source Chef Server schema apply for
this repository as well; perform all the setup as instructed there.

Additionally, you will need to have a checkout of the open source
schema repository as a sibling of this repository.  The schema and
tests of this repository build off the same from there.

[Open Source Chef Server schema]:http://github.com/opscode/chef-server-schema

# "Monkey Patching" Test Code

Since we make use of the same test code as the open source schema, but
may have to modify those tests to work with Enterprise schema changes,
we can make use of PostgreSQL's `CREATE OR REPLACE FUNCTION` syntax to
effectively "monkey patch" the test code as appropriate.

See [t/monkey_patches.sql](t/monkey_patches.sql) and
[t/test_users_table.sql](t/test_users_table.sql) for examples of this
in practice.

This is actually the motivation for using testing functions instead of
`psql` scripts in these schema tests.

# Running the Tests

As with the open source schema, all that is required to test is:

```
make
```

(Recipient of the Seth Falcon Seal of Approval :+1:)

The targets of the [Makefile](Makefile) actually call out to
corresponding targets in the
[Open Source Makefile](https://github.com/opscode/chef-server-schema/blob/master/Makefile);
this is why you must currently have a checkout of that code in a
sibling directory.
