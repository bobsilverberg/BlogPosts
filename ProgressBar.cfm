Adding a Dynamic jQuery Progressbar to the ColdFusion Twitter/Google Maps Mashup

Because my <a href="http://www.silverwareconsulting.com/CFTwitMap/CFTwitMap.cfm" target="_blank">ColdFusion driven Twitter/Google Maps Mashup</a> is so slow, I decided that it would be nice to have a dynamic progress bar, which updates the status as each of the user's friend's addresses are being looked up. I knew that the <a href="http://jqueryui.com/home" target="_blank">jQuery UI project</a> has a <a href="http://jqueryui.com/demos/progressbar/" target="_blank">Progressbar widget</a>, so I did a quick Google for "jQuery Progressbar ColdFusion", and, no big surprise, came across a <a href="http://www.coldfusionjedi.com/index.cfm/2009/2/26/jQuery-Progress-Bar-with-ColdFusion" target="_blank">blog post</a> by <a href="http://www.coldfusionjedi.com/" target="_blank">Ray Camden</a> on the topic. That was enough to get me started, but Ray didn't cover creating a dynamic progress bar that is updated by the currently running page.</p>
<p>I figured that I could build something using cfflush, and I was not mistaken. Here's a summary of what I did:
<more/>
<p>When the form is submitted I first load the required CSS and JS files, and then create a div for my Progressbar and Status message, after which I attach the Progressbar to the div.  Then I call cfflush to push all of that to the browser.
<code>
<cfoutput>
<link type="text/css" rel="stylesheet" href="jquery-ui-1.7.1.custom.css" />
<script src="jquery-1.3.2.js"></script>
<script type="text/javascript" src="ui.core.js"></script>
<script type="text/javascript" src="ui.progressbar.js"></script>
<div id="pb" style="width: 500px;"></div>
<div id="status" style="width: 500px;" align="center">Status: Asking Twitter for your friends...</div>
<script type="text/javascript">
   $("##pb").progressbar({value:0});
</script>
#RepeatString(" ",1000)#
</cfoutput>
<cfflush />
</code>
</p>
<p>Next I'm asking Google Geocode to look up the user's location, so I update the status:
<code>
<cfoutput>
<script type="text/javascript">
   $("##status").text("Status: Looking up your location...");
</script>
#RepeatString(" ",1000)#
</cfoutput>
<cfflush />
</code>
</p>
<p>Then I loop through all of the user's friends, trying to look up their location.  Note that this snippet is abridged to just show the status update code:
<code>
<cfloop array="#personArray#" index="friend">
	<cfset pbValue = Int((friendsToFind-myFriendsCount+1)/friendsToFind * 100) />
	... snip ...
	<cfoutput>
		<script type="text/javascript">
		   $("##status").text("Status: Looking up your friends locations - #pbValue#% complete...");
		   $("##pb").progressbar('option','value',#pbValue#);
		</script>
	</cfoutput>
	<cfflush />
</cfloop>
</code>
</p>
<p>This all works perfectly well on my dev machine, using Apache as the web server, but it didn't seem to work quite as well in my online demo. I did some googling and it seems that there are some issues with cfflush and IIS, which I am in the process of investigating.  Expect an update in the near future.</p>
<p>As always, the complete code for the mashup is attached to this post.</p>
