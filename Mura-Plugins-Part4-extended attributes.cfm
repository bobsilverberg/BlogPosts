Extending Mura CMS with Plugins - Part IV - Using Extended Attributes

In the <a href="http://www.silverwareconsulting.com/index.cfm/2010/1/6/Extending-Mura-CMS-with-Plugins--Part-III--Configurable-Settings">previous post</a> in this series about
Extending <a href="http://www.getmura.com/" target="_blank">Mura CMS</a> (an open source ColdFusion CMS) with Plugins,
we looked at using plugin settings to make our plugin configurable by a Mura administrator. In that simple example, our plugin settings were used directly in our ouput. 
Although plugin settings can be useful in a number of scenarios, using them in that manner has a limitation, which is that you'll 
get the exact same output on each and every page that uses the plugin,
because the value of the setting is set via the Mura Admin and hence the plugin always uses that single value.</p>
<p>In this post we'll look at a different technique for making a plugin configurable, and this time we'll be able to configure the plugin
on a page-by-page basis, instead of having one global configuration setting.  We'll do this by assigning a value to an extended attribute of a page, 
and then direct our plugin to use that value. The first step, therefore, is to enable an extended attribute for a page, so we'll look at that first.<more/>When editing a page in the Mura admin, there's a tab labelled <em>Extended Attributes</em>. When you click on that tab for a standard page, you'll see a message stating:
<em>There are currently no extended attributes available.</em> In order to provide extended attributes for a page you need to use the <em>Class Extension Manager</em> to create
a <em>Page Sub Type</em> that extends the built-in Page class, and then add attributes to that new Sub Type.  Here is a step-by-step guide:
<ol>
	<li>Access the <em>Class Extension Manager</em> in order to create a <em>Page Sub Type</em>:
		<ol>
			<li>In the upper right-hand corner of the Mura Admin, point to <em>Site Settings</em> and choose <em>Edit Current Site.</em></li>
			<li>Click on the <em>Class Extension Manager</em> link immediately under the <em>Site Settings</em> header.</li>
		</ol>
	</li>
	<li>Add a <em>Page Sub Type</em> which can then be assigned to a Page:
		<ol>
			<li>Click on the <em>Add Class Extension</em> link.</li>
			<li>Choose a <em>Base Type</em>. In this example we are choosing <em>Page</em> because we want to add extended attributes to a Page.</li>
			<li>Enter a name for the <em>Sub Type</em>. In this example we'll enter "HelloPage" as this will be a type of page that can say hello.</li>
			<li>Click the <em>Add</em> button.</li>
		</ol>
	</li>
	<li>Add an <em>Attribute</em>:
		<ol>
			<li>Click on the <em>[Edit]</em> link beside the word <em>Default</em>. This will allow us to add an attribute to the Default attribute set.</li>
			<li>Click the <em>[Add New Attribute]</em> link. This will bring up a form which allow us to define our new attribute.</li>
			<li>Fill in the form. You must specify at least a <em>Name</em> for the attribute. Let's name this attribute "HelloName". You can leave the rest of the fields blank.
				The other fields on the form are used to define how the attribute will be presented to an administrator when editing a page.
				These fields are nearly identical to those available when defining settings for a plugin, so you can find more information on them
				in the <a href="http://www.silverwareconsulting.com/index.cfm/2010/1/6/Extending-Mura-CMS-with-Plugins--Part-III--Configurable-Settings">previous post</a> in the series that
				discussed plugin settings.</li>
			<li>Click the <em>Add</em> button. This will being you back to the <em>Manage Attributes Set</em> screen, and you should see your new attribute at the bottom with links to <em>[Edit]</em> and <em>[Delete]</em> beside it.</li>
		</ol>
	</li>
</ol>
</p>
<p>We now have a <em>HelloPage</em> Page Sub Type that can be assigned to a page, and it will allow us to specify a value for the <em>HelloName</em> extended attribute.
To do that, create a new page or edit an existing page. On the <em>Edit Content</em> screen, you'll see there's a select box labelled <em>Type</em>. 
When you click the select box you should now see an option labelled <em>Page / HelloPage</em>. 
Choose that option, which tells Mura that you want this page to use the HelloPage Sub Type that we just created. 
Now click the <em>Extended Attributes</em> tab and you should see a text box labelled <em>HelloName</em>. Enter your own name into the text box and then publish the page.
That page will now have your name assigned to the extended attribute <em>HelloName</em>. Next we have to tell our plugin to make use of that extended attribute.</p>
<p>As we did in the last article, we're going to add another display object to our plugin, which will make use of the extended attribute.
Let's do that by editing the <em>/plugin/config.xml</em> file.  Here's the new version:
<code><plugin>
	<name>Hello World Plugin Step 3</name>
	<package>HelloWorldPluginStep3</package>
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
		<displayobject name="Hello Page Message" 
			displayobjectfile="displayObjects/dspHelloPage.cfm"/>
	</displayobjects>
</plugin>
</code></p>
<p>Once again we changed the <em>name</em> and <em>package</em> elements to reflect the fact that this is a new plugin. 
Then we added a new <em>displayobject</em> element, <em>Hello Page Message</em>, which will be used to display a message based on the extended attribute assigned to a page.</p>
<p>Next we create that new display object. Here's what dspHelloPage.cfm will look like:
<code><cfoutput>
<h1>Hello Page</h1>
<p>Hello #Event.getContentBean().getValue("HelloName")#!</p>
</cfoutput></code></p>
<p>We get the <em>ContentBean</em> for the current page using the <em>getContentBean()</em> method of the <em>Event</em> object, and then ask for the value of the <em>HelloName</em>
extended attribute using the <em>getValue()</em> method. Install this plugin as you've done previously and add the <em>Hello Page Message</em> display object to a content area on the page
for which you entered your name into the <em>HelloName</em> extended attribute. When you browse to that page ou should now see the output of the plugin saying hello to you.
To use this same plugin display object on a different page to say hello to someone else, simply provide a different value for the <em>HelloName</em>
extended attribute on that page.</p>
<p>As with the other articles in this series, the usefulness of this particular example is questionable, but the technique of providing information to a plugin on a page-by-page basis
can be quite useful. For example, I'm using this technique in a plugin that generates catalog pages for an ecommerce site. The site administrator can specify a value in an 
extended attribute for a catalog page, and the plugin uses that value to ask the model for data for that particular catalog page. A display object in the plugin then formats the data and it is
presented on the page.</p>
<p>As always, the completed plugin is available as an attachment to this post.</p>

