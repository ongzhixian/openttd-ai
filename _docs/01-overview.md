# Overview

Written in C++ like language call Squirrel.

OpenTTD server runs. 
    The default is 3979. (It uses 3978 to contact master server) OpenTTD uses TCP and UDP


## Running OpenTTD as a dedicated server (https://wiki.openttd.org/Dedicated_server)

.\openttd.exe -D -d 4 >logfile.log

 for the process is STDOUT, redirected by the 1> or by > (1 can be omitted, by convention, the command interpreter [cmd.exe] knows to handle that). File handle 2 is STDERR, redirected by 2>.

https://support.microsoft.com/en-us/help/110930/redirecting-error-messages-from-command-prompt-stderr-stdout
STDOUT -- redirected by the 1> or by >
STDERR -- redirected by the 2>

Working
openttd -D -d ai=9
openttd -D >> logfile.log 2>&1
openttd -D -d 2 >> logfile.log 2>&1

Not working
Start-Process -FilePath "C:\Apps\openttd\openttd.exe" -Argumentlist "-D -d 4" -RedirectStandardError "logfile.log"



## Dedicated server script

https://wiki.openttd.org/Scripts

```
echo "Starting server"
setting server_name "ZOGA330"
script openttd.log
```

If we then save the above script as .openttd/scripts/on_dedicated.scr, it will be run whenever a dedicated server is started, and do the following:

It will Print "Starting Server" in the console window
It will begin logging the non-debuging output from the console window to openttd.log
The server name will be set to "ZOGA330"


## Console

https://wiki.openttd.org/Console


## List of AIs

DAIA -- Dummy Artificial Intelligence (A, B, C, ...etc)

Code    Name
Daia
Daib
Daic
Daid
Daie
Daif
Daig
Daih
Daii
Daij
Daik
Dail
Daim
Dain
Daio
Daip
Daiq
Dair
Dais
Dait
Daiu
Daiv
Daiw
Daix
Daiy
Daiz

# Installation

Files are to be copied to C:\Apps\openttd\ai

C:\Apps\openttd
├───ai
    │   compat_0.7.nut
    │   compat_1.0.nut
    │   compat_1.1.nut
    │   compat_1.10.nut
    │   compat_1.2.nut
    │   compat_1.3.nut
    │   compat_1.4.nut
    │   compat_1.5.nut
    │   compat_1.6.nut
    │   compat_1.7.nut
    │   compat_1.8.nut
    │   compat_1.9.nut
    │
    └───Daia
            info.nut
            main.nut

# Reference links

https://wiki.openttd.org/AI

https://www.openttd.org/development.html
https://wiki.openttd.org/AI:Main_Page
https://wiki.openttd.org/AI:AIMain
http://squirrel-lang.org/doc/squirrel2.html

