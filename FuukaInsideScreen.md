# Running fukka with GNU screen #

You will want to run fuuka's board dumpers inside something like GNU screen, so you can always reattach and see the output of the dumpers.

In addition, fuuka's board dumpers will exit in case there's an error. Unfortunately, 4chan can somehow have glitches that still throw fuuka off and cause it to abort. There is a screen configuration file provided inside the examples folder that you can use. Copy it to (for example) the home directory of the user that will be running the dumpers. Edit the paths and the boards and and then simply issue the command:
```
screen -d -m -S archiver -c ~/screen-archive
```

This will start a new screen session, detached, with all the dumpers (plus the reports daemon) running each inside a different screen window. Run screen -r to attach to said session. Use Ctrl+a " to switch between windows, Ctrl+a d to detach the session and leave the dumpers running.