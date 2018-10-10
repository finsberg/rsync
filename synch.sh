#!/bin/bash
OPTIONS="-avzhe ssh"

# Sync from server to local
rsync $OPTIONS "henriknf@server:/home/henriknf/local/sandbox/rsync_server/" "/Users/finsberg/local/sandbox/rsync/rsync_local/"
# Sync from local to server
rsync $OPTIONS "/Users/finsberg/local/sandbox/rsync/rsync_local/" "henriknf@server:/home/henriknf/local/sandbox/rsync_server/"
