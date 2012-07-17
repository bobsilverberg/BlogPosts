ValidateThis! 0.6 - A Whole Bunch of New Stuff

<p>I've done a lot of work on ValidateThis!, my validations framework for ColdFusion objects, over the past few months, and I'm just now getting around to packaging those changes into a new download.  I hope to put together some decent documentation on the framework in the future, but for now hopefully this blog post will suffice as an explanation of the changes. In summary, the following additions have been made:
<ul>
	<li>Introduction of the ValidateThisConfig bean</li>
	<li>Multiple options for specifying form name/id</li>
	<li>XML schema addition - contexts block</li>
	<li>Support for the <em>remote</em> attribute of the jQuery validation plugin</li>
	<li>Support for custom failure messages for standard validations using the jQuery validation plugin</li>
	<li>Automatic discovery of concrete components</li>
	<li>New generateInitializationScript() method</li>
	<li>New getAllContexts() method</li>
</ul>
</p>
<p>The details of each of these items can be found below:
<more/>
<h3>Introduction of the ValidateThisConfig bean</h3>
<p>Previous to this release if you wanted to change certain behaviours of the framework you had to edit the Coldspring config file that resided in the framework directory.  That was not ideal, so a developer now has the ability to include a ValidateThisConfig bean definition in their application's own coldspring config file.  A sample entry is:
<code>
	<bean id="ValidateThisConfig" 
		class="coldspring.beans.factory.config.MapFactoryBean">
		<property name="sourceMap">
			<map>
				<entry key="BOValidatorPath">
					<value>BOValidator</value>
				</entry>
				<entry key="DefaultJSLib">
					<value>jQuery</value>
				</entry>
				<entry key="JSRoot">
					<value>js/</value>
				</entry>
				<entry key="defaultFormName">
					<value>frmMain</value>
				</entry>
			</map>
		</property>
	</bean>
</code>
</p>
<p>And here is what those entries do:
<ul>
	<li><strong>BOValidatorPath</strong> -  This specifies the path to the BOValidator component, which is the facade to the entire framework.  It is possible that advanced users may want to either extend or override that component with their own version, and this entry allows for that.</li>
	<li><strong>DefaultJSLib</strong> - ValidateThis can be installed with support for multiple JavaScript implementations.  This entry specifies which implementation should be used for generating client-side validations.  It is a default in that in can be overridden on a case by case basis in your application code, if desired.</li>
	<li><strong>JSRoot</strong> - Another new feature of the framework is that it can be asked to generate all of the JavaScript statements necessary to load and configure all of the required JS libraries (discussed in more detail below).  This entry specifies where the JavaScript files can be found on your server.</li>
	<li><strong>defaultFormName</strong> - This is the default form name/id to be used when generating client-side validations. It is discussed in more detail in the next section.</li>
</ul>
</p>
<p>Note that any additional behaviours that are deemed customizable will be added to this config bean, allowing those behaviours to be customized without having to touch any of the core framework code.</p>
<h3>Multiple options for specifying form name/id</h3>
<p>When generating client-side validation code, the setup of said code often needs to specify the name and/or id of the form to which the validation is being attached.  In previous releases this was not done by the framework (you had to do it manually), so it was a non-issue.  In the latest release the framework actually generates that code for you, so it needs to know the name/id of the form for which validations are being generated.  To this end there are three different places in which you can specify that information:
<ul>
	<li><strong>Global default form name</strong> - You can specify a form name in your ValidateThisConfig bean (mentioned above) which will be used as the default if you do not override it elsewhere.  I find this useful as I tend to use the same name/id for all of my forms.  If I'm creating a form (e.g., a search form or a login form) which might be included on a page with other forms then I'll give it a unique name, otherwise they're mostly called "frmMain".</li>
	<li><strong>Associate a form name with a context</strong> - When using contexts to specify groups of validation rules that apply to a given domain object in different use cases, you have the option of specifying a form name that corresponds with a given context.  For example, for a User object you may have a login form, with an associated <em>login</em> context as well as a registration form with an associated <em>register</em> context.  If the name/id of your login form is <em>frmLogin</em> and the name/id of your registration form is <em>frmRegister</em>, you can specify those in the xml configuration file for the User object.  The new elements that support that are described in the next section.</li>
	<li><strong>Specify a form name when requesting the client-side validation script</strong> - You ask your domain object for its client-side validation script by invoking the getValidationScript() method on it.  That method accepts three arguments, all of which are optional:
		<ul>
			<li><strong>context</strong> - If you are using contexts you specify the context in order to get back the corresponding validation rules.</li>
			<li><strong>formName</strong> - This is where you specify the name/id of the form.  If you do not pass anything into this argument it uses the form name specified in the ValidateThisConfig bean.</li>
			<li><strong>JSLib</strong> - Allows you to specify the JavaScript implementation that is to be used to generate the script for the validation rules.  This defaults to the value specified in the ValidateThisConfig bean.</li>
		</ul>
	</li>
</ul>
</p>
<h3>XML schema addition - contexts block</h3>
<p>The ValidateThis.xsd XML schema definition has been amended to allow for an optional <contexts> block in which a developer can  define the name of a form that should be used when generating client side validations for a specific context.  An example is as follows:
<code>
<contexts>
	<context name="Login" formName="frmLogin" />
	<context name="Register" formName="frmRegister" />
</contexts>
</code>
</p>
<p>This is an optional element as there are two other ways of specifying the form name to be used, which was discussed in the section above.</p>
<h3>Support for the <em>remote</em> attribute of the jQuery validation plugin</h3>
<p>A developer can now create client-side validations that are done via AJAX using the remote attribute of the jQuery validation plugin.  This is done using the <em>custom</em> validation type.  A sample validation rule from the xml file is:
<code>
<property name="Nickname">
	<rule type="custom" 
		failureMessage="That Nickname is already taken.  Please try a different Nickname.">
		<param methodname="CheckDupNickname" />
		<param remoteURL="CheckDupNickname.cfm" />
	</rule>
</property>
</code>
</p>
<p>This will cause the jQuery validation plugin to issue an AJAX request to CheckDupNickname.cfm to perform a validation.  An example of this has been added to the demo application at <a href="http://www.validatethis.org/" target="_blank">www.validatethis.org</a>.</p>
<h3>Support for custom failure messages for standard validations using the jQuery validation plugin</h3>
<p>Prior to this release only the standard validation failure messages that are built into the jQuery validation plugin were displayed, even if the developer specified a custom failure message (the custom failure messages were displayed for server-side validation failures).  In this release, if you specify a custom failure message for a rule, it will be used for both client-side and server-side validations.</p>
<h3>Automatic discovery of concrete components</h3>
<p>Prior to this release all of the concrete components (ClientScriptWriters, ClientRuleScripters and ServerRuleValidators) were hardcoded into the coldspring.xml config file for ValidateThis.  This is no longer necessary which means less maintenance and also that new concrete components can be added and they will be available to the framework immediately.</p>
<h3>New generateInitializationScript() method</h3>
<p>A generateInitializationScript() method has been added to the BOValidator which will return a JavaScript block that contains all of the statements necessary to load and configure the required JS libraries.  This will ease integration in certain scenarios.</p>
<h3>New getAllContexts() method</h3>
<p>A getAllContexts() method has been added to the BOValidator which will return a struct containing all of the contexts defined for the object.  Each key in the struct will contain an array of all of the business rules defined for that context.  This was a user request.</p>
<p>A new download of version 0.6 will be available shortly at <a href="http://validatethis.riaforge.org/" target="_blank">RIAForge</a>.</p>
