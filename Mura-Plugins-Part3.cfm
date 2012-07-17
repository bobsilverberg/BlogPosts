Extending Mura CMS with Plugins - Part III - Configurable Settings

I'm continuing my series on Extending <a href="http://www.getmura.com/" target="_blank">Mura CMS</a> (an open source ColdFusion CMS) with Plugins, after a long hiatus,
 by looking at adding configurable settings to a plugin.
 In the <a href="http://www.silverwareconsulting.com/index.cfm/2009/8/4/Extending-Mura-CMS-with-PlugIns--Part-II--Hello-World">previous post</a> we looked at creating a simple
 Hello World plugin and also looked at how we could place the output of that plugin on a page in our Mura site.</p>
<p>As you may recall, all that plugin did was output the text "Hello World!" inside an h1 tag. That's not particularly useful, so let's make it a bit more interesting.
How about we allow the person managing the Mura site to decide whom we should greet and what that greeting should be?  
We're going to do that by adding a couple of settings to our plugin. In order to add those settings we're going to have to make a few changes to our plugin's configuration, which
we do by editing the <em>/plugin/config.xml</em> file.  Let's take a look at out new version:<more/><code><plugin>
	<name>Hello World Plugin Step 2</name>
	<package>HelloWorldPluginStep2</package>
	<version>1.0</version>
	<provider>SilverWare Consulting</provider>
	<providerURL>http://www.silverwareconsulting.com</providerURL>
	<category>Sample Application</category>
	<settings>
		<setting>
			<name>toWhom</name>
			<label>We are speaking to</label>
			<hint>The name of the person to whom we're speaking</hint>
			<type>text</type>
			<required>true</required>
			<validation></validation>
			<regex></regex>
			<message></message>
			<defaultvalue></defaultvalue>
			<optionlist></optionlist>
			<optionlabellist></optionlabellist>
		</setting>
		<setting>
			<name>sayWhat</name>
			<label>We are going to say</label>
			<hint>This is what we are going to say to them</hint>
			<type>select</type>
			<required>true</required>
			<validation></validation>
			<regex></regex>
			<message></message>
			<defaultvalue>Hello</defaultvalue>
			<optionlist>Hello^Goodbye</optionlist>
			<optionlabellist></optionlabellist>
		</setting>
	</settings>
	<displayobjects location="global">
		<displayobject name="Hello World Message" 
			displayobjectfile="displayObjects/dspHelloWorld.cfm"/>
		<displayobject name="Greeting Message" 
			displayobjectfile="displayObjects/dspGreeting.cfm"/>
	</displayobjects>
</plugin></code></p>
<p>Let's review the changes. First we changed the <em>name</em> and <em>package</em> elements to reflect the fact that this is a new plugin. 
Next we added two settings to the <em>settings</em> element: <em>toWhom</em>, which will be used to store the name of the person that we will be greeting, and
<em>sayWhat</em>, which will be used to store the greeting to use. Here's a rundown of all of the elements available for each setting:
<ul>
	<li><em>name</em> - The name of the setting, which you will use in code that needs to know the value of the setting.</li>
	<li><em>label</em> - The label to display for the setting on the Plugin Settings page.</li>
	<li><em>hint</em> - The hint to display for the setting on the Plugin Settings page.</li>
	<li>
		<em>type</em> - The type of control to present to an administrator for the setting on the Plugin Settings page. 
		Valid values are: Text, TextBox, TextArea, Select, SelectBox, MultiSelectBox, Radio, RadioGroup. 
	</li>
	<li><em>required</em> - Is a value required when updating the plugin via the Plugin Settings page?</li>
	<li>
		<em>validation</em> - What sort of validation should be performed when an administrator changes the setting via the Plugin Settings page? 
		Valid values are: "" (empty string - meaning no validation), Date, Numeric, Email, Regex.
	</li>
	<li><em>regex</em> - The regex to be used when the validation type is "Regex".</li>
	<li><em>message</em> - The message to display if the validation fails.</li>
	<li><em>defaultvalue</em> - The default value to present on the Plugin Settings page if no value has been specified for the setting.</li>
	<li>
		<em>optionlist</em> - A list of options to present to an administrator for the option.
		This is used with the Select, SelectBox, MultiSelectBox, Radio, and RadioGroup types.
		The list items should be delimited with a caret (^) symbol.
	</li>
	<li><em>optionlabellist</em> - An optional list of labels that correspond the list of options specified in <em>optionlist</em>.</li>
</ul></p>
<p>We also added a new <em>displayobject</em> element which will be used for our new configurable greeting.
After adding the two settings above and the new displayobject, when we install our new plugin the Plugin Settings page for it should look something like this:</p>
<img src="/images/MuraPlugin-III.jpg" class="float=left" />
<p>Now all we have to do is tell our new display object to use those settings. Here's what dspGreeting.cfm will look like:
<code><cfoutput>
<h1>Greeting</h1>
<p>#pluginConfig.getSetting("sayWhat")# #pluginConfig.getSetting("toWhom")#!</p>
</cfoutput></code></p>
<p>We simply use the <em>getSetting()</em> method of the <em>pluginConfig</em> object (which is available in the variables scope of your display template) to retrieve the settings that
were specified via the Plugin Settings page. Now, when we add the <em>Greeting Message</em> display object to a page (as was described in the <a href="http://www.silverwareconsulting.com/index.cfm/2009/8/4/Extending-Mura-CMS-with-PlugIns--Part-II--Hello-World">previous post</a>),
we'll see a message saying either Hello or Goodbye to whomever we specified in the settings for the plugin.</p>
<p>There you have it - a user-configurable plugin.  Still not a very useful plugin, I'll admit, but a bit more interesting than the pervious version.</p>

