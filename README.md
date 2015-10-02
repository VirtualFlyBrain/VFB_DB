VFB Local Database Management
======

To load the latest Flybase version:

Note: This should only be tested on dev server before being updated to main server.

Ensure you have created a ~/.pgpass file containing:
```
localhost:5432:*:nmilyav1:password
```
Obviously replacing password with the real password.

Then run getFlybase.sh

Note: as a very long job recomended to run as: ```nohup nice nice krenew -k /disk/data/Home/$USER/mylongcred -t ./getFlybase.sh &```

Note: This will take hours! (8.5 on karenin)
