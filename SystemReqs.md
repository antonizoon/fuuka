## System requirements ##
  * Perl 5.10 or above, must be compiled with ithreads. Do `perl -V | grep ithread` to check.
  * MySQL 5.0+ (5.1+ highly recommended)
  * A webserver that can run CGI scripts or Apache with mod\_perl (recommended)
  * gnuplot (version >= 4.2, gd with PNG support)
  * Ability to run daemons / background processes (GNU screen recommended)
  * Around 110~250 MiB of RAM per board being archived
  * About 2 GiB of extra RAM to run the (optional, but much faster) Sphinx search backend for a board with a number of posts similar to /a/ (as of late 2011)

## Perl modules ##
Apart from standard modules that you probably already have (CGI, Carp, Data::Dumper, Encode, Time::HiRes), you'll also need the following perl modules installed:
  * URI::Escape
  * DBI
  * Digest::SHA1
  * LWP
  * DBD::mysql (Important: you need version >= 4.0, otherwise Unicode characters will get messed up in the database. Do `perl -MDBD::mysql -e 'print "$DBD::mysql::VERSION\n"'` to check)
  * DateTime
  * DateTime::TimeZone
  * Net::IP
  * Date::Parse
  * threads::shared ships with Perl, but we require version >= 1.21. Do `perl -Mthreads::shared -e 'print "$threads::shared::VERSION\n"'` to check which version you have. If necessary, either upgrade your copy of Perl to a more recent version (5.10.1+ should ship with a suitable version of this module) or just the threads::shared module itself (from CPAN, for example).

## FreeBSD ports ##
If you're running FreeBSD, just install the following ports:

  * lang/perl5.14 (enable threads)
  * net/p5-URI
  * databases/p5-DBI
  * security/p5-Digest-SHA1
  * www/p5-libwww
  * databases/p5-DBD-mysql
  * devel/p5-DateTime
  * devel/p5-DateTime-TimeZone
  * net-mgmt/p5-Net-IP
  * devel/p5-TimeDate
  * math/gnuplot (you can disable all the options in graphics/gd and all the options except for gd in math/gnuplot to avoid building X11)