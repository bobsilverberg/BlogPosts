You Need to be Using These Eclipse (and CFBuilder) Keyboard Shortcuts

OK folks, this is a big deal. I'm going to tell you about three keyboard shortcuts that you really need to incorporate into your routine. 
These are nothing new. Marc Esher <a href="http://blog.mxunit.org/2009/04/timesavers-common-eclipse-shortcuts.html" target="_blank">blogged about these</a> nearly a year ago,
and there's a good chance that you're already using them, and if so, you know how amazing they are. But if you're not using them then you're really missing out.</p>
<p>If you're like me at first glance they won't seem like a big deal. 
You'll think, "How often do I need to do that?" But if you get yourself into the habit of using them, you won't believe how much more pleasant your time spent coding in 
Eclipse will be. Enough of the sales pitch, let's get on with it.  The three shortcuts are:
<ul>
	<li>Command+Option+Up/Down (Ctrl+Alt+Up/Down on a PC) - copy the selected line(s) above or below themselves</li>
	<li>Option+Up/Down (Alt+Up/Down on a PC) - move the selected line(s) up or down</li>
	<li>Command+D (Ctrl+D on a PC) - delete the selected line(s)</li>
</ul>
</p>
<p>These commands blow cut/copy and paste out of the water. 
One of the best things about them is that you don't have to select an entire line to use them. Your cursor can be anywhere on the line(s) and it will work,
so you don't have to bother hitting the Home key to move to the beginning of a line to copy, move or delete it. 
If this still doesn't seem like not a big deal to you, let's walk through a quick exercise. Take the following code and copy it into a file in Eclipse:
<code><cfif something>
	do something
	that takes 2 lines of code
<cfelseif somethingElse>
	do something else
	that takes 2 lines of code
</cfif>

<cfif anotherTest>
	do something different again
	that takes 2 lines of code
<cfelse>
	do something completely different
	that takes 2 lines of code
</cfif></code></p>
<p>Let's say we want to add a similar cfelseif block into the second cfif block. Put your cursor anywhere on the existing cfelseif tag line and do shift+down x 2. 
You should now have part of the cfelseif line highlighted as well as all of the next line and part of the following line. 
Now do ctrl+alt+down. Your three lines of code have been duplicated immediately below the previously selected lines, and now <em>they</em> are selected.
Now do alt+down x 5. Voila, you've copied your cfelseif block right where you needed it in very few keystrokes, and only had to lift your fingers from the keyboard once.
Try that with copy and paste!</p>
<p>If you're still not with me on this one then I humbly suggest that you try doing it for a few days (or even just a few hours). Try to <em>force</em> yourself to use these shortcuts
anytime that you need to copy, move or delete a line or block of code.  I'm willing to bet you'll be hooked in very short order.</p>
<p>If you're wondering why I choose to blog about these now, I was inspired by a colleague.  I only started using these shortcuts a few weeks ago and was kicking myself that I hadn't
picked them up sooner. I was chatting with my friend and, somewhat , admitted that I had only started using them recently. "What do they do?" he asked. I was shocked that he too was not
benefitting from their incredible usefulness, so I figured I should write this up to share this tidbit with everyone. Enjoy! </p>
