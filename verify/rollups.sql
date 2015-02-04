-- Verify,

BEGIN;

SELECT rollup_id, source_table, name, site_id, item_count, client_version org_id, server_id, sender_host, sender_ip, dt_sampled, dt_added
FROM rollups 
WHERE FALSE;

ROLLBACK;
