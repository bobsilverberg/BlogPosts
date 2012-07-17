ValidateThis 0.85 - The All Request Edition

I've just released version 0.85 of ValidateThis, my validation framework for ColdFusion objects, and it contains a bug fix and a number of enhancements that were requested by users via the <a href="http://groups.google.com/group/validatethis" target="_blank">ValidateThis Google Group</a>.  Here's a summary of the changes, followed by the details for each one.  <strong>Please note</strong> that one of these changes (changes to the getInitializationScript() method) may break backward compatibility if you are currently using that method.
<ul>
	<li>The definitionPath setting can specify either a physical path or a relative path from the web root or mapping.</li>
	<li>Rule definition xml files are now allowed to be named .xml.cfm.</li>
	<li>Rule definition xml files can now be contained in a folder under the defined definitionPath folder with the same name as the object type.</li>
	<li>You can now specify multiple folders to search through to find your rule definition xml files.</li>
	<li>A new method, getFailuresAsString(), has been added to the Result.cfc object.</li>
	<li>A number of changes have been made to the getInitializationScript() method.</li>
	<li>A couple of enhancements have been made to the Coldbox plugin.</li>
	<li>Fixed a bug in ServerValidator.cfc that was causing conditions using non-numeric DependentPropertyValues to throw an error.</li>
</ul>
</p>
<p>The latest version can be downloaded from <a href="http://validatethis.riaforge.org/" target="_blank">the ValidateThis RIAForge site</a>.  Details of the changes follow:<more/>
<h3>Changes Affecting How the Framework Locates Your Rule Definition Xml Files</h3>
<p>The first four changes listed above all enhance VT's ability to locate your rule definition files.</p>
<p>First, when specifying the setting for definitionPath, you can either provide a complete physical path to the folder, or a relative path from either the web root or a CF mapping.</p>
<p>Second, VT will find your files if they either have the extension .xml or .xml.cfm.  Adding the .cfm at the end of the filename is a technique that some people use to hide their xml config files from people browsing their site.</p>
<p>Third, you now have the option of either placing your rule definition files directly into the folder specified in your definitionPath, or in a subfolder with the same name as the rule definition file. For example, if your definitionPath points to /model/, you can put your user.xml file into either /model/user.xml or /model/user/user.xml.</p>
<p>Finally, you now have the ability to specify multiple paths for VT to use when searching for rule definition files. You specify the paths, separated by commas, in the order in which you want them to be searched.</p>
<p>For example, you could set your definitionPath to "/myapp/model/,/common/model/", and if you ask VT to do something with a "user" object it will look for your rule definition file in the following folders, in the following sequence:</p>
<p>
/myapp/model/<br />
/myapp/model/user/<br />
/common/model/<br />
/common/model/user/<br />
</p>
<p>This will allow you to have common rule definition files which could be shared between applications, and yet override those rule definition files for a particular application if you wish.</p>
<h3>New getFailuresAsString() Method</h3>
<p>This is a method that was written by <a href="http://www.onthebubble.com.au/" target="_blank">Craig McDonald</a> as part of his Coldbox integration and I liked it so much I've included it in the framework. It allows you to get back all validation failure messages as a single string. The method accepts two arguments:
<ul>
	<li><em>delim</em>, which is the delimiter to place between the failure messages.  It defaults to a &lt;br/&gt; tag.</li>
	<li><em>locale</em>, which one would pass in for i18n.</li>
</ul>
</p>
<p>Craig was using this method to quickly populate a Coldbox MessageBox, like so:
<code><cfset getPlugin("messagebox").setMessage("warning", "There following validation errors occurred: #result.getFailuresAsString()#")></code>
</p>
<h3>Changes to the getInitializationScript() Method</h3>
<p>A number of changes have been made to the getInitializationScript() method.  This method started off as a convenience method, and I wasn't sure how useful it would be, but it now seems like it's being used and therefore needs a bit of love. In order to make the changes I first had to change the signature of the method, which, as I mentioned at the top of the post, could break backward compatibility if you're currently using it. So please test your code after upgrading.</p>
<p>The method used to accept the following arguments, in the following order:
<ul>
	<li><em>Context</em></li>
	<li><em>formName</em></li>
	<li><em>JSLib</em></li>
	<li><em>locale</em></li>
</ul>
</p>
<p>And it now accepts the following arguments, in the following order:
<ul>
	<li><em>JSLib</em> - the name of the JavaScript client implementation to use. This defaults to "jQuery", which is the only implementation that currently exists.</li>
	<li><em>JSIncludes</em> - a boolean value which specifies whether the routine should return the JS statements for including the required JS libraries. The default value is true.</li>
	<li><em>locale</em> - for i18n purposes, one can optionally pass in a locale.</li>
</ul>
</p>
<p>Using the new <em>JSIncludes</em> argument, one can choose to load the required JS libraries manually, rather than asking the framework for the code to do that.</p>
<p>A result of these changes is that the getInitializationScript() method can now be called via the ValidateThis.cfc facade without having to specify an object type.  This makes sense as the framework does not need a specific Business Object Validator in order to generate the common initialization script.</p>
<h3>Changes to the Coldbox Plugin</h3>
<p>If no definitionPath is specified via a VT_definitionPath setting, VT will first look in the Coldbox ModelsPath for your rule definition files, and then in the ModelsExternalLocationPath.</p>
<p>I added a method called setupValidationSI() which uses the scriptInclude plugin to load JS into the page. It accepts the following arguments:
<ul>
	<li><em>objectList</em> - a list of object type names for which validations are to be generated. At least one object type must be passed in.</li>
	<li><em>context</em> - an optional context to be used to determine the validation rules.</li>
	<li><em>locale</em> - for i18n purposes, one can optionally pass in a locale.</li>
	<li><em>formName</em> - if one wishes to override the default form name, one can be passed in.</li>
	<li><em>loadMainLibrary</em> - a boolean value which specifies whether the jQuery library should be loaded. This defaults to false, as it is fairly common to already have the jQuery library loaded.</li>
</ul>
</p>
<p>This method is based on code written by <a href="http://www.onthebubble.com.au/" target="_blank">Craig McDonald</a> in his own Coldbox Plugin.  I have not tested it yet as I do not have a sample set up with the scriptInclude plugin. I'm honestly not sure about including such implementation specific code in the plugin, but it seems like a very useful method, so I guess we'll see if it gets adopted, or if anyone has suggestions for improvements and/or changes to it.</p>
<p>I'd like to thank Craig and Adam Drew for their suggestions that have turned into enhancements, and also Alexander Sante for identifying the bug in the ServerValidator.cfc object.</p>
<p>Once again, the latest code is available from <a href="http://validatethis.riaforge.org/" target="_blank">the ValidateThis RIAForge site</a>, and if you have any questions about the framework, or suggestions for enhancements, please send them to the <a href="http://groups.google.com/group/validatethis" target="_blank">ValidateThis Google Group</a>.</p>
