Export Selenium-IDE Scripts in CFSelenium (ColdFusion) Format 

Hot on the heels of the <a href="http://www.silverwareconsulting.com/index.cfm/2011/2/22/Introducing-CFSelenium--A-Native-ColdFusion-Client-Library-for-SeleniumRC">release of CFSelenium</a>,
I have created a Firefox plugin that will allow you to export scripts from Selenium-IDE in <a href="http://github.com/bobsilverberg/CFSelenium" target="_blank">CFSelenium</a> format,
wrapped inside an <a href="http://mxunit.org" target="_blank">MXUnit</a> test case. The plugin is dead simple to use, simply add the extension to your installation of Firefox and
you'll see a new menu item in Selenium-IDE under <em>File - Export Test Case As...</em>, <em>Options - Format</em> and <em>Options - Clipboard Format</em>. 
The menu item is labelled <em>CFML (ColdFusion) Selenium RC (MXUnit)</em>. Choosing this menu item will translate your current test case into CFSelenium format, wrapped in an MXUnit test case.</p>
<p>The Firefox extension is available in the distribution at both <a href="http://github.com/bobsilverberg/CFSelenium" target="_blank">GitHub</a> and <a href="http://cfselenium.riaforge.org/" target="_blank">RIAForge</a>,
and will hopefully be made available at SeleniumHQ once it's found to be stable. I'm sure it could use some improvements, so please give it a try and let me know what you think of it.</p>
<p>I was able to create the Firefox extension by basically copying and modifying the source code for the <a href="http://adhockery.blogspot.com/2010/06/export-selenium-ide-scripts-for-grails.html" target="_blank">Grails Formatters</a> 
created by <a href="http://adhockery.blogspot.com/" target="_blank">Rob Fletcher</a>, so a big thank you goes out to him for making the job simple and painless.</p>
