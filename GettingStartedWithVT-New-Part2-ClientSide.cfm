Getting Started with VT - Enabling Client-Side Validations

In the <a href="http://www.silverwareconsulting.com/index.cfm/2009/4/21/Getting-Started-with-VT--Redux--with-or-without-Transfer">previous post</a> in this series about getting started with ValidateThis!, my validation framework for ColdFusion objects, we looked at how to very quickly get up and running with the framework, and how to use it to perform server-side validations for our objects.  In this post we'll look at enabling client-side validations for those same business rules.</p>
<p>VT is designed to generate both server-side and client-side validations from a single set of business rules, so we don't have to do any additional coding for the validations themselves, all we have to do it a bit of set up, and then ask the framework for the JavaScript. Let's start with the set up.
<more/>
<h3>Step 1 - The JS Files</h3>
<p>By design, VT can support any JavaScript validation library, including one of your own making, but it currently ships with an implementation for a single validation library, the <a href="http://bassistance.de/jquery-plugins/jquery-plugin-validation/" target="_blank">jQuery Validation Plugin</a>. VT will generate JavaScript statements for all of your validations, and those statements will assume that a few JavaScript files have been loaded on your page. The following files are required to allow the jQuery Validation Plugin to work:
<ul>
	<li>jquery-1.3.2.min.js - the jQuery library</li>
	<li>jquery.validate.pack.js - the jQuery Validation Plugin</li>
	<li>jquery.field.min.js - the jQuery Field Plugin</li>
</ul>
</p>
<p>The latest versions of those files ship with VT and can be found in /ValidateThis/client/jQuery/js. So, you'll need to copy those files to a web accessible folder (e.g., /js/), if you don't already have a copy of them from whence they can be accessed.</p>
<h3>Step 2 - Load JavaScript Libraries</h3>
<p>As discussed above, those files need to be loaded into your web page.  You can do that manually, using code similar to this:
<code>
<script src="/js/jquery-1.3.2.min.js" type="text/javascript"></script>
<script src="/js/jquery.field.min.js" type="text/javascript"></script>
<script src="/js/jquery.validate.pack.js" type="text/javascript"></script>
</code>
</p>
<p>Or you can ask VT to load the files for you, using a convenience method.  Assuming you have access to VT in a variable, such as application.ValidateThis (as discussed in the <a href="http://www.silverwareconsulting.com/index.cfm/2009/4/21/Getting-Started-with-VT--Redux--with-or-without-Transfer">previous post</a>), you can simply call getInitializationScript(), passing in the objectType:
<code>
<cfhtmlhead text=
	"#application.ValidateThis.getInitializationScript(objectType='user.user')#"
/>
</code>
</p>
<p>VT will generate the code required to load all of the libraries for you, which cfhtmlhead then places into your head tag.</p>
 <h3>Step 3 - Ask VT to Generate the Validation JavaScript</h3>	
<p>Similar to the above, you can simply call getValidationScript(), passing in the objectType:
<code>
<cfhtmlhead text=
	"#application.ValidateThis.getValidationScript(objectType='user.user')#"
/>
</code>
</p>
<p>VT will generate individual JavaScript statements to implement all of your object's validations.</p>
<p>And it's as simple as that - your page will now provide client-side validations!</p>
<p>In the next post I'll look at some of the other validation types that are currently available in the framework.</p>
<p>As always, if you have any questions or interest in following the progress of VT, I invite you to join the <a href="http://groups.google.com/group/validatethis" target="_blank">ValidateThis! Google Group</a>.</p>