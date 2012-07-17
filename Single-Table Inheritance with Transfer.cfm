Single-Table Inheritance with Transfer

<p>I want to talk about object inheritance, which may sound a bit enigmatic, so I'm going to start with an example:</p>
<p>Let's say I have a number of types of <strong>Employees</strong> that I'm trying to model.  I have <strong>Developers</strong>, who have attributes such as <em>favouriteLanguage</em> and <em>enjoysDeathMetal</em> and behaviours such as <em>code()</em> and <em>test()</em>.  I have <strong>Designers</strong>, who have attributes such as <em>favouriteColour</em> and <em>toleratesDevelopers</em> and behaviours such as <em>makePretty()</em> and <em>makePrettier()</em>.  And I have <strong>Analysts</strong>, who have attributes such as <em>levelOfAttentionToDetail</em> and <em>totalPagesOfRequirementsProduced</em> and behaviours such as <em>ask()</em> and <em>tell()</em>.</p>
<p>In addition to those specific attributes and behaviours, all of these employee types also share some common attributes, such as <em>userName</em>, <em>firstName</em> and <em>lastName</em> and also have common behaviours such as <em>startDay()</em>, <em>takeBreak()</em> and <em>askForRaise()</em>.</p>
<p>This is an example of <em>inheritance</em>, a form of one-to-one relationship.  We can say that a <strong>Developer</strong> <em>is an</em> <strong>Employee</strong>, a <strong>Designer</strong> <em>is an</em> <strong>Employee</strong> and an <strong>Analyst</strong> <em>is an</em> <strong>Employee</strong>.  It is not an example of <em>composition</em>.  We would not say that a <strong>Developer</strong> <em>has an</em> <strong>Employee</strong> or that an <strong>Employee</strong> <em>has a</em> <strong>Developer</strong>. The terms that are commonly used to describe this relationship between classes are <em>Supertype</em> and <em>Subtype</em>.  <strong>Employee</strong> is a <em>Supertype</em>, while <strong>Developer</strong>, <strong>Designer</strong> and <strong>Analyst</strong> are all <em>Subtypes</em> of <strong>Employee</strong>.</p>
<p>So, the question is, how do I implement this model using Transfer?<more/>
My first inclination was to attempt Multi-Table Inheritance, which is a fancy way of saying that I'd have an <strong>Employee</strong> table that stores all of the common attributes, and I'd have three additional tables, one for each EmployeeType that stores their specific attributes.  For example, I'd have a <strong>Developer</strong> table with columns for <em>favouriteLanguage</em> and <em>enjoysDeathMetal</em>.  Unfortunately, try as I might, I could not get that to work with Transfer without using a OneToMany or a ManyToOne.  And I really don't want to use a OneToMany or a ManyToOne to represent what's really a OneToOne.  As I've already described, this is an example of inheritance, not composition. So instead I opted to try Single-Table Inheritance.</p>
<p>Single-Table Inheritance means, simply, that there's only one table, the <strong>Employee</strong> table.  It contains columns for all of the common attributes <strong>and</strong> columns for all of the specific attributes.  Each of the columns that is specific to one EmployeeType allows nulls, so a record for a <strong>Developer</strong> would only have data populated into the <em>favouriteLanguage</em> and <em>enjoysDeathMetal</em> columns, while the <em>favouriteColour</em> and <em>levelOfAttentionToDetail</em> columns would contain nulls.</p>
<p>Those of you who are fond of normalization, as I am, will cringe a bit, but really, normalization is a bit passé these days.  With the cost of disk space dropping all the time and the speed of processors increasing, denormalization has become downright acceptable.  But I digress.  What I chose to attempt to implement is this Single Table Inheritance scheme using Transfer.  Actually that's not entirely accurate, really <a href="http://www.fancybread.com" target="_blank">Paul Marcotte</a> and I chose to attempt this - we worked together on this solution so these ideas are as much his as they are mine.</p>
<p>Anyway, what would the transfer.xml file for this look like?  I'm going to start with a simple example, which is not ideal, and then add to it to address its inherent problem:
<code>
<package name="employee">
	<object name="Developer" table="tblEmployee" decorator="Developer">
		<id name="userName" type="string" />
		<property name="firstName" type="string" />
		<property name="lastName" type="string" />
		<property name="FavouriteLanguage" type="string" />
		<property name="enjoysDeathMetal" type="boolean" />
	</object>
	<object name="Designer" table="tblEmployee" decorator="Designer">
		<id name="userName" type="string" />
		<property name="firstName" type="string" />
		<property name="lastName" type="string" />
		<property name="FavouriteColour" type="string" />
		<property name="toleratesDevelopers" type="boolean" />
	</object>
	<object name="Analyst" table="tblEmployee" decorator="Analyst">
		<id name="userName" type="string" />
		<property name="firstName" type="string" />
		<property name="lastName" type="string" />
		<property name="levelOfAttentionToDetail" type="string" />
		<property name="totalPagesOfRequirementsProduced" type="numeric" />
	</object>
</package>
</code>
</p>
<p>What I've done is define three separate objects to Transfer, each of which points to the same table.  For each object I only define those properties that are valid to that object.  For example, the <strong>Developer</strong> object has a <em>FavouriteLanguage</em> property but not a <em>FavouriteColour</em> property.  In terms of behaviours, I create an Employee.cfc decorator (the Supertype) that contains all of my common methods, e.g., <em>askForRaise()</em>, and I create decorators for each of the employee types (Subtypes) which extend the Supertype's decorator.  For example, Developer.cfc extends Employee.cfc and it includes the method <em>code()</em>.  This all works quite well, but there's a problem.</p>
<p>The problem is how to protect the integrity of the Subtypes.  What do I mean by that?  Here's an example:</p>
<p>Let's say there's a <strong>Developer</strong> named <em>Bob</em> in the system.  I could say:
<code>
objDeveloper = Transfer.get("employee.Developer","Bob");
</code></p>
<p>And I'd get back a <strong>Developer</strong> object for Bob.  I could then call <em>getFavouriteLanguage()</em> and <em>askForRaise()</em> and <em>code()</em> on that object.  Fine.  But what if I did this:
<code>
objDesigner = Transfer.get("employee.Designer","Bob");
</code></p>
<p>Hmm, now I have a <strong>Designer</strong> object, but it's not valid because really the employee I'm dealing with is a developer.  I can no longer call <em>getFavouriteLanguage()</em> nor <em>code()</em> on the object, but I can call <em>getFavouriteColour()</em> and <em>makePretty()</em> on the object, which would probably end up badly, considering that Bob is really a developer, not a designer.  So this is a problem.  But there's a solution.  Enter <strong>EmployeeType</strong>.</p>
<p>First we create an object for <strong>EmployeeType</strong>, and then we create a ManyToOne between each of our Subtypes and EmployeeType.  For example, <strong>Developer</strong> has a ManyToOne pointing to <strong>EmployeeType</strong>.  Finally, we change the Subtypes to use a <em>composite key</em> instead of a single <em>id</em>.  So the key to <strong>Developer</strong>, for example, is no longer just <em>userName</em>.  It's now <em>userName</em> <strong>plus</strong> <em>EmployeeType</em>.  Now, whenever we want to ask for an instance of an employee, we will specify both the <em>userName</em> and the <em>EmployeeType</em>.  This "specifying the EmployeeType" will happen automatically in the Gateway - we won't have to do it manually.  To take a look at this implementation let's start with the  transfer.xml:
<code>
<package name="employee">
	<object name="Developer" table="tblEmployee" decorator="Developer">
		<compositeid>
			<property name="userName" />
			<manytoone name="EmployeeType" />
		</compositeid>
		<property name="userName" type="string" />
		<property name="firstName" type="string" />
		<property name="lastName" type="string" />
		<property name="FavouriteLanguage" type="string" />
		<property name="enjoysDeathMetal" type="boolean" />
		<manytoone name="EmployeeType">
			<link to="employee.EmployeeType" column="employeeTypeId"/>
		</manytoone>
	</object>
	<object name="Designer" table="tblEmployee" decorator="Designer">
		<compositeid>
			<property name="userName" />
			<manytoone name="EmployeeType" />
		</compositeid>
		<property name="userName" type="string" />
		<property name="firstName" type="string" />
		<property name="lastName" type="string" />
		<property name="FavouriteColour" type="string" />
		<property name="toleratesDevelopers" type="boolean" />
		<manytoone name="EmployeeType">
			<link to="employee.EmployeeType" column="employeeTypeId"/>
		</manytoone>
	</object>
	<object name="Analyst" table="tblEmployee" decorator="Analyst">
		<compositeid>
			<property name="userName" />
			<manytoone name="EmployeeType" />
		</compositeid>
		<property name="userName" type="string" />
		<property name="firstName" type="string" />
		<property name="lastName" type="string" />
		<property name="levelOfAttentionToDetail" type="string" />
		<property name="totalPagesOfRequirementsProduced" type="numeric" />
		<manytoone name="EmployeeType">
			<link to="employee.EmployeeType" column="employeeTypeId"/>
		</manytoone>
	</object>
	<object name="EmployeeType" table="tblEmployeeType">
		<id name="employeeTypeId" type="numeric" />
		<property name="name" type="string" />
		<property name="description" type="string" />
	</object>
</package>
</code>
</p>
<p>This transfer.xml just implements everything discussed in the previous paragraph.  It should be fairly straightforward.  So, how do we use it?  Well, all of our calls to Transfer.get() are centralized in a <em>Gateway</em>, thereby encapsulating database access.  So all we have to do is something like this, in our Gateway code:
<code>
<cffunction name="get" access="public" returntype="any">
	<cfargument name="userName" type="any" required="true">
	<cfset var theKey = StructNew() />
	<cfset theKey.userName = arguments.userName />
	<cfset theKey.employeeType = getEmployeeTypeId("Developer") />
	<cfreturn getTransfer().get("employee.Developer",theKey) />
</cffunction>

<cffunction name="getEmployeeTypeId" access="private" returntype="any">
	<cfargument name="EmployeeType" type="any" required="true">
	<cfreturn getTransfer()
		.readByProperty("employee.EmployeeType","Name",arguments.EmployeeType)
		.getEmployeeTypeId() />
</cffunction>
</code>
</p>
<p>What you see above is a concrete example of how it actually works, (that code would reside in DeveloperGateway.cfc) but my actual code is quite different from the above because it's based on abstract classes.  I don't want to complicate things here by getting into the details, but basically I have an <strong>EmployeeGateway</strong> which contains parameterized code which is then inherited by the <strong>DeveloperGateway</strong>, <strong>DesignerGateway</strong> and <strong>AnalystGateway</strong>, none of which have any code in them at all.  So all that hardcoded stuff that points to "Developer" is nonexistent in my code.</p>
<p>The bottom line is that I can call a <em>getDeveloper()</em> method or a <em>getDesigner()</em> method from my Service, passing only the <em>userName</em>, and be assured that I'll always get a valid object back.</p>
<p>This seems like a pretty neat solution to the problem, but so far it's only been used in theoretical situations.  Can anyone see any problems with it that we haven't thought of?</p>

