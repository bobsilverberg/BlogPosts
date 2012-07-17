Extending Mura CMS with Plugins - Part V - Handling Plugin Errors

Here's a quick Mura Plugin tip: You can handle errors in your plugin via an <em>onError()</em> event in your event handler. Here's what mine looks like:
<code><cffunction name="onError" output="true" returntype="any">
<cfargument name="event">

<cfif arguments.event.getConfigBean().getDebuggingEnabled()>
	<cfdump var="#arguments.event.getValue('error')#" />
<cfelse>
	<cfset arguments.event.getServiceFactory().getBean("MuraService").SendErrorEmail(arguments.event.getValue("error")) />
	<cfinclude template="../displayObjects/util/dspPluginError.cfm" />
</cfif>

</cffunction></code>
</p>
<p>What's going on in there? First I'm checking to see if debugging is enabled in the global config by checking the value of <em>event.getConfigBean().getDebuggingEnabled()</em>.
If debugging is enabled I want to display the information about the error on the page, so I'm dumping the contents of the <em>error</em> key from the event.
If debugging is not enabled, then I want to send an email to the site administrator, which is done by invoking a method on my <em>MuraService</em> object,
which is defined in my Coldspring config. After that I want to display a friendly error message to the user, so I simply include a template from the 
<em>displayObjects/util/</em> folder of my plugin. This allows the plugin itself to control what sort of message is displayed to a user when an error occurs.</p>
<p>Pretty simple, eh?</p>
