#!/bin/bash
# Ensure you have created a ~/.pgpass file containing:
# localhost:5432:*:flybase:password
# localhost:5432:*:nmilyav1:password
# Obviously replacing password with the real password.
# Note: This will take hours! 
# Note: You may need to change pgsql revision for pg_dump commands if server is updated or not run on main server.
echo "Fetching flybase DB from ftp://ftp.flybase.net/releases/current/psql/"
cd /current/
rm *.gz.*
wget ftp://ftp.flybase.net/releases/current/psql/*.gz.*
createdb -E UTF-8 -h localhost -U nmilyav1 flybase_new
cat *.gz* | gunzip | psql -h localhost -U nmilyav1 flybase_new
vacuumdb -f -z -v flybase_new -U nmilyav1 -h localhost
psql -h localhost -U nmilyav1 flybase_new -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO flybase"

dropdb -h localhost -U nmilyav1 'flybase_old'

rm ../old/flybase_old.dump
rm ../old/revision
/usr/pgsql-9.3/bin/pg_dump -h localhost -U nmilyav1 flybase > ../old/flybase_old.dump
mv revision ../old/
rm flybase.dump
ls *.gz.00 | rev | cut -c 11- | rev > revision
psql -h localhost -U nmilyav1 flybase -c "SELECT usename, pid FROM pg_stat_activity WHERE datname = current_database();"
psql -h localhost -U nmilyav1 postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname='flybase';"
psql -h localhost -U nmilyav1 postgres -c "ALTER DATABASE flybase RENAME TO flybase_old"
psql -h localhost -U nmilyav1 postgres -c "ALTER DATABASE flybase_new RENAME TO flybase"
vacuumdb -f -z -v flybase -U nmilyav1 -h localhost
psql -h localhost -U flybase flybase < TableQueries/chado_views_for_vfb.sql
