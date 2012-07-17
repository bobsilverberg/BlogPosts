Getting Started with VT - Redux - with or without Transfer

Now that I've made ValidateThis!, my validation framework for ColdFusion objects, really easy to integrate into an existing application, I'm starting a new series about Getting Started with VT. The information covered is applicable regardless of whether you are using Transfer or not.  In this first post I'm going to cover setting up VT using the new ValidateThis.cfc service object, creating a couple of validation rules, and implementing server-side validations for those rules.  This is kind of a redux of the first few posts in my getting Started with VT and Transfer series, so I will be covering some familiar ground.</p>
<p>OK, let's get started.
<more/>
<h3>Step 1 - Download the Framework</h3>
<p>Download the latest version of VT from <a href="http://validatethis.riaforge.org/" target="_blank">validatethis.riaforge.org</a>.</p>
<h3>Step 2 - Install the Framework</h3>
<p>Unzip the contents of the /ValidateThis folder in the zip file into a folder on your ColdFusion server. To make the framework accessible you can either:
	<ol>
		<li>Place the /ValidateThis folder directly under the webroot of your application, or</li>
		<li>Place the /ValidateThis folder anywhere and then create a ColdFusion mapping pointing to it via the CF Administrator or in your Application.cfc</li>
	</ol>
</p>
<h3>Step 3 - Define Validation Rules for Your Object(s)</h3>
<p>For this example we're going to add two validation rules for the UserName property of a User object. There are two ways of defining validation rules to the framework:
<ol>
	<li>Via an xml file.</li>
	<li>Via ColdFusion code, using the addRule() method.</li>
</ol>
</p>
<p>I prefer to create xml files, so that's what we'll be doing here.  I'll create a file called user.user.xml (the filename matches the Transfer class name of the object), and include in it the following code:
<code>
<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<objectProperties>
		<property name="UserName" desc="Email Address">
			<rule type="required" />
			<rule type="email" 
				failureMessage="You call that an Email Address?" />
		</property>
	</objectProperties>
</validateThis>
</code>
</p>
<p>I don't want to spend a lot of time in this post describing the format of the ValidateThis! xml schema. I described it at length in a couple of <a href="http://www.silverwareconsulting.com/index.cfm/2008/10/17/ValidateThis--Lets-Talk-Metadata">previous</a> <a href="http://www.silverwareconsulting.com/index.cfm/2008/10/19/ValidateThis--Less-Verbose-XML">posts</a>. In a nutshell, what we've done above is to declare that our Business Object will have a <em>UserName</em> property, and that that property has two validation rules associated with it:
<ol>
	<li>It is required.</li>
	<li>It must be a valid email address.</li>
</ol>
</p>
<p>In addition to that we've declared that the "friendly name" of the property (to be used in validation failure messages), is <em>Email Address</em> and that the custom message that we'd like displayed when the email validation fails is "You call that an Email Address?".</p>
<p>Note that it is not necessary to use the Transfer class name of the business object as the name of your xml file - you can call it anything you like.  When I use the more complex Business Object integration method it is important that the names match, so I try to be consistent.</p>
<h3>Step 4 - Specify Default Values for the Framework</h3>
<p>Create a struct that contains keys which tell ValidateThis! how to behave.  At a minimum you'll probably need to tell VT where to find your xml files, so your struct may look something like this:
<code>
<cfset ValidateThisConfig = {definitionPath="/model/VT/"} />
</code>
</p>
<p>There are a number of other keys that can be specified in the ValidateThisConfig struct, but for most of them you can accept the defaults.  They keys available along with a description of what they do and their default values can be found in the <a href="http://www.silverwareconsulting.com/index.cfm/2009/4/20/ValidateThis-07--SuperSimple-Integration">VT 0.7 Release Notes</a>.</p>
<h3>Step 5 - Instantiate the ValidateThis.cfc Service Object</h3>
<p>Create an instance of the ValidateThis.cfc service object, like so:
<code>
<cfset application.ValidateThis = 
	createObject("component","ValidateThis.ValidateThis").init(
		ValidateThisConfig) />
</code>
</p>
<p>You now have access to all of the framework's capabilities via the application.ValidateThis object.</p>
<h3>Step 6 - Performing Server-Side Validations</h3>
<p>To perform server-side validations on your Business Object you simply call the validate() method of the application.ValidateThis object, passing in the object type and the object itself.  The object type is the same as the filename that you used in Step 3 above, without the .xml extension.  So in this example it would be "user.user".  So, assuming that we have a populated object called objUser, we'd do the following:
<code>
<cfset Result = 
	application.ValidateThis.validate(
		objectType="user.user",
		theObject=objUser) />
</code>
</p>
<p>This will return a Result object to us, upon which we can invoke a number of methods including:
<ul>
	<li>getIsSuccess() - which returns <em>true</em> if all of the validations passed</li>
	<li>getFailures() - which returns all validation failures as an array of structs, with each struct including metadata about the failure</li>
	<li>getFailuresAsStruct() - which is a helper method that returns a struct with one key per property, with each key containing all of the validation failure messages</li>
</ul>
</p>
<p>And that's it.  With those six simple steps you are up and running and performing server-side validations with VT.</p>
<p>In the next post I'll cover how to enable client-side validations, and I'll follow that up with some more examples of different types of validations.</p>
<p>As always, if you have any questions or interest in following the progress of VT, I invite you to join the <a href="http://groups.google.com/group/validatethis" target="_blank">ValidateThis! Google Group</a>.</p>