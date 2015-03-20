# Howto #

I will be explaining how to merge your database with the files from Easymodo I provided. I will refer to the new archive that you started and that contains only recent data as "new tables" and to the tables you downloaded from me as the "easymodo tables."

I will be giving the example for /jp/. Replace accordingly for a/m/tg.

  1. Stop the archiving dumpers
  1. Take down the webserver (or just block access to the archive web interface, if you require access to stuff like phpMyAdmin in the meanwhile)
  1. If your new table has a doc\_id column (ie: you set up the archive with [r70](https://code.google.com/p/fuuka/source/detail?r=70) or later), we need to get rid of it, so your IDs won't conflict with easymodo's. You will get new IDs for the posts you archived automatically in the import process (unfortunately, adding a sequential, integer identifier for each post was a requirement to implement Sphinx -- post number doesn't work because of ghost posts):
```
ALTER TABLE `jp` DROP `doc_id`
```
  1. Dump your new tables. Replace root with your MySQL user and archive with your MySQL database name. It's important to keep all the other options. You will mess things up if you don't have -c and you will destroy the table you downloaded if you don't have --no-create-info. If you have no ghost posts, you don't have to dump and import jp\_local:
```
mysqldump -c --no-create-info --insert-ignore --default-character-set=utf8 -u root -p archive jp > jp_new.sql
mysqldump -c --no-create-info --insert-ignore --default-character-set=utf8 -u root -p archive jp_local > jp_new_local.sql
```
  1. Rename the tables you just dumped to something else:
```
RENAME TABLE `jp` TO `jp_new`
RENAME TABLE `jp_local` TO `jp_new_local`
```
  1. Stop the MySQL server.
  1. Move the easymodo tables, consisting of the jp.MYI/jp.MYD/jp.frm and jp\_local.MYI/jp\_local.MYD/jp\_local.frm files your downloaded into place (ie: where your MySQL table files live, next to jp\_new.MYI/MYD/frm). chown and chmod accordingly to make them match the permissions of the other table files.
  1. Start the MySQL server.
  1. Make sure that jp is now the easymodo table and jp\_new is the new table you want to merge.
  1. Import the dumps you generated into the easymodo tables with:
```
mysql --default-character-set=utf8 -u root -p archive < jp_new.sql
mysql --default-character-set=utf8 -u root -p archive < jp_new_local.sql
```
  1. Take the webserver online and quickly take a look around to check if everything worked as expected. Block external accesses if you can. Do not perform a search!! Take the webserver offline again once you are satisfied the import occurred correctly.
  1. You now have the following options. Take notice that, for /a/, you are limited to the first two options; the /a/ archive is too large and the last option simply doesn't scale. So, for /a/, you are required to either go Sphinx or disable search altogether (if you want to provide anything resembling a functional archive, that is).
    * Switch to Sphinx. Much better performance at the expense of extra RAM usage (and initial configuration). Switch the DEFAULT\_ENGINE to `Sphinx_Mysql` in and follow the instructions in SphinxSearchBackend to set up Sphinx. You can create the Sphinx indexes with the archive online and while dumping, only search will be down while you do so.
    * Disable search. At the beginning of show\_search in cgi-board.pl, insert something like:
```
error "Search is broken for /jp/." if $text and $board_name eq 'jp'; 
```
    * Use MySQL native fulltext search. Okay performance for small archives, unacceptable performance for large ones. Easy configuration. Easymodo tables do not contain the fulltext index required for this method, so you are required to add the indexes yourself if you want to use this. Failure to do so will cause MySQL to perform fulltext searches without a fulltext index, killing your server and making it even more slow than it's supposed to be. Keep the DEFAULT\_ENGINE to `MySQL` and then issue the following query, this will take a very long time and you cannot restart the dumpers or take the archive online while it runs:
```
ALTER TABLE jp ADD FULLTEXT comment_index(comment);
```
  1. Take the webserver back online, restart the board dumpers.
  1. Optionally, you can disable some reports. You don't have to disable all the reports, some are rather fast, but others, especially most reposted images, take an unreasonable amount of time. Disabling a report is as simple as moving the respective file out of the reports folder. You can also skip all reports altogether for just one board by editing board-reports-demon.pl and adding this as the third line in the method `sub do_report`:
```
    next if $board->{name} eq 'a'; 
```
  1. Finally, take jp.tar and unpack it into the place where you're storing your thumbnails. This step can be done at any time, but it's advisable to not do it in parallel with anything else that uses a lot of disk I/O (basically, any other file copy/database dump/database import/index generation/report generation).