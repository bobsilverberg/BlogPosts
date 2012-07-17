Subversion Makes a Fool out of Me

I've had this ongoing problem with Subversion with one of my projects.  The set up with the client is far from ideal - here's how it works:</p>
<p>I have a Subversion repository for the code and I use it for all of my work.  When I'm ready to upload changes I export from Subversion and upload either the whole thing or just the changes if there are only a few.  Once the work is uploaded to the server the client can download view templates and make changes to them.  This allows them to make changes to the appearance of the site without having to bother/pay me.  We've been doing this for a few years so the client knows what they're doing and doesn't usually create problems.
<more/>
So, when I want to do any work on the site I need to download the view code from the server and first do an SVN commit to incorporate the client's changes.  For the past few months I've been encountering SVN errors when attempting to commit this work.  It doesn't happen all of the time, only on the occasional template.  The errors are usually something like:
<code>
Merge conflict during commit
svn: Commit failed (details follow):
svn: Your file or directory 'dspCart.cfm' is probably out-of-date
svn: The version resource does not correspond to the resource within the transaction. Either the requested version resource is out of date (needs to be updated), or the requested version resource is newer than the transaction root (restart the commit).
</code></p>
<p>This is very frustrating and usually can only be fixed by doing a fresh checkout of the code, neither Update nor Cleanup commands help.</p>
<p>This happened again a couple of days ago and I realized that there was a pattern.  The problem always occurred with templates in one particular view directory.  So, I visited the FTP server, navigated to that directory, and what do you think I found?  That's right, a damned .svn folder was there, on the server!  Somehow I had accidentally uploaded an entire folder, including the .svn folder from my dev machine, and then, when I downloaded the entire view folder, I was downloading that old, out-of-date .svn folder and overwriting the .svn folder on my local machine.  Boy did I feel like a bit of a fool.  I quickly deleted the .svn folder on the server and my problem was solved.</p>
<p>What's the moral of the story?  Well, first off, if I ever see weird errors like this again I know one place to check.  Secondly, I really should finally start using ANT to do this stuff as it will make thinks much quicker and will eliminate the possibility of this happening again.  I guess that's one more item on my always growing list of tools to learn and use.</p>
