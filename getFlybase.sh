#!/bin/bash
# Ensure you have created a ~/.pgpass file containing:
# localhost:5432:flybase:nmilyav1:password
# localhost:5432:vfb:nmilyav1:password
# Obviously replacing password with the real password.
echo "Fetching flybase DB from ftp://ftp.flybase.net/releases/current/psql/"
cd /current/
rm *.gz.*
wget ftp://ftp.flybase.net/releases/current/psql/*.gz.*
createdb -E UTF-8 -h localhost -U nmilyav1 flybase_new
cat *.gz* | gunzip | psql -h localhost -U nmilyav1 flybase_new
vacuumdb -f -z -v flybase_new -U nmilyav1 -h localhost
psql -h localhost -U nmilyav1 flybase_new -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO flybase"
dropdb -h localhost -U nmilyav1 'flybase_old'
psql -h localhost -U nmilyav1 postgres -c "ALTER DATABASE 'flybase' RENAME TO flybase_old"
psql -h localhost -U nmilyav1 postgres -c "ALTER DATABASE 'flybase_new' RENAME TO flybase"
psql -h localhost -U flybase flybase < TableQueries/chado_views_for_vfb.sql
