ValidateThis 0.92 - Easier to Extend, More Object Support, and more

I've just released version 0.92 of ValidateThis, my validation framework for ColdFusion objects. I'm very pleased to say that I received a large code contribution from Adam Drew,
most of which made it into the framework. I also finally got around to adding <a href="http://www.aliaspooryorik.com/" target="_blank">John Whish</a>'s changes to the bundled ColdBox plugin. Here's a summary of all of the enhancements, followed by the details for each one.
<ul>
	<li>ServerRuleValidators can be located anywhere.</li>
	<li>Business objects with an abstract getter are now supported.</li>
	<li>New DependentFieldName parameter for conditional client-side validations.</li>
	<li>Fix to future-proof ColdBox plugin.</li>
	<li>Fixes for Groovy conditional validations.</li>
</ul>
</p>
<p>The latest version can be downloaded from <a href="http://validatethis.riaforge.org/" target="_blank">the ValidateThis RIAForge site</a>.  Details of the enhancements follow:<more/>
<h3>ServerRuleValidators Can be Located Anywhere</h3>
<p>It's always been possible to add your own validation types to the framework by creating your own ServerRuleValidators (SRVs). 
This allows you to add validation types that are either not bundled with the framework, or application-specific validation types (for example, an application-specific password
validation scheme, or a region-specific phone number format, etc.).
To do that you simply write a new SRV that extends the AbstractServerRuleValidator and then you place it into the framework's /server folder.
The framework will then pick it up automatically and it will be available to all of your objects.</p>
<p>Of course the downside to this is that you have to put your files into a folder that belongs to the framework - you cannot put them in a folder within your application
directory structure. Or perhaps I should say you <em>couldn't</em> do that - until now. One of the enhancements that Adam submitted allows for you to specify a location for your own
SRVs and then the framework will pick them up from there.  I spiced it up a bit by allowing you to specify a comma delimited list of locations, each of which will
be searched for SRVs. This would allow you to have a common folder with SRVs that serve multiple applications, as well as a folder within each application
that could contain application-specific SRVs.</p>
<p>When the framework loads SRVs it will start with any that it finds in its own /server folder. Then, if you have specified one or more locations in a new ValidateThisConfig
parameter called <em>ExtraRuleValidatorComponentPaths</em>, it will go through each of those locations, in order, loading the SRVs that it finds.  
If it finds an SRV that is already loaded the new SRV will override the existing SRV. This allows you not only to add your own SRVs, but you can even override the framework's
built-in SRVs by creating your own with the same name.  It also means that if you have two locations, one for common SRVs and one for application-specific SRVs, the application-specific
SRVs will override the common SRVs if you place that folder at the end of the list.</p>
<p>Adam has also written a number of new SRVs that I think he plans on making available to any users of VT. If he's happy to donate them I may add them to the built-in
SRVs that currently ship with the framework. If anyone else has created their own SRV and wants to share it, please send it my way.</p>
<h3>Business Objects with Abstract Getters Now Supported</h3>
<p>When I first developed VT I was using Transfer, which exposes getters for each of your object's properties.
Now I'm also using it with CF9 ORM, which again exposes getters. Some people choose to write business objects (BOs) which don't have getters for each property.
Instead they have an <em>abstract getter</em>, such as a getProperty() method. If you want to get the value of the <em>firstName</em> property, instead of calling
<em>getFirstName()</em>, you'd have to call <em>getProperty("firstName")</em>. Because VT relied on getters, it wouldn't work with these types of business objects.</p>
<p>Adam Drew decided that he wanted to use VT with objects that use an abstract getter, so he submitted a patch for that as well.
There is now a new ValidateThisConfig parameter called <em>abstractGetterMethod</em>. You simply pass the name of your abstract getter into that parameter when configuring the
framework and it will then use that method to determine the value of each of your object's properties.</p> 
<h3>New DependentFieldName XML Parameter</h3>
<p>When <a href="http://www.henke.ws/" target="_blank">Mike Henke</a> was testing out his new ValidateThis / ColdFusion on Wheels demo app he encountered an issue
with the way Wheels names its form fields that was messing with the jQuery that I was generating for conditional validations. Conditional validations allow you to 
set up rules like "The Last Name is required if a First Name has been provided" and "A Communication Method is required if the user chooses 'yes' to Allow Communication".
In order to address the issue, which boiled down to the fact that while the <em>id</em> attribute of the input tag was <em>FirstName</em>, the <em>name</em>
attribute of the tag was <em>User[FirstName]</em>. To address this issue, which admittedly could come up on any form field - it's not specifically a problem
with Wheels, I have added support for a new parameter that can be used to tell the framework the name of the form field which should be used in the condition.
The new parameter is called <em>DependentFieldName</em>. Here's an example of how you would set up a rule saying that the LastName is required if a value has
been provided for the FirstName, assuming the form field is named <em>User[FirstName]</em>:
<code><property name="LastName" desc="Last Name">
	<rule type="required">
		<param DependentPropertyName="FirstName" />
		<param DependentFieldName="User[FirstName]" />
	</rule>
</property></code></p>
<p>Note that you have to specify the <em>DependentPropertyName</em> as <em>FirstName</em> as that's the actual name of the property and the server-side validations need to know that.
You only need to provide a value for <em>DependentFieldName</em> if the actual <em>name</em> attribute of the form field is not also <em>FirstName</em>.
</p>
<h3>Future-Proofing the ColdBox Plugin</h3>
<p>Currently the ColdBox plugin is using the ColdBox setting <em>ModelsExternalLocationPath</em> to look for xml files. I was informed by John Whish that that setting has
been deprecated in ColdBox 3, and he was also nice enough to submit a patch to address the issue. Now the plugin won't break if you try to use it with CB3.</p>
<h3>Fixes for Groovy Conditional Validations</h3>
<p>You can now do the same type of conditional validations that I described above on Groovy objects. My initial testing didn't include those use cases, so I had to add a bit
of code to this release to make it all work.</p>
<p>Once again, the latest code is available from <a href="http://validatethis.riaforge.org/" target="_blank">the ValidateThis RIAForge site</a>, and if you have any questions about the framework, or suggestions for enhancements, please send them to the <a href="http://groups.google.com/group/validatethis" target="_blank">ValidateThis Google Group</a>.
I'd also like to thank Adam and John once again for their contributions to the framework.</p>

