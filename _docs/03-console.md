# OpenTTD Console notes

You can redirect the output to the in-game console by opening in-game console console and typing

developer 2

Enable output of print and AILog.* statements from your AI by typing

debug_level script=4

## tldr;

```
openttd.exe -D -d script=4 -d console=4 -l 127.0.0.1:3981
```

Some documentation recommend ai=4, as in:

```
openttd.exe -D -d ai=4 -d console=4 -l 127.0.0.1:3981
```

But think this is no good because sometimes will see error message saying that "ai" is unidentified flag (or something similar).

From what we know of debug_level:

debug_level
Current debug-level:
    driver      =0, 
    grf         =0, 
    map         =0, 
    misc        =0, 
    net         =6, 
    sprite      =0, 
    oldloader   =0, 
    npf         =0, 
    yapf        =0, 
    freetype    =0, 
    script      =4, 
    sl          =0, 
    gamelog     =0, 
    desync      =0, 
    console     =4