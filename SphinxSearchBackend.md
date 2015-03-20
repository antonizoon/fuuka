# Introduction #

MySQL fulltext indexing is slow as molasses for large datasets. As an alternative, you can use [Sphinx](http://sphinxsearch.com/), which is a billion times faster, at the expense of a hefty amount of RAM.

It is strongly recommended to use Sphinx if you have a public archive featuring at least a board that's archiving more than a few million posts. As an example, running a search daemon for a+jp+m+tg, used around 2 GB of active RAM at all times, as of  late 2011.

# Preparation #

  * Get and install [Sphinx](http://sphinxsearch.com/downloads/). Only 2.0.1+ is supported. The stable release at the time of this writing (0.9.9) is not supported. If you're installing through your OS's software repos, make sure you're getting 2.0.1.

  * Upgrade to [r70](https://code.google.com/p/fuuka/source/detail?r=70) (or later). Run the SQL script associated with [r70](https://code.google.com/p/fuuka/source/detail?r=70) in case it's necessary.

  * Edit the provided sphinx.conf.example file accordingly (it is inside the examples folder). Place it where your sphinx installation is expecting the sphinx.conf file to be, or, if you don't have root access, you can place it anywhere and call indexer/searchd with the -c option, but take care to take it to a place that the webserver isn't serving. You will need to edit the paths to match the location of your sphinx data folders for your OS (search for `var`). In addition, you will have to configure the data sources and indexes. There is one template data source, called `main` and another index template, also called `main`, that will contain the bulk of the configuration. For actual boards, you should just define data sources and indexes that inherit from the main templates, to avoid having to copy-paste so much.

  * Edit the main data source template (`source main`) and fill in your MySQL credentials. You can uncomment `sql_sock` and fill in the path to use a Unix domain socket to connect. In addition, change "`FROM a LIMIT 1`" to "`FROM <some_board_you_archive> LIMIT 1`" in the sql\_query. This isn't strictly needed, it's just so you can run the indexer on this dummy data source and create a tiny index, so sphinx doesn't throw a warning at start saying it can't find the index called main.

  * The sample conf file has data sources for a, jp, tg and m. Each board needs three data sources (board\_main, board\_ancient and board\_delta) and three indexes with the same name. You can just copy the three data sources and three indexes around and change the name of the boards. It should be obvious what to replace, but to make sure you're not missing anything, I recommend taking the sample of a board like jp or tg (ie: not a single letter), paste it into a text editor and do a search+replace for jp/tg into the board you want, then paste it into your file.

  * Run the main (dummy) index by issuing the `indexer main` command. Make sure you're running it as the user that will run the search daemon and indexer later on, or you'll have to chown things later.

  * For each board, run the ancient indexes. This will take a loooong time, if you have a large dataset. Do it with `indexer a_ancient jp_ancient m_ancient tg_ancient` on the command line. You get the drill.

  * Throw this into the crontab of the user that you'll be using to run the search server (searchd). Obviously, edit the paths and the name of the boards. It will update the main index at 2:05 AM every day, and will update the daily index every three minutes. It should also be the user you used to run indexer above, otherwise, go to your sphinx data folder and chown things. You can increase the time between the runs for the delta index; your server will do less work, but the search will lag further behind. It's your call.
```
*/3  * * * * /usr/local/bin/indexer a_delta jp_delta m_delta tg_delta --rotate --quiet
05 2 * * * /usr/local/bin/indexer a_main jp_main m_main tg_main --rotate --quiet
```

  * Edit `board-config.pl`. In DEFAULT\_ENGINE, switch `Mysql` to `Sphinx_Mysql`. You can also enable Sphinx for only a few boards by setting `database => "Sphinx_Mysql"` inside the board configuration definition and leaving DEFAULT\_ENGINE alone, but it seems incredibly pointless to me to do so. Once you go through the trouble of setting Sphinx up, you might as well use it for all the boards.

  * Check that everything is running fine. Once you're happy, you can drop the MySQL fulltext indexes in order to save space and time/CPU when archiving. Run a query like this for each board you're using Sphinx on:
```
`ALTER TABLE jp DROP INDEX comment_index`
```
> Don't forget to readd it if you ever want to switch back to the MySQL fulltext search method!

# Gory Details #
Sphinx indexes are static. That means you cannot update an existing index, you have to throw it away and start all over. It's obviously not feasible to regenerate indexes with multiple GBs every few minutes. However, you can perform queries over multiple indexes. Therefore, for each board, we have:

  * `<board>_ancient` holds the gigantic index, starting from the beginning of time, until the point where you manually ran it.
  * `<board>_main` keeps an index starting from the end of `<board>_ancient`, until the beginning of the current day. It's updated automatically once a day.
  * `<board>_delta` keeps a small index containing only the posts for that day. It's updated every few minutes.

With this scheme, search pretty much runs itself. You might want to redo the `board_ancient` indexes once every couple of months, to lighten up the load on the `board_main` indexes that run every night.