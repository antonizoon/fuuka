# Introduction #

Sometimes, the user you're using to archive the boards might be different than the user that runs the perl scripts on the webserver. If you're using something like mod\_perl, this will always be true.

In that case, you can't delete thumbnails with the thumbnail deletion password, because the webserver won't have permissions to delete files that the board dumper grabbed and stored. Here is how to get it to work.

# Procedure #

  * Check which user is being used to run the webserver perl scripts. This is usually the same user your webserver runs as if you're using mod\_perl or something similar. Usually it's user `www`, with default group also `www`, but this might differ (`www-data` is used on some systems).
  * Add the user that you're using to run the board archiving deamon to the group of the webserver. Here are some examples:
```
OS X:
sudo dseditgroup -o edit -a archive -t user _www
FreeBSD:
pw usermod archive -G www
Linux:
useradd -G www-data archive
```
  * Edit WEBSERVER\_GROUP in board-config.pl and set it to the group of your webserver.

Alternatively, if the procedure above is too complicated for you, or you just don't have enough permissions to perform it, you can just change the chmod statement on lines 165 and 205 to 0666 rather than 0664. This is totally not recommended, but it's your call.

In addition, this will only fix permissions for newly archived files. You can fix permissions for all the existing thumbs by cd'ing into the board dir and issuing:
```
chown -R archive:www thumb; find ./thumb -type d -print0 | xargs -0 chmod 0775; \
    find ./thumb -type f -print0 | xargs -0 chmod 0664
```
These commands assume you're running the archiving daemon under the user `archive` and your webserver group is called `www`.