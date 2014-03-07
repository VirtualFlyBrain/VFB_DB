#!/bin/bash
echo "Fetching flybase DB from ftp://ftp.flybase.net/releases/current/psql/"
cd /current/
rm *.gz.*
wget ftp://ftp.flybase.net/releases/current/psql/*.gz.*
createdb -E UTF-8 -h localhost -U nmilyav1 flybase_new
cat *.gz* | gunzip | psql -h localhost -U nmilyav1 flybase_new
vacuumdb -f -z -v flybase_new -U nmilyav1 -h localhost
psql -h localhost -U nmilyav1 nmilyav1 -c "ALTER DATABASE 'flybase' RENAME TO flybase_old"
psql -h localhost -U nmilyav1 nmilyav1 -c "ALTER DATABASE 'flybase_new' RENAME TO flybase"
psql -h localhost -U flybase flybase < /disk/data/VFB/Chado/scripts/chado_views_for_vfb.sql
