# mulexe
### Viewing log files in multiple machines

A shell sciprt enables to execute a command in multiple machine under the same directory. Desgined to view log files for application deployed in multiple servers.

### Setup
1. Install sshpass by `sudo yum install sshpass`
2. Put the files to your $PATH directory e.g. `/usr/local/bin`
3. Configure the setting in `mulexe.conf` with `username@ipaddress` and `password`

### Requirement
The server should be able to connect to the configured server through SSH

## Example (logged in server-1, configured with server-2)

### List file in current directory
```
$ mulexe 'ls /'
--------------------------------server-1--------------------------------
[server-1]bin
[server-1]boot
[server-1]dev
[server-1]etc
[server-1]home
[server-1]lib
[server-1]lib64
[server-1]media
[server-1]mnt
[server-1]opt
[server-1]proc
[server-1]root
[server-1]run
[server-1]sbin
[server-1]srv
[server-1]sys
[server-1]tmp
[server-1]usr
[server-1]var
--------------------------------server-2--------------------------------
[server-2]bin
[server-2]boot
[server-2]dev
[server-2]etc
[server-2]home
[server-2]lib
[server-2]lib64
[server-2]media
[server-2]mnt
[server-2]opt
[server-2]proc
[server-2]root
[server-2]run
[server-2]sbin
[server-2]srv
[server-2]sys
[server-2]tmp
[server-2]usr
[server-2]var
```

### Read log file
```
$ mulexe 'cat test.log'
--------------------------------server-1--------------------------------
[server-1][2019-08-03 08:02:45.964]*****************
[server-1][2019-08-03 08:02:46.145]*****************
[server-1][2019-08-03 08:02:46.666]*****************
[server-1][2019-08-03 08:02:46.824]*****************
--------------------------------server-2--------------------------------
[server-2][2019-08-03 08:02:44.954]*****************
[server-2][2019-08-03 08:02:45.145]*****************
[server-2][2019-08-03 08:02:45.526]*****************
[server-2][2019-08-03 08:02:45.588]*****************
```

### Read log file and grep by keyword
```
$ mulexe 'cat test.log' | grep 'keyword'
--------------------------------server-1--------------------------------
[server-1][2019-08-03 08:02:45.964]*********keyword********
[server-1][2019-08-03 08:02:46.145]******keyword***********
[server-1][2019-08-03 08:02:46.666]**************keyword***
[server-1][2019-08-03 08:02:46.824]********keyword*********
--------------------------------server-2--------------------------------
[server-2][2019-08-03 08:02:44.954]*****keyword************
[server-2][2019-08-03 08:02:45.145]***********keyword******
[server-2][2019-08-03 08:02:45.526]******keyword***********
[server-2][2019-08-03 08:02:45.588]*********keyword********
```

### Merge the log file with timestamp (for log start with a timestamp)
```
$ mulexe 'cat test.log' | sort -t] -k2
--------------------------------server-1--------------------------------
--------------------------------server-2--------------------------------
[server-2][2019-08-03 08:02:44.954]*****************
[server-1][2019-08-03 08:02:44.988]*****************
[server-2][2019-08-03 08:02:45.145]*****************
[server-2][2019-08-03 08:02:45.588]*****************
[server-1][2019-08-03 08:02:46.145]*****************
[server-1][2019-08-03 08:02:46.666]*****************
[server-2][2019-08-03 08:02:46.721]*****************
[server-1][2019-08-03 08:02:46.824]*****************
```

### Specify server information at command line (without reading `mulexe.conf`)
```
$ mulexe \ 
> -h username@server-2 -p password_2 \ 
> -h username@server-3 -p password_3 \
> 'cat test.log'
--------------------------------server-1--------------------------------
[server-1][2019-08-03 08:02:45.964]*****************
[server-1][2019-08-03 08:02:46.145]*****************
[server-1][2019-08-03 08:02:46.666]*****************
[server-1][2019-08-03 08:02:46.824]*****************
--------------------------------server-2--------------------------------
[server-2][2019-08-03 08:02:44.954]*****************
[server-2][2019-08-03 08:02:45.145]*****************
[server-2][2019-08-03 08:02:45.526]*****************
[server-2][2019-08-03 08:02:45.588]*****************
--------------------------------server-3--------------------------------
[server-3][2019-08-03 08:02:45.964]*****************
[server-3][2019-08-03 08:02:46.145]*****************
[server-3][2019-08-03 08:02:46.666]*****************
[server-3][2019-08-03 08:02:46.824]*****************
```
