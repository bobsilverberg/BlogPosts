Update to Using ColdFusion to Create a Twitter/Google Maps Mashup

That's what I get for banging something out in a couple of hours, and not RTFMing. It turns out that you <em>can</em> get a user's friends via the Twitter API without authenticating. It's just that the ColdFusion Twitter Lib doesn't currently support it. So I made one small change to a method in the library (sorry Pedro), allowing me to request a user's friends without authentication, and changed my code and demo.</p>
<p>So you can now feel safe running <a href="http://www.silverwareconsulting.com/CFTwitMap/CFTwitMap.cfm" target="_blank">the demo</a>.</p>
<p>I discovered a couple of other new things, when I took the time to dig a bit deeper.</p>
<p>The first is that when you ask Twitter's API for a list of friends it will only return 100 at a time, so you need to do paging.</p>
<p>The second is that Google's Geocode API isn't keen on getting dozens of requests in a short period of time.  It was rejecting a lot of calls, and therefore the locations were not being reported and the markers were missing from the map.  The only way I could find around that, in the limited time that I've devoted to this, was to use ColdFusion's Sleep() function to wait between API calls. Of course that has slowed the whole thing down tremendously, but at least I'm getting more markers on the map.</p>
<p>The new code is attached to this post.</p>
