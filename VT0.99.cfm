ValidateThis 0.99 - Goodies for ColdBox, Debugging and More

I promised <a href="http://www.aliaspooryorik.com/" target="_blank">John Whish</a> that we'd have another version of <a href="http://www.validatethis.org/" target="_blank">ValidateThis</a>, 
an awesome validation framework for ColdFusion, out in time for <a href="http://www.scotch-on-the-rocks.co.uk/index.cfm/main/presentation/by/john_whish" target="_blank">his presentation</a> 
at <a href="http://www.scotch-on-the-rocks.co.uk/" target="_blank">Scotch on the Rocks</a> on March 4th, 2011, and I've never been one to disappoint. 
So today I announce the release of version 0.99 of ValidateThis.</p>
<p>The lion's share of the work on this release was done by John, <a href="http://adamdrew.me/blog/" target="_blank">Adam Drew</a> and myself. 
A lot of the work in this release is actually building towards something very cool that will come out later in the year, but there are still some significant enhancements including:
<ul>
	<li>Goodies for ColdBoxers including a ColdBox interceptor and three new sample applications.</li>
	<li>New debugging features to make it easier to figure out what's going wrong when things aren't working as you expect.</li>
	<li>The ability to ignore a validation client-side.</li>
	<li>Support for onMissingMethod in your objects.</li>
	<li>JavaScript assets are now retrieved from a CDN or written to the browser so you don't need to place JS files in a web accessible folder.</li>
	<li>Updates to the addFailure() method.</li>
	<li>A couple of new validation types were added.</li>
</ul>
</p>
<p>As always, the latest version can be downloaded from <a href="http://validatethis.riaforge.org/" target="_blank">the ValidateThis RIAForge site</a>.  Details of the enhancements follow:<more/>
<h3>ColdBox Goodies</h3>
<p>Not knowing much about ColdBox myself, I've left this area in the capable hands of John and Adam and they've come up with some pretty cool stuff.</p>
<p>The framework now ships with a ColdBox interceptor that allows you to incorporate VT into your CB app. 
It will make use of resource bundles that you've already defined in your CB app to do i18n for validations.
Demos are available for a simple ColdBox app, a ColdBox app with i18n support, and a ColdBox app that uses a module.
Documentation on <a href="http://www.validatethis.org/docs/wiki/Integrating_VT_with_ColdBox.cfm" target="_blank">using VT and CB together</a> can be found on the <a href="http://www.validatethis.org/docs/" target="_blank">VT wiki</a>.
Note that the ColdBox interceptor deprecates the ColdBox plugins that used to ship with the framework.</p>
<h3>Debugging Features</h3>
<p>Debugging features were requested by some VT users and we thought they were a good idea so they've been added.</p>
<p>There is a new key in the ValidateThisConfig struct called debuggingMode, which can be set to one of three values:
<ul>
	<li><em>none</em>, which is the default does not enable any debugging behaviour.</li>
	<li><em>info</em>, turns on debugging for server-side validations and also will log an error if your xml file does not validate against the ValidateThis xsd.</li>
	<li><em>strict</em>, turns on debugging for server-side validations and also will throw an exception if your xml file does not validate against the ValidateThis xsd.</li>
</ul>
</p>
<p>If you use the <em>info</em> or <em>strict</em> modes, then after performing server-side validations you can see the debugging info by calling the <em>getDebugging()</em>
method on the <em>Result</em> object.</p>
<h3>Ignoring Form Fields</h3>
<p>A couple of times the issue has come up where a user would like to have some hidden form fields not be validated. We discussed a number of different approaches to this and 
Adam came up with a fantastic solution. Now, if you want VT to ignore a field on your form you simply add the class <em>ignore</em> to it and it will not get validated.</p>
<h3>Support for onMissingMethod in Your Objects</h3>
<p>The framework can now deal with the use of onMissingMethod in your business objects. You can use onMM for getters, as well as for methods to satisfy a custom validation type or
a dynamic parameter.</p>
<h3>No Need to Worry About JavaScript Assets</h3>
<p>In the past you had to copy certain assets into a web-accessible folder in order to load them into the browser. 
We are now retrieving jQuery and the jQuery Validation plugin from a CDN, and streaming some additional js that was in a file directly to the browser, so you don't need to copy
any files anywhere anymore.</p>
<h3>Updates to the API of the addFailure() Method</h3>
<p>You can manually add a validation failure in your code by calling the <em>addFailure()</em> method on the <em>Result</em> object. 
This method accepted a single argument which was a struct that contained keys to copy into the failure. We've made the API more specific now, so it accepts the following arguments, all of which are optional:
<ul>
	<li><em>failure</em>, a struct which is used as a basis for the failure. This was kept as the first argument to maintain backwards compatibility. Any values in this struct will override any values set specifically.</li>
	<li><em>propertyName</em>, the name of the property that caused the failure.</li>
	<li><em>clientFieldName</em>, the name of the form field that caused the failure, defaults to the value of <em>propertyName</em>.</li>
	<li><em>type</em>, the type of validation that caused the failure.</li>
	<li><em>theObject</em>, the object that was being validated.</li>
	<li><em>objectType</em>, the type of object that was being validated.</li>
</ul>
</p>
<p>In addition to updating the API, when you call <em>addFailure()</em> it automatically sets success=false on the <em>Result</em> object.</p>
<h3>New Validation Types</h3>
<p><strong><a href="http://www.validatethis.org/docs/wiki/Validation_Types_Supported_By_ValidateThis.cfm#MinPatternsMatch" target="_blank">MinPatternsMatch</a></strong></p>
<p>The <em>MinPatternsMatch</em> type (which was renamed from <em>Patterns</em> and was contributed by <a href="http://blog.mxunit.org/" target="_blank">Marc Esher</a>) ensures that the contents of a property matches a minimum number of patterns.
This can be used, for example, to ensure that a password property conforms to certain standards. For example, a password could require at least 3 of the following:
<ul>
	<li>An uppercase character</li>
	<li>A lowercase character</li>
	<li>A number</li>
	<li>A punctuation character</li>
</ul></p>
<p><strong><a href="http://www.validatethis.org/docs/wiki/Validation_Types_Supported_By_ValidateThis.cfm#Time" target="_blank">Time</a></strong></p>
<p>The <em>Time</em> type ensures that the contents of a property is a valid time that falls between 00:00 and 23:59.</p>
<p>Once again, the latest code is available from <a href="http://validatethis.riaforge.org/" target="_blank">the ValidateThis RIAForge site</a>, and if you have any questions about the framework, or suggestions for enhancements, please send them to the <a href="http://groups.google.com/group/validatethis" target="_blank">ValidateThis Google Group</a>.
I'd also like to again thank Adam and John for their contributions to the framework.</p>
