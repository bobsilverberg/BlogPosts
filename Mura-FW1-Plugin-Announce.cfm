Using the Mura FW/1 Connector Plugin

Several months ago <a href="http://patweb99.avatu.com/" target="_blank">Pat Santora</a> of <a href="http://www.blueriver.com/go/br/" target="_blank">Blue River</a> and I developed
a Mura plugin that would allow a developer to take an existing <a href="http://fw1.riaforge.org/" target="_blank">FW/1</a> application and deploy it within a Mura page.
I was interested in this as I saw a need for a lightweight framework that I could use for my plugins, and by coincidence Pat happened to be working on something similar. So
we joined forces and the <a href="http://www.getmura.com/index.cfm/app-store/plugins/fw1-connector-plugin/" target="_blank">FW/1 Connector Plugin</a> was born.</p>
<p>The plugin was finally released yesterday so I thought it prudent to author a post about how to use the plugin.</p>
<h3>Overview</h3>
<p>The FW/1 Connector plugin can be used to incorporate an FW/1 application into Mura. 
	Each plugin can be assigned to an individual FW/1 application. 
	As long as each FW/1 application has a unique applicationKey, you can have as many FW/1 applications running inside Mura as you please.
</p>
<h3>Requirements:</h3>
<p>
<ol>
	<li>
		The <a href="http://fw1.riaforge.org/" target="_blank">FW/1 framework.cfc</a> must be installed in a path that maps to <em>org.corfield</em>.
		You can do this via a mapping in the CF administrator or you can place the org.corfield folder in Mura's <em>requirements</em> folder.
	</li>
	<li>
		Your FW/1 application must also reside in a path mapped to CF. 
		Again, this can be accomplished via a mapping in the CF administrator or you can create a folder for your application in Mura's <em>requirements</em> folder.
	</li>
</ol>
</p>
<h3>Installing the Plugin</h3>
<p>Download the latest version of the plugin from the <a href="http://www.getmura.com/index.cfm/app-store/plugins/fw1-connector-plugin/" target="_blank">Mura App Store</a>, and 
install it via the Mura Administrator.</p>
<p>From the Mura admin screen, click on <em>Site Settings</em>, on the right-hand side of the yellow menu bar. You should see two tabs, <em>Current Sites</em> and <em>Plugins</em>.
Click the <em>Plugins</em> tab and you will see a list of any installed plugins, above which is a form that allows you to browse for a zip file on your local machine.
Choose a the file that you downloaded and click the <em>Deploy</em> button.
You'll see the Plugin Settings page for the FW/1 Connector Plugin. Provide values for the following settings:
<ol>
	<li>
		<strong>Plugin Name (Alias)</strong> - This is the name that you're going to give to this instance of the plugin. Remember that you can install multiple 
		instances of the plugin each of which can point to a different FW/1 application.
	</li>
	<li>
		<strong>FW/1 Application Key</strong> - This must be the same value as specified in <em>variables.framework.applicationKey</em> inside your FW/1 application.
	</li>
	<li>
		<strong>Mapping to your application</strong> - This is the dot notation mapping to your FW/1 application.  
		For example, if you placed your application into a folder called <em>myFW1App</em> in Mura's <em>requirements</em> folder, then the value of this setting would be <em>myFW1App</em>.
	</li>
	<li>
		<strong>FW/1 Event Name</strong> - This is the name of the URL or form variable used to specify the desired action in your FW/1 application.
		The default value in all FW/1 applications is <em>action</em>, but this can be overridden by specifying a value for <em>variables.framework.action</em>.
	</li>
</ol>
</p>
<p>Choose which sites you would like the plugin to be available to, and click <em>Update</em>. The FW/1 Connector plugin is now installed and ready to be used.</p>
<h3>Configuring your FW/1 Application to Work with the Plugin</h3>
<p>The following keys must be set in the <em>variables.framework</em> structure within the Application.cfc file of your application:
<ol>
	<li>
		<strong>applicationKey</strong> - This must be a unique value for each FW/1 application that you wish to embed, and must correspond to the <em>FW/1 Application Key</em> specified in the Plugin Settings as discussed above.
	</li>
	<li>
		<strong>base</strong> - This must be the path to the directory containing the layouts and views folders, either as a mapped path or a webroot-relative path (i.e., it must start with / and expand to a full file system path).
	</li>
</ol>
</p>
<h3>Using the <i>doEvent</i> Method</h3>
<p>You will use the plugin's <em>doEvent()</em> method to fire off events within your FW/1 application. It accepts the following two arguments:
<ol>
	<li>
		<strong>event</strong> - This is Mura's event object.
	</li>
	<li>
		<strong>action (optional)</strong> - This is the action to be passed to your FW/1 application via a URL variable. If not provided the default action of your FW/1 application will be called.
		<br /><strong>Note:</strong> This argument is actually mandatory for now, as there is currently an issue with Mura and FW/1's SES URL scheme.
		If that issue gets resolved (and I've submitted a patch for it) then this argument will be optional again.
	</li>
</ol>
</p>
<h3>Calling an FW/1 Event from within Mura</h3>
<p>
	As described above, you call an FW/1 event by calling the <em>doEvent()</em> method of the FW/1 plugin.
	The plugin itself will reside in Mura's <em>event</em> object, in a key with the same name as specified in the <em>FW/1 Application Key</em> setting.
</p>
<p>
	For example, if you used a value of <em>myFW1App</em> for the <em>FW/1 Application Key</em> setting, then the plugin would be accessible via <em>event.myFW1App</em>.
	This gives you access to the plugin, which allows you to call its <em>doEvent()</em> method as required. 
</p>
<p>
	The following are two examples of ways in which you might call an FW/1 event. Note that these examples assume that the value of the <em>FW/1 Application Key</em> setting is <em>myFW1App</em>:
<ol>
	<li>
		By using the Mura tag:<br />
		<pre>[mura]event.myFW1App.doEvent(event,'main.showLogin')[/mura]</pre>
	</li>
	<li>
		From within a cfm or component that has access to the Mura event:<br />
		<pre>event.myFW1App.doEvent(event,'main.showLogin')</pre>
	</li>
</ol>
</p>
<p>That's pretty much all there is to it. Now go forth and create plugins!</p>
