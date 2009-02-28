﻿use strict;
use utf8;

use constant NORMAL_HEAD_INCLUDE => <<'HERE';
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<title><if $board_desc>/<var $board_name>/ - <var $board_desc></if><if $title> - <var $title></if></title>
<script type="text/javascript" src="<const MEDIA_LOCATION_HTTP>/board.js"></script>
<meta name="description" content="The Pleasure of Being Cummed Inside" />
<link rel="stylesheet" type="text/css" href="<const MEDIA_LOCATION_HTTP>/fuuka.css" title="Fuuka" />
<style type="text/css"><!--
	html,body { background:#eefff2; color:#002200; }
	img { border: none; }
	a { color:#34345c; }
	a:visited { color:#34345c; }
	a:hover { color:#DD0000; }
	.js, .js a { color:black;text-decoration:none; }
	.js:hover, .js a:hover { color:black;font-weight:bold;text-decoration:underline; }
	.thumb, .nothumb { float: left; margin: 2px 20px; }
	.doubledash { vertical-align:top;clear:both;float:left; }
	.inline { vertical-align:top; }
	.reply { background:#d6f0da; }
	.subreply { background:#cce1cf; }
	.highlight { background:#d6bad0; }
	.unkfunc{ color:#789922; }
	.postername { color:#117743; font-weight:bold; }
	.postertrip { color:#228854; }
	a.tooltip span, a.tooltip-red span { display:none; }
--></style>
</head>
<body>
<var $navigation>
<div><if $board_desc><h1>/<var $board_name>/ - <var $board_desc></h1></if><if $title><h2><var $title></h2></if></div>
HERE

use constant NORMAL_FOOT_INCLUDE => <<'HERE';

</body>

</html>
HERE

use constant CENTER_HEAD_INCLUDE => <<'HERE';
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<title><var $title></title>
<script type="text/javascript" src="<const MEDIA_LOCATION_HTTP>/board.js"></script>
<style type="text/css">
html, body {
	height: 100%;         /* required */
}
body {
	background: #eefff2;
	color: #002200;
	text-align: center;			/* horizontal centering hack for IE */
	padding: 0;					/* required to "hide" distance div */
	margin: 0;					/* required to "hide" distance div */
}
div#distance { 
	margin-bottom: -<var $height/2>em; /* half of content height */
	width: 1px;					/* required to "hide" distance div */
	height: 50%;				/* required */
	float: left;				/* required */
}
div#content {
	position: relative;			/* positions content on top of distance */
	text-align: left;			/* horizontal centering hack for IE */
	height: <var $height>em;	/* required - desired height */
	width: <var $width>em;		/* required - desired width */
	margin: 0 auto;				/* required */
	clear: left;				/* required */
}
<var $custom_css>
</style>
</head>
<body>
<div id="distance"></div>
<div id="content">
HERE

use constant CENTER_FOOT_INCLUDE => <<'HERE';
</div>
</body>
</html>
HERE

use constant LATE_REDIRECT_INCLUDE => <<'HERE';
<h1><var $title></h1>
<div class="outer"><div class="inner">
<span class='aa'><var simple_format($message)></span>
</div></div>
<p><a href="<var $link>" style>Click here to be forwarded manually</a><br /><br /><a href="http://code.google.com/p/fuuka/">Fuuka</a> | All characters <acronym title="DO NOT STEAL MY ART">&#169;</acronym> Darkpa's party</p>
HERE

use constant INDEX_INCLUDE => <<'HERE';
<h1>Welcome to 4chan archiver</h1>
<h2>Choose a board:</h2>
<p>
<loop $list>
<a href="<var $link>" title="<var $description>">/<var $name>/</a>&nbsp;
</loop>
</p>
HERE

use constant SIDEBAR_ADVANCED_SEARCH => <<'HERE';
<form action="<var $self>" method="get">
<div id="advanced-search" class="postspan" style="float:left;<if not $standalone>display:none;</if>">
<input type="hidden" name="task" value="search2" />
<input type="hidden" name="ghost" value="<var $ghost>" />
<table style="float:left"><tbody>

<tr><td colspan="2" class="theader">Advanced search</td></tr>

<tr>
<td class="postblock">Text to find</td>
<td><input type="text" name="search_text" size="32" value="<var $search_text>" /></td>
</tr>

<tr>
<td class="postblock">Username <a class="tooltip" href="#">[?]<span>Search for <b>exact</b> user name. Leave empty for any user name.</span></a></td>
<td><input type="text" name="search_username" size="32" value="<var $search_username>" /></td>
</tr>

<tr>
<td class="postblock">Tripcode <a class="tooltip" href="#">[?]<span>Search for <b>exact</b> tripcode. Leave empty for any.</span></a></td>
<td><input type="text" name="search_tripcode" size="32" value="<var $search_tripcode>" /></td>
</tr>

<tr>
<td class="postblock">Deleted posts</td>
<td><input type="radio" <if $search_del eq 'dontcare' or not $search_del>checked="checked" </if>name="search_del" value="dontcare" />Show all posts<br /><input type="radio" <if $search_del eq 'yes'>checked="checked" </if>name="search_del" value="yes" />Show only deleted posts<br /><input type="radio" <if $search_del eq 'no'>checked="checked" </if>name="search_del" value="no" />Only show non deleted posts.</td>
</tr>

<tr>
<td class="postblock">Internal posts</td>
<td><input type="radio" <if $search_int eq 'dontcare' or not $search_int>checked="checked" </if>name="search_int" value="dontcare" />Show all posts<br /><input type="radio" <if $search_int eq 'yes'>checked="checked" </if>name="search_int" value="yes" />Show only internal posts<br /><input type="radio" <if $search_int eq 'no'>checked="checked" </if>name="search_int" value="no" />Show only archived posts</td>
</tr>

<tr>
<td class="postblock">Order</td>
<td><input type="radio" <if $search_ord eq 'new'>checked="checked" </if>name="search_ord" value="new" />New post first<br /><input type="radio" <if $search_ord eq 'old'>checked="checked" </if>name="search_ord" value="old" />Old posts first<br /><input type="radio" <if $search_ord eq 'rel' or not $search_ord>checked="checked" </if>name="search_ord" value="rel" />Relevant posts first <a class="tooltip" href="#">[?]<span>Can only order by relevancy if query contains none of <tt>*</tt>, <tt>+</tt>, or <tt>-</tt> characters.</span></a></td>
</tr>

<tr>
<td class="postblock">Action</td>
<td><input type="submit" value="Search" /> <a href="#" onclick="javascript:toggle('advanced-search');toggle('simple-search');return false;">[ Simple ]</a></td>
</tr>

</tbody></table>
</div></form>
HERE

use constant SIDEBAR_INCLUDE => <<'HERE'.SIDEBAR_ADVANCED_SEARCH.<<'THERE';
<hr />
<div style="overflow:hidden;">

<form action="<var $self>" method="get">
<div id="simple-search" class="postspan" style="float:left">
<input type="hidden" name="task" value="search" />
<input type="hidden" name="ghost" value="<var $ghost>" />
Text search
<a class="tooltip" href="#">[?]<span>Place a <tt>+</tt> before a word to have it included, e.g. <tt>+tripcode</tt> to locate posts that contain word tripcode in them.<br />Place a <tt>-</tt> before a word to exlude pages containing that word: <tt>-tripcode</tt><br />Place quotes around phrases to find pages containing the phrase: <tt>"I am a filthy tripcode user"</tt></span></a>&nbsp;
<input type="text" name="search_text" size="24" value="<var $search_text>" />&nbsp;
<input type="submit" value="Go" />&nbsp;
<a href="<var $self>/advanced-search" onclick="javascript:toggle('advanced-search');toggle('simple-search');return false;">[ Advanced ]</a>
</div>
</form>
HERE

<form action="<var $self>" method="get">
<div class="postspan" style="float:left">
<input type="hidden" name="task" value="post" />
<input type="hidden" name="ghost" value="<var $ghost>" />
View post&nbsp;
<input type="text" name="post" size="9" value="<var $thread>" />&nbsp;
<input type="submit" value="Submit" />
</div></form>

<form action="<var $self>" method="get">
<div class="postspan" style="float:left">
<input type="hidden" name="task" value="page" />
View page&nbsp;
<input type="text" name="page" size="6" value="<var $page or 1>" />&nbsp;
<input type="submit" value="View" />&nbsp;
<a class="tooltip" href="#">[?]<span>In ghost mode, only threads with non-archived posts will be shown</span></a>
<input type="submit" name="ghost" value="View in Ghost mode" />
</div></form>

</div>
<hr />
THERE

use constant POST_PANEL_INCLUDE => <<'HERE';
	<div class="theader">Reply to thread <a class="tooltip-red" href="#">[?]<span>Don't expect anything heroic. Your post will not be uploaded to original board.</span></a></div>
	<div><input type="hidden" name="task" value="reply" />
	<input type="hidden" name="ghost" value="<var $ghost>" /></div>
	<if $thread><div><input type="hidden" name="parent" value="<var $thread>" /></div></if>

	<table><tbody>
	
	<tr><td class="postblock">Name</td><td><input type="text" name="name" size="63" /></td></tr>
	<tr><td class="postblock">E-mail</td><td><input type="text" name="email" size="63" /></td></tr>
	<tr><td class="postblock">Subject</td><td><input type="text" name="subject" size="63" /></td></tr>
	<tr><td class="postblock">Comment</td><td><textarea name="comment" cols="48" rows="4"></textarea></td></tr>
	<tr><td class="postblock">Password <a href="#" class="tooltip">[?]<span>Password used for file deletion.</span></a></td><td><input type="password" value="" size="24" name="delpass"/></td></tr>
	<tr><td class="postblock">Action</td><td><input type="submit" value="Submit" /> <input type="submit" name="delposts" value="Delete selected posts" /></td></tr>

	</tbody></table>
HERE

use constant POSTS_INCLUDE_POST_HEADER => <<'HERE';
<label><input type="checkbox" name="delete" value="<var $num>,<var $subnum>" />
<if $title><span class="filetitle"><var $title></span>&nbsp;</if>

<if $capcode eq 'G'>
<span style="background:white;color:black;border:1px solid gray;font-weight:bold;padding:0.5em 1.5em;position:relative;"><span style="background-image:url(/media/god-left.png);height:148px;left:-3em;position:absolute;top:-3.6em;width:121px;"></span><var $name> <span class="trip">## God</span></span>
<span style="position:relative;"><span style="background-image:url(/media/god-right.png);height:148px;left:-6em;position:absolute;top:-4em;width:156px;"></span></span>
<else>
<span class="postername<if $capcode eq 'A'> admin</if><if $capcode eq 'M'> mod</if>">
<if $email><a href="mailto:<var $email>"></if><var $name><if $email></a></if><nonl>
</span><nonl>
<if $trip><nonl>
<if $email><a href="mailto:<var $email>"></if><nonl>
<span class="postertrip<if $capcode eq 'A'> admin</if><if $capcode eq 'M'> mod</if>">&nbsp;<var $trip></span><if $email></a></if></if>
<if $capcode eq 'A'><span class="postername admin"> ##Admin</span></if>
<if $capcode eq 'M'><span class="postername mod"> ##Mod</span></if>
</if>

<var gmtime $date></label>

<if $replyform>
<a class="js" href="<var ref_post($parent,$num,$subnum)>">No.</a><a class="js" href="javascript:insert('&gt;&gt;<var ref_post_text($num,$subnum)>\n')"><var ref_post_text($num,$subnum)></a>
<else>
<a class="js" href="<var ref_post($parent,$num,$subnum)>">No.<var ref_post_text($num,$subnum)></a>
</if>

<!-- this icon hurts my eyes <if $subnum><img class="inline" src="<const MEDIA_LOCATION_HTTP>/internal.png" alt="[INTERNAL]" title="This is not an archived reply" />&nbsp;</if> -->
<if $spoiler><img class="inline" src="<const MEDIA_LOCATION_HTTP>/spoilers.png" alt="[SPOILER]" title="Picture in this post is marked as spoiler" />&nbsp;</if>
<if $deleted><img class="inline" src="<const MEDIA_LOCATION_HTTP>/deleted.png" alt="[DELETED]" title="This post was deleted before its lifetime has expired" />&nbsp;</if>
HERE

use constant POSTS_INCLUDE => q{
<form id="postform" action="<var $self>" method="post" enctype="multipart/form-data">
<div class="content">

<loop $threads>
	<loop $posts>
		<if not $parent and not $blockquote>
			<div id="p<var $$_{num}>">
			
			<if !$file>
				<if $spoiler><img class="thumb" src="<const MEDIA_LOCATION_HTTP>/spoiler.png" alt="[SPOILER]" /></if>
				<if !$spoiler><img src="<const MEDIA_LOCATION_HTTP>/error.png" alt="[ERROR]" class="nothumb" title="No thumbnail" /></if>
			</if>
			<if $file>
				<span>File: <var make_filesize_string($media_size)>, <var $media_w>x<var $media_h>, <var $media><!-- <var $media_hash> --></span><br />
				<if $media_filename><a href="<var "$yotsuba_link/src/$media_filename">"></if>
				<img class="thumb" src="<var $file>" alt="<var $num>" <if $preview_w>width="<var $preview_w>" height="<var $preview_h>"</if> />
				<if $media_filename></a></if>
			</if>
			
			}.POSTS_INCLUDE_POST_HEADER.q{
			
			[<a href="<var ref_thread($num)>">Reply</a>]&nbsp;[<a href="<var $yotsuba_link>/res/<var $num>.html">Original</a>]
			<blockquote><p><var $$_{comment}></p></blockquote>
			<if $count>
				<span class="omittedposts"><var $count> replies omitted. Click Reply to view.</span>
			</if>
			
			</div>
		</if>
		<if $parent or $blockquote>
			<table><tr>
			
			<td class="doubledash">&gt;&gt;</td>
			<td class="<if $subnum>sub</if>reply" id="p<var $num><if $subnum>_<var $subnum></if>">
			
			}.POSTS_INCLUDE_POST_HEADER.q{
			
			<if $blockquote>[<a href="<var ref_post($parent,$num,$subnum)>">View</a>]</if>
			
			<if $preview>
				<br />
				<span>File: <var make_filesize_string($media_size)>, <var $media_w>x<var $media_h>, <var $media><!-- <var $media_hash> --></span>
				
				<if $media_filename><a href="<var "$yotsuba_link/src/$media_filename">"></if>
				<if $file><img class="thumb" src="<var $file>" alt="<var $$_{num}>" <if $preview_w>width="<var $preview_w>" height="<var $preview_h>"</if> /></if>
				<if $media_filename></a></if>
				<if not $file><img src="<const MEDIA_LOCATION_HTTP>/error.png" alt="ERROR" class="nothumb" title="No thumbnail" /></if>
			</if>
			
			<blockquote><p>
			<var $comment>
			</p></blockquote>
			</td>
			</tr></table>
		</if>
	</loop>
	<if $replyform>
		<table><tbody>
		
		<tr><td class="doubledash">&gt;&gt;</td>
		<td class="subreply">
}.POST_PANEL_INCLUDE.q{
		</td></tr>
		
		</tbody></table>
	</if>
	<br class="newthr" /><hr />
</loop>

</div>
</form>
};

use constant SEARCH_INCLUDE => <<'HERE'.POSTS_INCLUDE.<<'THERE';
<if $found>
HERE
</if>
<if not $found>
No posts found
</if>
<table style="float:left"><tbody>

<tr><td colspan="<var 1+@$search_pages>" class="theader">Navigation</td></tr>
<tr>

<td class="postblock">View posts</td>
<loop $search_pages>
<td>[<a href="<var $self>?<var x_www_params(cgi_params,'offset',$val)>"><var $caption></a>]</td>
</loop>

</tr>

</tbody></table>
THERE

use constant REPORT_LIST_INCLUDE => <<'HERE';
<table class="generic-table"><tbody>
<loop $reports>
	<tr><td><a href="<var $self>/reports/<var $filename>"><var $title></a></td></tr>
</loop>
</tbody></table>
HERE

use constant REPORT_HEADER_INCLUDE => <<'HERE';
<table class="generic-table-monowidth">
<tbody>
<tr><th>Query</th><td><tt><var $query></tt></td></tr>
<tr><th>Updated</th><td><var ucfirst time_period_after($last,6)>. Next update <var time_period_before($next,6)></td></tr>
<tr><th>Actions</th><td>[<a href="<var $self>/actions/update-report/<var $name>">Update</a>]</td></tr>
</tbody></table>
HERE

use constant REPORT_THUMBS_INCLUDE => <<'HERE';
<div class="report-thumbs">

<loop $entries>
	<div><table><tbody>
	
	<loop $values>
		<if $type eq "thumb">
			<tr><td><a href="<var $self>/image/<var $hash>"><img src="<var $file>" alt="<var $file>" /></a></td></tr>
		</if>
		<if $type eq "text">
			<tr><td>
			<if $subtype eq "code"><tt></if>
			<var $name>: <var $text>
			<if $subtype eq "code"></tt></if>
			</td></tr>
		</if>
	</loop>
	
	</tbody></table></div>
</loop>

</div>
<hr />
HERE

use constant REPORT_TABLE_INCLUDE => <<'HERE';
<table class="generic-table"><tbody>
<tr>
<loop $rows>
	<th><var $_></th>
</loop>
</tr>
<loop $entries>
	<tr>
	
	<loop $values>
		<if $type eq "thumb">
			<td><a href="<var $self>/image/<var $hash>"><img class="report-thumb-image" src="<var $file>" alt="<var $file>" /></a></td>
		</if>
		<if $type eq "text">
			<td>
			<if $subtype eq "code"><tt></if>
			<var $text>
			<if $subtype eq "code"></tt></if>
			</td>
		</if>
	</loop>
	
	</tr>
</loop>
</tbody></table>
<hr />
HERE

use constant REPORT_GRAPH_INCLUDE => <<'HERE';
<div style="text-align: center;"><img src="<var IMAGES_LOCATION_HTTP."/graphs/$board_name/$name.png">" alt="<var $name>" /></div>
<hr />
HERE

1;