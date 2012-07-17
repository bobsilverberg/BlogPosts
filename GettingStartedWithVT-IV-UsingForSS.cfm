Getting Started with VT and Transfer - Part IV - Using VT for Server-Side Validations

<p>In the <a href="http://www.silverwareconsulting.com/index.cfm/2009/3/13/Getting-Started-with-VT-and-Transfer--Part-III--Integrating-VT-Into-Your-Business-Object">previous post</a> in this series about getting started with Transfer and ValidateThis!, my validation framework for ColdFusion objects, we looked at the few changes that we had to make to the <a href="http://www.validatethis.org/VTAndTransfer_Start/" target="_blank">initial sample application</a> in order to integrate VT into our Business Object, so now we're ready to start using VT to perform our server-side validations. To do that we're going make the following changes to the sample application:
<ul>
	<li>Add an xml file that defines our validation rules for our User object.</li>
	<li>Modify the updateUser() method in the UserService to tell our User object to validate itself.</li>
	<li>Modify our form to display any validation failure messages.</li>
</ul>
</p>
<p>For now we're just going to add the validations for the UserName property, which appears on the form as the Email Address field.  We're also only going to utilize server-side validations for now.  A version of the sample application with those validations in place can be viewed <a href="http://www.validatethis.org/VTAndTransfer_PartII/" target="_blank">here</a>.
<more/>
Let's get started by creating the xml file that will define our validation rules. The file will have the same name as our Transfer class, so in this example the file will be called user.user.xml, and will contain the following:
<code>
<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<objectProperties>
		<property name="UserName" desc="Email Address">
			<rule type="required" />
			<rule type="email" 
				failureMessage="Hey, buddy, you call that an Email Address?" />
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
<p>In addition to that we've declared that the "friendly name" of the property (to be used in validation failure messages), is <em>Email Address</em> and that the custom message that we'd like displayed when the email validation fails is "Hey, buddy, you call that an Email Address?".</p>
<p>Now that we've defined our validation rules, we can move on to making the required change to the UserService Object. Here's what the original version of the updateUser() method looks like:
<code>
<cffunction name="updateUser" access="public" returntype="any">
	<cfargument name="theId" type="any" required="yes" />
	<cfargument name="args" type="struct" required="yes" />
	
	<cfset var objUser = getUser(arguments.theId) />
	<cfset objUser.setUserName(arguments.args.UserName) />
	<cfset objUser.setUserPass(arguments.args.UserPass) />
	<cfset objUser.setNickname(arguments.args.Nickname) />
	<cfset getTransfer().save(objUser) />
	<cfreturn objUser />
			
</cffunction>
</code>
</p>
<p>And here's the new version:
<code>
<cffunction name="updateUser" access="public" returntype="any">
	<cfargument name="theId" type="any" required="yes" />
	<cfargument name="args" type="struct" required="yes" />
	
	<cfset var objResult = "" />
	<cfset var objUser = getUser(arguments.theId) />
	<cfset objUser.setUserName(arguments.args.UserName) />
	<cfset objUser.setUserPass(arguments.args.UserPass) />
	<cfset objUser.setNickname(arguments.args.Nickname) />
	<cfset objResult = objUser.validate() />
	<cfif objResult.getIsSuccess()>
		<cfset getTransfer().save(objUser) />
	</cfif>
	<cfreturn objResult />
</cffunction>
</code>
</p>
<p>So what's changed? After we populate the User object with data submitted via the form, we call the User object's validate() method. This method is actually part of the VT framework, but the integration that we did in the last post magically makes this method (and several others) available to our User object. The validate() method returns a Result object (also part of the framework) with which we can interact.</p>
<p>The Result object can tell us whether or not the validations passed, which we do by checking its getIsSuccess() method. If that returns "true" then we go ahead and save our object.</p>
<p>Finally, instead of returning the User object to the calling routine, we return the Result object, which will contain information about any validation failures that occurred and will also contain a copy of the User object.</p>
<p>To sum it up:
<ol>
	<li>We call validate() on our Business Object, which returns a Result object.</li>
	<li>We check to see if the validations passed, and act accordingly.</li>
	<li>We return the Result object to the calling routine.</li>
</ol>
</p>
<p>And that's it - our server-side validations will be performed and the results of those tests will be returned to us in the Result object.</p>
<p>The only change left to make to our sample application is to make use of that Result object in our view.  Here's the new code for the form, with all changes preceded by comments:
<code>
<!--- Default the validation failures to an empty struct --->
<cfset validationFailures = {} />

<cfset UserService = application.BeanFactory.getBean("UserService") />

<cfif NOT StructKeyExists(Form,"Processing")>
	<cfset UserTO = UserService.getUser(theId=0) />
<cfelse>
	<!---  The updateUser() method returns a Result object--->
	<cfset Result = UserService.updateUser(theId=0,args=Form) />
	<!--- Get the validation failures from the Result object --->
	<cfset validationFailures = Result.getFailuresAsStruct() />
	<!--- Get the User Business Object from the Result object --->
	<cfset UserTO = Result.getTheObject() />
</cfif>

<cfoutput>
<h1>
	ValidateThis! and Transfer Sample App - Part II
	 - Some Server-Side Validations
</h1>
<cfif UserTO.getUserId() NEQ 0>
	<h3>The user has been added!</h3>
</cfif>
<div class="formContainer">
<form action="index.cfm" id="frmMain" method="post" name="frmMain" class="uniForm">
	<input type="hidden" name="Processing" id="Processing" value="true" />
	<fieldset class="inlineLabels">	
		<legend>User Information</legend>
		<div class="ctrlHolder">
			<!--- Output any validation failure messages --->
			<cfif StructKeyExists(validationFailures,"UserName")>
				<p id="error-UserName" class="errorField bold">
					#validationFailures["UserName"]#
				</p>
			</cfif>
			<label for="UserName">Email Address</label>
			<input name="UserName" id="UserName"
				value="#UserTO.getUserName()#"
				size="35" maxlength="50" type="text"
				class="textInput" />
			<p class="formHint">
				Validations: Required, Must be a valid Email Address.
			</p>
		</div>
		<div class="ctrlHolder">
			<label for="UserPass">Password</label>
			<input name="UserPass" id="UserPass" value=""
				size="35" maxlength="50" type="password"
				class="textInput" />
			<p class="formHint">
				Validations: Required, Must be between 5 and 10 characters.
			</p>
		</div>
		<div class="ctrlHolder">
			<label for="Nickname">Nickname</label>
			<input name="Nickname" id="Nickname"
				value="#UserTO.getNickname()#"
				size="35" maxlength="50" type="text"
				class="textInput" />
			<p class="formHint">
				Validations: Custom - must be unique. Try 'BobRules'.
			</p>
		</div>
	</fieldset>

	<div class="buttonHolder">
		<button type="submit" class="submitButton">Submit</button>
	</div>
</form> 
</div>
</cfoutput>
</code>
</p>
<p>To summarize the changes made to the view to make use of the Result object:
<ol>
	<li>We create a default empty struct to hold our validation failure messages, because we are going to be using that struct later.</li>
	<li>Instead of simply expecting a User object back from our updateUser() method we now expect a Result object.</li>
	<li>We ask the Result object for our validation failure messages in a format that we can use in our form.</li>
	<li>We ask the Result object for our User object, so we can use it in the form.</li>
	<li>When rendering the form field for UserName, we output any validation failure messages that were returned by the Result object.</li>
</ol>
</p>
<p>And that's it. Our application is now using the validation rules that we specified in our xml file.  Obviously the code in the form to display the validation failures is less than ideal, but this is meant to be a simple example.  The thing to keep in mind is that the framework will return metadata about validation failures to you, via the Result object, and you can use that metadata any way you like.</p>
<p>In the next post I'll discuss what needs to be done to enable client-side validations for the rules that we defined.  A hint: all we have to do is add a few lines of code to our form!</p>
<p>You can see a demo of this sample application in action at <a href="http://www.validatethis.org/VTAndTransfer_PartII/" target="_blank">www.validatethis.org/VTAndTransfer_PartII/</a>.  As always all of the code for this version of the sample application can be found attached to this post.</p>
