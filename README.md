VFB Local Database Management
======

To load the latest Flybase version:

Note: This should only be run on main server them replicated to others

Ensure you have created a ~/.pgpass file containing:
```
localhost:5432:*:nmilyav1:password
```
Obviously replacing password with the real password.

Then run getFlybase.sh

Note: as a very long job recomended to run as: ```nohup nice nice krenew -k /disk/data/Home/$USER/mylongcred -t ./getFlybase.sh &```

Note: This will take hours! 
