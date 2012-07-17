CFSelenium 1.4 - Starts and Stops Selenium-RC Java Server For You 

A new version of <a href="http://github.com/bobsilverberg/CFSelenium" target="_blank">CFSelenium</a> was recently released which includes
an enhancement contributed by <a href="http://blog.mxunit.org/" target="_blank">Marc Esher</a>. In previous versions you had to manually start and stop the 
Selenium-RC Java server, but in this latest version CFSelenium is smart enough to start it for you, in the background, if it is not already started.
You can also shut down the java server by calling the <i>stopServer()</i> method on the selenium.cfc component. This will only stop the Java server if CFSelenium
was the one that started it.</p>
<p>Marc also added a base test case for MXUnit which includes code to start and stop the server. The base test case is called CFSeleniumTestCase.cfc and the code
to both start the Selenium Java server, and to start a browser session is in the <i>beforeTests()</i> method. There is also code to stop the browser and stop the server in
the <i>afterTests()</i> method. This will allow all of your tests to run using the same browser session, which is much faster that starting a new browser session for each individual test.</p>
<p>To create a test case which is based on this new base test case, just extend it and add your own <i>beforeTests()</i> method which sets a variable for the base url for your tests and then calls
the <i>beforeTests()</i> method in the parent.  It will look something like this:
<code>component extends="cfselenium.CFSeleniumTestCase" {

	function beforeTests(){
		// set the base url for your tests
		browserURL = "http://github.com/";
		super.beforeTests();
	}

	function myTest() {
		// note that the variable selenium is available to you which refers to an instance of CFSelenium 
		selenium.open("/bobsilverberg/CFSelenium");
		assertEquals("bobsilverberg/CFSelenium - GitHub", selenium.getTitle());
		selenium.click("link=readme.md");
		selenium.waitForPageToLoad("30000");
		assertEquals("readme.md at master from bobsilverberg/cfselenium - github", selenium.getTitle());
	}
	
}
</code></p>
<p>If you want to use a browser other than the default (which is Firefox), you can also specify a value for the variable <em>browserCommand</em> which will control which browser is used.</p>
<p>The latest version is available via the <a href="http://cfselenium.riaforge.org/" target="_blank">CFSelenium RIAForge page</a> and via the <a href="http://github.com/bobsilverberg/CFSelenium" target="_blank">CFSelenium GitHub Project</a>.
The latter also includes a detailed <a href="https://github.com/bobsilverberg/CFSelenium/blob/master/readme.md" target="_blank">Readme file</a> which can help you get started using CFSelenium.</p>
