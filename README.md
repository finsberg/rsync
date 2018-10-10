# Using rsync to sync your local and remote folders

Suppose you have a server that you can access using ssh, for example I
have a server named `server` and my username on that server is
`henriknf`. I can connect to this server using the command

```shell
ssh henriknf@server
```

## How can I sync a folder on my server with a folder on my local computer?

Say you have a folder on your local machine that you want to keep up
to date to a folder you have on your server.

I suppose the folder on my local machine is located at
`/Users/finsberg/local/sandbox/rsync/rsync_local` while the folder on the server
is located at `/home/henriknf/local/sandbox/rsync_server`.

Of course it is possible to copy all the files from the server to the
local machine using `scp` (securecopy) using the command
```shell
scp -r henriknf@server:/home/henriknf/local/sandbox/rsync_server/ /Users/finsberg/local/sandbox/rsync/rsync_local/
```
The
Similarly, I can copy stuff from my local machine to the server by
just switching the roles
```shell
scp -r /Users/finsberg/local/sandbox/rsync/rsync_local/ henriknf@server:/home/henriknf/local/sandbox/rsync_server/
```
However, the problem with `scp` is that is only reads the source file(s)
and writes it to the destination. This means that every time you copy
something, you will have to copy everything.
And if your copy is interrupted you need to start it all over again.

`rsync` is much smarter. `rsync` performs a lot of optimization so
that you only [copy the
difference](https://rsync.samba.org/tech_report/).
In its simplest for you can use almost the same command as before.
```shell
rsync -avzhe ssh henriknf@server:/home/henriknf/local/sandbox/rsync_server/ /Users/finsberg/local/sandbox/rsync/rsync_local/
```
This will make sure that your `rsync_local` is up to data with
`rsync_server`, but not the other way around. This is because you
might have conflict and therefore it has to make a choice with version
that is the correct one.

If you want to sync your server folder (`rsync_server`) with new
content on `rsync_local` you just need to switch the order:
```shell
rsync -avzhe ssh /Users/finsberg/local/sandbox/rsync/rsync_local/ henriknf@server:/home/henriknf/local/sandbox/rsync_server/
```

**Note that you need the "/" at the end of the path in order not to copy
the whole folder inside the other**


## How can I automate this processs?

First of all, if the directory don't change you can put the commands
for syncing file to and from the server in a bash script, e.g create
a file called `sync.sh` and put the following lines in it,
```bash
#!/bin/bash
OPTIONS="-avzhe ssh"
rsync $OPTIONS "henriknf@server:/home/henriknf/local/sandbox/rsync_server/" "/Users/finsberg/local/sandbox/rsync/rsync_local/"
rsync $OPTIONS "/Users/finsberg/local/sandbox/rsync/rsync_local/" "henriknf@server:/home/henriknf/local/sandbox/rsync_server/"
```
**Make sure to change the paths to your own paths!**
Then make the file executable
```shell
chmod +x sync.sh
```
Right now you can run the command
```
./sync.sh
```
whenever you want to sync the files.

## Can I make rsync sync automatically when I perform changes?

If you want something similar to
dropbox, which watches your folder and sync whenever it detect a
change, there are ways of doing that. The simplest way I found is to
install a python package called `watch-rsync` which uses a library
called [`watchdog`](https://pythonhosted.org/watchdog/) and works on
most platforms. Install it using
```
pip install watch-rsync
```
(you might need `sudo` first or `--user` in the end if you get a
`Permission denied` error)

Then you can simply run the command
```
watch-rsych /Users/finsberg/local/sandbox/rsync/rsync_local/ henriknf@server:/home/henriknf/local/sandbox/rsync_server/
```
to sync to the server and
```
watch-rsych henriknf@server:/home/henriknf/local/sandbox/rsync_server/ /Users/finsberg/local/sandbox/rsync/rsync_local/
```
to sync to your local machine.
And if you want it to run in the background, add a `&` at the end of
the commands.

## Documentation

You can find some documentation on how to use rsync by running the
command
```
rsync --help
```
For a more thorough documentation, see the man pages
```
man rsync
```
