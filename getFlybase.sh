#!/bin/bash
# Ensure you have created a ~/.pgpass file containing:
# localhost:5432:*:flybase:password
# localhost:5432:*:jenkins:password
# Obviously replacing password with the real password.
# Note: This will take hours!
# Note: You may need to change pgsql revision for pg_dump commands if server is updated or not run on main server.
echo "Fetching flybase DB from ftp://ftp.flybase.net/releases/current/psql/"
cd current
echo `date`
echo `pwd`
#removing 90 day old downloads. Note: file date is date released by FB not date copied.
find . -name "*.gz.*" -mtime +30 | xargs rm
wget -c ftp://ftp.flybase.net/releases/current/psql/*.gz.*

if [ `ls *.gz.00 | rev | cut -c 11- | rev` != `cat revision | cut -c -9` ]
then

  # clean flybase_new: just incase - should fail.

  /usr/pgsql-9.3/bin/psql -h localhost -U jenkins flybase_new -c "SELECT usename, pid FROM pg_stat_activity WHERE datname = current_database();"
  /usr/pgsql-9.3/bin/psql -h localhost -U jenkins postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname='flybase_new';"

  dropdb -h localhost -U jenkins 'flybase_new'
  createdb -E UTF-8 -h localhost -U jenkins flybase_new
  cat *.gz* | unpigz | /usr/pgsql-9.3/bin/psql -h localhost -U jenkins flybase_new 2>&1
  vacuumdb -f -z -v flybase_new -U jenkins -h localhost
  /usr/pgsql-9.3/bin/psql -h localhost -U jenkins flybase_new -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO flybase"

  dropdb -h localhost -U jenkins 'flybase_old'

  rm ../old/flybase_old.dump
  rm ../old/revision
  if [ `tail -n 1 /etc/hosts | rev | cut -c -6 | rev` == 'blanik' ]
  then
    /usr/pgsql-9.2/bin/pg_dump -h localhost -U jenkins flybase > ../old/flybase_old.dump
  else
    /usr/pgsql-9.3/bin/pg_dump -h localhost -U jenkins flybase > ../old/flybase_old.dump
  fi
  echo `date`
  echo 'Stating vacuum...'
  vacuumdb -f -z -v flybase_new -U jenkins -h localhost
  echo 'Finished vacuum.'
  echo `date`
  echo 'Staring creating custom tables (long process with no feedback) ...'
  /usr/pgsql-9.3/bin/psql -h localhost -U jenkins flybase_new < ../TableQueries/chado_views_for_vfb.sql
  echo 'Finished creating views.'
  /usr/pgsql-9.3/bin/psql -h localhost -U jenkins flybase_new -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO flybase"
  echo `date`
  echo 'Stating vacuum...'
  vacuumdb -f -z -v flybase_new -U jenkins -h localhost
  echo 'Finished vacuum.'
  echo `date`
  mv revision ../old/
  echo "FB DB updating..." > revision
  rm flybase.dump

  /usr/pgsql-9.3/bin/psql -h localhost -U jenkins flybase -c "SELECT usename, pid FROM pg_stat_activity WHERE datname = current_database();"
  /usr/pgsql-9.3/bin/psql -h localhost -U jenkins postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname='flybase';"

  /usr/pgsql-9.3/bin/psql -h localhost -U jenkins postgres -c "ALTER DATABASE flybase RENAME TO flybase_old"
  /usr/pgsql-9.3/bin/psql -h localhost -U jenkins postgres -c "ALTER DATABASE flybase_new RENAME TO flybase"
  echo 'DB swapped'

  echo `date`
  echo New DB online.
  echo $(ls *.gz.00 | rev | cut -c 11- | rev) released on $(date -r *.gz.00 +'%d/%m/%y') > revision

else
  echo "No Change!"
  ls *.gz.00

fi

echo `date`
