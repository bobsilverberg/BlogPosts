CF9 ORM and Tomcat

I've set up my local development environment to run my CFML engines under <a href="http://tomcat.apache.org/" target="_blank">Tomcat</a>. Thanks to <a href="http://mattwoodward.com/blog/" target="_blank">Matt Woodward</a> for his <a href="http://mattwoodward.com/blog/index.cfm?event=showEntry&entryId=03233F6F-ED2C-43C7-AFF5FA2B3C3D845B" target="_blank">thorough blog post</a> and additional help it wasn't too onerous a setup.  This allows me to easily run multiple CFML engines (e.g., CF8, CF9, Railo and OpenBD) simultaneously.  I just ran into a problem trying to use ColdFusion 9's ORM features under this setup, and that's what the remainder of this post is about.
</p>
<p>When trying to test some of CF9's ORM features I ran into a strange problem. Whenever I called a function that interacted with Hibernate I would just get a blank screen returned to me.  No ColdFusion error message, no output, just a blank screen.  This was a bit difficult to debug, but when I checked ColdFusion's application.log I saw an error message.  It said:
<code>javax/transaction/Synchronization The specific sequence of files included or processed is: /Applications/tomcat/webapps/cfusion9/index.cfm, line: 10</code>
</p>
<p>Thanks to an email from <a href="http://daveshuck.instantspot.com/blog/" target="_blank">Dave Shuck</a> to a forum, I saw that someone else was experiencing a similar problem. It had to do with a some JEE functionality that is missing from Tomcat. Thanks to some additional information from <a href="http://www.elliottsprehn.com/blog/" target="_blank">Elliott Sprehn</a> and <a href="http://coldfused.blogspot.com/" target="_blank">Rupesh Kumar</a> I was able to locate and install the jar file required, after which everything worked.</p>
<p>Here are some step-by-step instructions on how to fix this issue:
<ol>
	<li>
		Download the latest copy of the JTA classes from Sun.
		<ol>
			<li>Browse to <a href="http://java.sun.com/javaee/technologies/jta/index.jsp" target="_blank">http://java.sun.com/javaee/technologies/jta/index.jsp</a></li>
			<li>Under <strong>Downloads</strong>, click on the first <em>Download</em> button for class files.  Currently that button follows a label for <em>Class Files 1.1</em>, and takes you to a page titled <em>Java Transaction API Classes 1.1 </em>.</li>
			<li>Check the box labelled <em>I agree to the  Software License Agreement</em>, and click the <em>Continue</em> button.</li>
			<li>Click on the filename, which is currently <em>jta-1_1-classes.zip</em>.  I do not recommend using Sun's Download Manager, as it involves a few extra steps.  Simply clicking on the filename should allow you to download the zip file to your machine.</li>
		</ol>
	</li>
	<li>
		Copy the downloaded file into ColdFusion's <em>lib</em> folder. On my machine (OS X) that's at <em>/Applications/tomcat/webapps/cfusion9/WEB-INF/lib/</em>.
	</li>
	<li>
		Rename the file from <em>jta-1_1-classes.zip</em> to <em>jta-1_1-classes.jar</em>.
	</li>
	<li>
		Restart Tomcat (or you can probably just restart the CF9 webapp from Tomcat's manager), and you're good to go.
	</li>
</ol>
</p>
