# Introduction #

Fuuka benefits greatly from a bit of MySQL tuning. I am in no way a DBA or anything of the sorts, so I'm afraid I can't offer you great tweaking insights, but I'll post what worked for me.

# Howto #

  * Locate your my.cnf file. On FreeBSD, this will be in /usr/local/etc/my.cnf, on Linux systems, usually /etc/my.cnf.

  * Under `[mysqld]`, there's a few options that you will want to set:
    * These two matter a lot, especially the first one. The first one will make it so the dumper threads have a lower priority than threads that just want to read, which makes the archive work in an incredibly more snappy way. No one cares if dumper threads have to wait a few more seconds locked in queue to insert new posts, but people get upset when the pages they're trying to open don't load. The second one will make it so threads trying to insert new rows don't need to lock as often and can just insert at the end of the table. While the first one makes a huge difference, you might want to experiment with the second one, if you have the time, as I'm not entirely convinced it's that beneficial.
```
low_priority_updates = 1
concurrent_insert = 2
```
    * You will need to tweak these if you ever need to repair a table (and because MyISAM is a piece of shit, you eventually will have to). While the table is repairing, watch the state of the MySQL processes, with `show processlist` in the MySQL command line. You should see a thread in the status "Repair by sorting." If, at any point in time, you see its state changing to "Repair by keycache," cancel the repair process, shut down the MySQL server and go tweak these parameters. Repair by keycache will make you stay there the entire week (I'm not even kidding), so it's completely worthless. First one is the max size MySQL can use for temporary files in disk when sorting. That's the most important one to avoid repairing by keycache. Set it to something rather large, just make sure you have enough disk space available in your tmp folder. Second one can also be important, set it to an amount of RAM you don't mind losing while the table is repairing. I used 1 GB, worked well enough for me. Third one is rather dubious, sometimes using two concurrent threads when doing a repair speeds up the processes, other times it does more harm than good. You can probably leave it alone.
```
myisam_max_sort_file_size = 50G
myisam_sort_buffer_size = 1G
myisam_repair_threads  = 2
```
    * If you have RAM lying around that you're not using for anything, you can increase the following two variables, they will make it so temp tables up to this size will be created in memory rather than in disk, which is much faster. I had it set to something outrageous, 2 GB. It's that a much better investment for your system's RAM is to run Sphinx, but I suppose it helps for stuff like the terrible reports, temporary tables these big will only ever be used for those, anyway.
```
tmp_table_size = 2G
max_heap_table_size = 2G
```