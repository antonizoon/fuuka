# Introduction #

LOCATION\_HTTP in `board-config.pl` changes how fuuka outputs URLs. It defaults to `$ENV{SCRIPT_NAME`}, which is the full path to the cgi-board.pl. You can make URLs better by adjusting this constant and applying some mod\_rewrite rules.

# Howto #

  1. Edit LOCATION\_HTTP. Change it to the desired root of your archive, but don't include a trailing slash. For example, if you want to have URLs like http://archive.example.com/a/, use an empty string (`''`). If you want to have URLs like http://example.com/archive/a/, use `'/archive'`
  1. Add the following rule to your .htaccess. Adjust accordingly, `RewriteBase` needs to be set to the same thing as LOCATION\_HTTP (but with a trailing slash).
```
DirectoryIndex cgi-board.pl index.html index.php
RewriteEngine On
RewriteBase /archive/
RewriteRule ^(a|jp|m|tg)(/|$)(.*)? cgi-board.pl/$1/$3 [NC,L]
```
> You can omit it altogether if you're running the archive on the root dir:
```
DirectoryIndex cgi-board.pl index.html index.php
RewriteEngine On
RewriteRule ^(a|jp|m|tg)(/|$)(.*)? cgi-board.pl/$1/$3 [NC,L]
```

All that is shown here is how to hide cgi-board.pl from your URLs. Further URL prettifying should be possible with more intricate rewrite rules.