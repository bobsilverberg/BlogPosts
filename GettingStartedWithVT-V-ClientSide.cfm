Getting Started with VT and Transfer - Part V - Enabling Client-Side Validations

In the <a href="http://www.silverwareconsulting.com/index.cfm/2009/3/21/Getting-Started-with-VT-and-Transfer--Part-IV--Using-VT-for-ServerSide-Validations">previous post</a> in this series about getting started with Transfer and ValidateThis!, my validation framework for ColdFusion objects, we looked at implementing a couple of server-side validations using the framework. In this post we'll look at enabling client-side validations for those same business rules.</p>
<p>VT is designed to generate both server-side and client-side validations from a single set of business rules, so you'll see that all we need to do is add a few lines of code to our form page and our client-side validations will be enabled:
<code>
<cfhtmlhead text="#UserTO.getInitializationScript()#" />
<cfhtmlhead text="<script src='js/custom.js' type='text/javascript'></script>" />
<cfhtmlhead text="#UserTO.getValidationScript()#" />
</code>
</p>
<p>We'll take a look at each line:
	<ol>
		<li>VT includes a method that will return all of the JavaScript code required to load and set up the required JavaScript libraries. That is what the call to <em>UserTO.getInitializationScript()</em> is doing.</li>
		<li>The next line of code is not part of the framework and is not required to enable validations. It simply includes a JavaScript file that is required to make the sample form look the way it does. Basically, if you need to do any custom set up of the jQuery validation plugin you can do so by including your own JavaScript like this.</li>
		<li>The final line is asking VT to return JavaScript statements that implement all of the business rules defined for our User Business Object.</li>
	</ol>
</p>
<p>As you can see each of the JavaScript blocks are loaded into the head of the page via the cfhtmlhead tag.</p>
<p>And it's as simple as that - our page will now provide client-side validations!</p>
<p>You can see a demo of this version of the sample application in action at <a href="http://www.validatethis.org/VTAndTransfer_PartIII/" target="_blank">www.validatethis.org/VTAndTransfer_PartIII/</a>.  As always all of the code for this version of the sample application can be found attached to this post.</p>
