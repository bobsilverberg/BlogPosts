Using Stored Procedures? Why Not Try SPCaller?

The code for the SPCaller component that I discussed in a <a href="http://www.silverwareconsulting.com/index.cfm/2008/7/4/SPCaller--A-Component-That-Calls-Stored-Procedures">previous posting</a> is now available for download at <a href="http://spcaller.riaforge.org/">RIAForge</a>.</p>
<p>I have added some tickets to the Issue Tracker for possible enhancements.  If anyone downloads the code and is interested in these, or any other enhancements, please contact me.  I'd also be very interested to hear from anyone that gives it a try and finds it useful.</p>	
<p>What follows are some implementation and usage notes.  They will probably be less than interesting to anyone who isn't planning on trying out the component ;-)</p>
<h3>Implementation</h3>
<p>It is recommended, but not required, that this component be instantiated as a singleton.  You can implement it in your model via composition, inheritance or simply as a standalone object in the application scope.  I commonly compose it into my other objects, using Coldspring, so here's an example of that first:
<code>
<bean id="SPCaller" class="path_to_cfc.SPCaller">
	<constructor-arg name="DSN">
		<value>MyDatasourceName</value>
	</constructor-arg>
</bean>
<bean id="MyGateway" class="path_to_cfc.MyGateway">
	<property name="SPCaller">
		<ref bean="SPCaller" />
	</property>
</bean>
</code>
</p>
<p>You'd then need to add a setSPCaller() method in your MyGateway.cfc, for example:
<code>
<cffunction name="setSPCaller" access="public" returntype="void" output="false" hint="I set the SPCaller.">
	<cfargument name="SPCaller" type="any" required="true" />
	<cfset variables.instance.SPCaller = arguments.SPCaller />
</cffunction>
</code></p>
<p>Then, to call it you'd write something like this:
<code>
<cfset qryTest = variables.instance.SPCaller.callSP("mySP") />
</code>
</p>
<p>If you prefer inheritance, you could also simply extend it with an object.  In that case you wouldn't use Coldspring, you'd just define your component like so:
<code>
<cfcomponent displayname="MyGateway" output="false" extends="path_to_cfc.SPCaller">

<cffunction name="Init" access="Public" returntype="any" output="false" hint="I build a new MyGateway">
	<cfargument name="DSN" type="string" required="true" hint="The name of the default datasource" />
	<cfset super.Init(arguments.DSN) />
	<cfreturn this />
</cffunction>

...
</cfcomponent>
</code>
</p>
<p>You'd have to make sure that the Init() method of your object (in this example, MyGateway) also extended the Init() method of SPCaller.  If you go this route, you could call it like this:
<code>
<cfset qryTest = callSP("mySP") />
</code>
</p>
<p>When I first started using this component, I did use it in this manner, using it as a base component for all of my Business Objects, so that each of my Business Objects had a callSP() method.</p>
<p>Finally, you can also instantiate the component manually, like this:
<code>
<cfset application.SPCaller = CreateObject("component","path_to_cfc.SPCaller").Init("MyDatasourceName") />
</code>
</p>
<p>In which case you'd call it like this:
<code>
<cfset qryTest = application.callSP("mySP") />
</code>
</p>
<h3>Arguments</h3>
<p>	The SPCaller component has one method that you would call, callSP(), which accepts the following arguments
<ol>
	<li>SPName - The name of your stored procedure.</li>
	<li>DataStruct - An optional argument which is a structure of data that should be passed into the SP's parameters. This is optional as often an SP will not have any parameters.</li>
	<li>DSN - The datasource to be used when calling the SP.  This is also optional, as it is only required if you wish to override the DSN that was set via the Init() method.</li>
</ol>
</p>
<h3>Usage</h3>
<p>For example, to call this SP:
<code>
CREATE PROCEDURE [dbo].[Test_Update]
	@id int
	,@colVarChar varchar(50)
AS
SET NOCOUNT ON;

UPDATE	tblDataTypes
SET		colVarChar = @colVarChar
WHERE	id = @id

SELECT 	id, colVarChar
FROM	tblDataTypes
WHERE	id = @id
</code>
</p>
<p>You could do:
<code>
<cfset DataStruct = StructNew() />
<cfset DataStruct.id = 1 />
<cfset DataStruct.colVarChar = "New Text" />
<cfset qryTest = SPCaller.callSP("Test_Update",DataStruct) />
</code>
</p>	
<p>If you already have all of your data in a struct, for example in the attributes scope in Fusebox, or from Event.getAllValues() in Model-Glue, then you can simply pass that struct into the DataStruct argument, which saves a lot of work.</p>
