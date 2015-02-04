-- Deploy rollups table

BEGIN;

CREATE TABLE IF NOT EXISTS rollups(
  rollup_id      UUID PRIMARY KEY,
  source_table   TEXT NOT NULL,
  name           TEXT NOT NULL,
  site_id        TEXT NOT NULL,
  item_count     INT NOT NULL,
  client_version TEXT,
  org_id         TEXT,
  server_id      TEXT,
  sender_host    TEXT,
  sender_ip      CHAR(15),
  dt_sampled     TIMESTAMPTZ NOT NULL,
  dt_added       TIMESTAMPTZ NOT NULL
);

COMMIT;
