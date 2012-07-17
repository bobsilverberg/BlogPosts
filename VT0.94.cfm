ValidateThis 0.94 - More community contributions

I've just released version 0.94 of ValidateThis, my validation framework for ColdFusion objects. Once again this update includes community contributions, including
some from <a href="http://jamiekrug.com/blog/" target="_blank">Jamie Krug</a> and <a href="http://www.aliaspooryorik.com/" target="_blank">John Whish</a>.
Here's a summary of the changes, followed by the details for each one.
<ul>
	<li>A new <em>boolean</em> validation type has been added.</li>
	<li>Proper optionality is now supported for all validation types.</li>
	<li>The framework can locate your rules definition file with zero configuration when you pass an object into a method call.</li>
	<li>A <em>newResult()</em> method has been added to the ColdBox plugin.</li>
	<li>A <em>getFailureMessages()</em> method has been added to the Result object.</li>
	<li>An issue with overriding failure messages with the <em>custom</em> validation type has been addressed.</li>
</ul>
</p>
<p>The latest version can be downloaded from <a href="http://validatethis.riaforge.org/" target="_blank">the ValidateThis RIAForge site</a>.  Details of the enhancements follow:<more/>
<h3>New Boolean Validation Type</h3>
<p>Jamie Krug had a need for a boolean validation type in a project, so he went ahead and created one and contributed it back to the framework. Originally only the
server-side piece was implemented, so I solicited some help from the ValidateThis community to come up with a JavaScript function that could check whether a value
is a valid ColdFusion boolean. I received some feedback on this from Adam Drew, TJ Downes and John Whish. John's regex solution ended up as the clear winner.
I've included the code below in case anyone is interested, including a script that demonstrates the output:
<code><script type="text/javascript">
function isCFBoolean( value )
{
	if ( value==null )
	{
		return false
	}
	else 
	{
		var tocheck = value.toString();
		var pattern = /^((-){0,1}[0-9]{1,}(\.([0-9]{1,})){0,1}|true|false|yes|no)$/gi;
		return tocheck.match( pattern ) == null ? false : true;
	}
}

document.write('these can all be treated as boolean in CF<br />');

document.write(isBoolean('YES'));
document.write(isBoolean('True'));
document.write(isBoolean(true));
document.write(isBoolean('1'));
document.write(isBoolean(1));
document.write(isBoolean(2));
document.write(isBoolean('2'));
document.write(isBoolean('NO'));
document.write(isBoolean('false'));
document.write(isBoolean(false));
document.write(isBoolean('0'));
document.write(isBoolean(0));

document.write('<br />these can NOT be treated as boolean in CF<br />');

document.write(isBoolean({}));
document.write(isBoolean(null));
document.write(isBoolean('Foo'));
document.write(isBoolean(' TRUE '));
document.write(isBoolean(10));
document.write(isBoolean('10'));
document.write(isBoolean(' NO '));
document.write(isBoolean(' false '));
document.write(isBoolean(''));
document.write(isBoolean('{ts 2010-02-01}'));
</script></code></p>
<h3>Proper and Consistent Optionality</h3>
<p>In previous releases certain validation types were optional, meaning that the validation wouldn't fail if the property was left blank. This option was
implemented sporadically, so I wanted to address that. Now all validation types are optional by default, meaning that empty properties will not trigger a validation
failure. However, the framework is smart enough to know that if a property is also required (i.e., it has a rule defined on it with a type of <em>required</em>),
then the validation in question will be treated as mandatory. Perhaps that's a bit confusing, so let's look at an example.</p>
<p>Imagine an object with an <em>emailAddress</em> property, and the following rules defined:
<code><objectProperties>
	<property name="emailAddress">
		<rule type="email" />
	</property>
</objectProperties></code></p>
<p>If I were to place the value "bob" into the emailAddress property and then validate the validation would fail as "bob" is not a valid email address. I would
get a single validation failure saying "The Email Address must be a valid Email address." If, on the other hand, I were to store an empty string in the emailAddress
property, I would get no validation failures as the validation is treated as optional.</p>
<p>Let's change the rules for emailAddress to look like this:
<code><objectProperties>
	<property name="emailAddress">
		<rule type="required" />
		<rule type="email" />
	</property>
</objectProperties></code></p>
<p>I would get the identical single failure message if I were to place the value "bob" into the emailAddress property, 
but if I were to store an empty string in the emailAddress property, I would now get two validation failure messages:
<ol>
	<li>The Email Address is required.</li>
	<li>The Email Address must be a valid Email address.</li>
</ol></p>
<p>To sum up, a validation rule will be treated as optional, unless the property in question is required.</p>
<h3>Zero Configuration Locating of Rules Definition Files</h3>
<p>In previous releases of the framework you told VT where to find your rules definition files using the <em>definitionPath</em> key of the 
<a href="http://www.validatethis.org/docs/wiki/ValidateThisConfig_Struct.cfm" target="_blank">ValidateThis Config struct</a>. Over the course of developing the
framework this ability has been enhanced to support multiple paths, and there has always been a built-in default of <em>/model</em>. John Whish was interested in
removing the requirement to configure this location, particularly when the files may exist in multiple different locations. The demo for VT that uses Transfer
and integrates VT directly into the business objects is already designed to do this - it assumes that your rules definition files will be in the same folder
as your object cfcs, and it simply picks them up from there. That logic is coded into the demo, rather than being available in the framework, so I added a few
lines of code to support that.</p>
<p>Now, when you call a method on the framework into which you pass in the object to be validated (e.g., the <em>validate()</em> method), the framework will
first attempt to locate a rules definition file in the same folder as the cfc that defines the object. If it doesn't find one there, then it will search through
the definitionPaths to find one. So, if you choose to store your rules definition files alongside your cfcs, VT will be able to automatically locate those files
without requiring you to specify their location. For more information on how VT uses the definitionPath setting, 
take a look at the <a href="http://www.validatethis.org/docs/wiki/How_ValidateThis_Finds_Your_Rules_Definition_Files.cfm" target="_blank">ValidateThis Online Documentation</a>.</p>
<h3>New newResult() Method in the ColdBox Plugin</h3>
<p>Because the ColdBox plugin makes use of onMissingMethod, it was already possible to call <em>newResult()</em> on the plugin to get a new, empty Result object.
In order to make the API for the plugin more obvious, I had added a number of methods to it that could have simply been handled by onMissingMethod. To keep the
API up to date I have now added an explicit newResult() method.</p>
<h3>New newResult() Method in the ColdBox Plugin</h3>
<p>Because the ColdBox plugin makes use of onMissingMethod, it was already possible to call <em>newResult()</em> on the plugin to get a new, empty Result object.
In order to make the API for the plugin more obvious, I had added a number of methods to it that could have simply been handled by onMissingMethod. To keep the
API up to date I have now added an explicit newResult() method.</p>
<h3>New getFailureMessages() Method in the Result object</h3>
<p>Another suggestion from John Whish prompted me to add a <em>getFailureMessages()</em> method to the Result object. This method will return all validation failure messages
as an array of strings. I believe that John plans to use this in conjunction with ColdBox's MessageBox object to enhance the ColdBox plugin to return a configured
MessageBox.</p>
<h3>Overriding Failure Messages with the Custom Validation Type</h3>
<p>I'm guessing that this one will be meaningless to pretty much everyone, but I'm a stickler for documenting changes. I'll just sum it up
by saying that now, if you have a <em>custom</em> validation rule, and you've defined an explicit <em>failureMessage</em> for the rule, the framework will
override that message with any message that is generated by the method called for the custom validation. It was not doing that in the past, and I deemed that
a bug.</p>
<p>Once again, the latest code is available from <a href="http://validatethis.riaforge.org/" target="_blank">the ValidateThis RIAForge site</a>, and if you have any questions about the framework, or suggestions for enhancements, please send them to the <a href="http://groups.google.com/group/validatethis" target="_blank">ValidateThis Google Group</a>.
I'd also like to thank Jamie and John once again for their contributions to the framework.</p>

