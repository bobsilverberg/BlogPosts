Getting Started with VT and Transfer - Part III - The Initial Sample App

<p>In this post in my series about getting started with Transfer and ValidateThis!, my validation framework for ColdFusion objects, we're going to take the simple sample application that was described in the <a href="http://www.silverwareconsulting.com/index.cfm/2009/3/12/Getting-Started-with-VT-and-Transfer--Part-II--The-Initial-Sample-App">previous post</a> and add some server-side validations to it, using VT of course. To do that we're going to have to make the following changes:
<ul>
	<li>Import the bean definitions for ValidateThis! into our Coldspring config.</li>
	<li>Add a ValidateThisConfig bean to our Coldspring config.</li>
	<li>Add a TDOBeanInjectorObserver bean to our Coldspring config.</li>
	<li>Add a decorator for our User object.</li>
	<li>Modify our UserService to tell our User object to validate itself.</li>
	<li>Modify our form to display any validation failure messages.</li>
	<li>Add an xml file that defines our validation rules for our User object.</li>
</ul>
</p>
<p>That may sound like a lot of work, but it's actually very few lines of code, and a lot of it is simply copying boilerplate into existing files.  So let's get started by importing the bean definitions for ValidateThis! into our Coldspring config. We're going to add the following line to our Coldspring.xml file:
<code>
<import resource="/ValidateThis/config/Coldspring.xml.cfm" />
</code>
</p>
<p>That will give our Coldspring bean factory access to all of VT's beans. Now we can add a ValidateThisConfig bean to our Coldspring config:
<code>
<bean id="ValidateThisConfig"
	class="coldspring.beans.factory.config.MapFactoryBean">
	<property name="sourceMap">
		<map>
			<entry key="BOValidatorPath"><value>BOValidator</value></entry>
			<entry key="DefaultJSLib"><value>jQuery</value></entry>
			<entry key="JSRoot"><value>js/</value></entry>
			<entry key="defaultFormName"><value>frmMain</value></entry>
		</map>
	</property>
</bean>
</code>
</p>
<p>This sets a number of default values that VT will use. I explained what these entries do in the <a href="http://www.silverwareconsulting.com/index.cfm/2009/3/8/ValidateThis-06--A-Whole-Bunch-of-New-Stuff">Release Notes for version 0.6 of VT</a>, so I won't go into it again here.  For the sample app the above values will work. Next we need to add a bean definition for the TDOBeanInjectorObserver:
<code>
<bean id="TDOBeanInjectorObserver" 
	class="ValidateThis.util.TDOBeanInjectorObserver" 
	lazy-init="false">
	<constructor-arg name="transfer">
		<ref bean="transfer" />
	</constructor-arg>
	<constructor-arg name="afterCreateMethod">
		<value>setUp</value>
	</constructor-arg>
	<property name="beanInjector">
		<ref bean="beanInjector" />
	</property>
</bean>
</code>
</p>
<p>This sets up Brian Kotek's Transfer Decorator Object Bean Injector Observer (which can be found at RIAForge). In a nutshell that component will allow us to inject other components into our Transfer objects when they are created. Note that the TDOBeanInjectorObserver as well as the generic beanInjector both ship with the VT framework, so if you aren't already using them you don't need to worry about downloading or installing them. If you are already using the TDOBeanInjectorObserver in your application then you won't need to add that bean definition at all. Note that the constructor-arg afterCreateMethod is being set to "setUp" - we'll come back to that in a bit.</p>
<p>OK, now that our Coldspring setup has been done we can move on to adding a decorator for our User object. To tell Transfer that we want to use a decorator for the User object, we need to make a small change to our transfer.xml file:
<code>
<object name="user" table="tblUser" decorator="model.user">
	<id name="UserId" type="numeric" />
	<property name="UserName" type="string" />
	<property name="UserPass" type="string" />
	<property name="Nickname" type="string" nullable="true" />
</object>
</code>
</p>
<p>You'll notice that all we've done is add the decorator="model.user" attribute to the User object definition. Now we need to create that decorator, so we'll create a file called user.cfc and place it in the /model directory. Here's what that file will contain:
<code>
<cfcomponent displayname="user" output="false" extends="AbstractTransferDecorator">
</cfcomponent>
</code>
</p>
<p>Hmm, you may be saying, there's nothing in there. That's true. The fact is that all of the code that you need to add to your object's decorator in order to integrate VT into your object is the same no matter what your object is. The code will be identical in your User object, your Account object, your Product object, etc. So in order to avoid having to repeat that code over and over again, we're going to create an Abstract Transfer Decorator object. You might have noticed that the User decorator shown above does in fact extend another cfc, called AbstractTransferDecorator, so that's where we're going to put the actual integration code.  Let's look at that next:
<code>
<cfcomponent output="false" extends="transfer.com.TransferDecorator">

<cffunction name="setUp" access="public" output="false" returntype="void"
	hint="I am run after configure via the TDOBeanInjector, and I inject the appropriate BOValidator into the object.">
	<cfset setValidator(getValidationFactory().getValidator(getClassName(),getDirectoryFromPath(getCurrentTemplatePath()))) />
</cffunction>

<cffunction name="onMissingMethod" access="public" output="false" returntype="Any"
	hint="I am used to help communicate with the BOValidator, which is accessed via getValidator().">
	<cfargument name="missingMethodName" type="any" required="true" />
	<cfargument name="missingMethodArguments" type="any" required="true" />

	<cfset var Validator = getValidator() />
	<cfset var ReturnValue = "" />
	
	<cfif arguments.missingMethodName EQ "validate">
		<cfset ReturnValue = Validator.validate(theObject=this,argumentcollection=arguments.missingMethodArguments) />
	<cfelseif StructKeyExists(getValidator(),arguments.missingMethodName)>
		<cfinvoke component="#Validator#" method="#arguments.missingMethodName#"
			argumentcollection="#arguments.missingMethodArguments#"
			returnvariable="ReturnValue" />		
	</cfif>
	<cfif IsDefined("ReturnValue")>
		<cfreturn ReturnValue />
	</cfif>
</cffunction>

<cffunction name="testCondition" access="Public" output="false" returntype="boolean"
	hint="I dynamically evaluate a condition and return true or false.">
	<cfargument name="Condition" type="any" required="true" />
	
	<cfreturn Evaluate(arguments.Condition)>
</cffunction>

<cffunction name="getValidator" access="public" output="false" returntype="any">
	<cfreturn variables.Validator />
</cffunction>
<cffunction name="setValidator" returntype="void" access="public" output="false">
	<cfargument name="Validator" type="any" required="true" />
	<cfset variables.Validator = arguments.Validator />
</cffunction>

<cffunction name="getValidationFactory" access="public" output="false" returntype="any">
	<cfreturn variables.ValidationFactory />
</cffunction>
<cffunction name="setValidationFactory" returntype="void" access="public" output="false">
	<cfargument name="ValidationFactory" type="any" required="true" />
	<cfset variables.ValidationFactory = arguments.ValidationFactory />
</cffunction>

</cfcomponent>
</code>
</p>
<p>OK, so there's a bit of code there, but the nice thing is that, if you just want to <em>use</em> the framework, you don't really need to understand exactly what it's doing. You can just copy that code as is into your Abstract decorator and you're good to go. In the interest of keeping these posts short and to the point I'm not going to elaborate on how it works, but I will discuss it in a future blog post.</p>
<p>At this point we're actually finished integrating the framework into our business object. We're now ready to use it.'OK, now we've 'Let's start with the getter and setter for ValidationFactory at the bottom of the file. The setter is there to support the TDOBeanInjectorObserver that we defined to Coldspring above. When Transfer creates an instance of our object the TDOBeanInjectorObserver will automatically inject a reference to the ValidationFactory bean (which is defined in VT's Coldspring config) into our Transfer object. After that it will call our object's setUp() method.</p>
<p>Remember how we used a value of "setUp" in the TDOBeanInjectorObserver bean's afterCreateMethod constructor-arg? That tells the TDOBeanInjectorObserver to invoke the setUp() method in our object after all beans have been injected into it. The setUp() method turns around and asks the ValidationFactory (which is part of VT) to create a Business Object Validator Object (BOValidator) which is configured for this particular object. It then uses the setValidator() method to store a reference to that BOValidator in our object. The name of <em>this</em> method must match the name of that argument. You can use any name you like, but they must be the same.</p>
<p>Note that it's very likely that if you're using Transfer in your application you'll already have decorators for your objects.  In that case rather than creating a new 'probably already have decorators for most, if not all, of their objects.  </p><p>Again, an online version of this sample application is available at <a href="http://www.validatethis.org/VTAndTransfer_Start/" target="_blank">www.validatethis.org/VTAndTransfer_Start/</a>, and all of the code for it can be found attached to this post.</p>
