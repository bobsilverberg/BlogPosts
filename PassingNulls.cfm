Passing Nulls to Dynamically Called Methods

With the advent of ColdFusion 9's ORM integration, there is now a very real need to call methods and pass nulls to them. 
For example, you may have a User object that allows for nulls in a DateTerminated property, like so:
<code><cfcomponent persistent="true" entityname="User" table="tblUser" >
	<cfproperty name="UserId" fieldtype="id" generator="native" />
	<cfproperty name="UserName" notnull="true" />
	<cfproperty name="DateTerminated" type="date" notnull="false" />
</cfcomponent></code>
</p>
<p>If I want to pass a null value into the setter for the DateTerminated property, I can do so using the JavaCast function, like so:
<code><cfset User = EntityLoad("User",1,true) />
<cfset User.setDateTerminated(JavaCast("NULL","")) />
</code>
</p>
<p>But what if I want to call that method dynamically?  What if I want to loop through a list of properties and pass a value into each of them?
Generally, when I need to call a method dynamically, I'd do it using cfinvoke, like so:
<code><cfloop list="UserId,UserName,DateTerminated" index="prop">
	<cfinvoke component="#this#" method="set#prop#">
		<cfinvokeargument name="#prop#" value="#someValue#" />
	</cfinvoke>
</cfloop>
</code>
</p>
<p>The problem with that approach is that, if I put <em>JavaCast("NULL","")</em> into <em>someValue</em>, then ColdFusion throws an error:
<code>Attribute validation error for CFINVOKEARGUMENT.
It requires the attribute(s): VALUE.
</code>
</p>
<p>It does this because, as far as CF is concerned, when I put a null into the <em>value</em> attribute it actually disappears from the attributes of the tag. 
There are other ways of dynamically invoking methods, and one of them works well in my specific scenario, which is that I'm calling methods from within the given object. 
This method involves creating a pointer to a function and then calling that.  The code above would change to something like this:
<code><cfloop list="UserId,UserName,DateTerminated" index="prop">
	<cfset myMethod = this["set#prop#"] />
	<cfset myMethod(someValue) />
</cfloop>
</code>
</p>
<p>In my specific use case I'm not simply looping over a list and calling setters, I'm doing a bunch of different things to different properties, and I didn't want to duplicate that logic throughout my method.
So I created a function in my cfc called _setProperty(), like so:
<code>
<cffunction name="_setProperty" access="private" returntype="void" output="false">
	<cfargument name="name" type="any" required="yes" />
	<cfargument name="value" type="any" required="false" />
	<cfset var theMethod = this["set" & arguments.name] />
	<cfif IsNull(arguments.value)>
		<cfset theMethod(javacast('NULL', '')) />
	<cfelse>
		<cfset theMethod(arguments.value) />
	</cfif>
</cffunction>
</code>	
</p>
<p>Now I can call my _setProperty() function from within another method in my cfc, and if I want to set the property to null, I just simply do not pass a value.  
For example, to set the DateTerminated property to null, I'd just do:
<code><cfset User = EntityLoad("User",1,true) />
<cfset User._setProperty("DateTerminated") />
</code>
</p>
<p>This has all come in handy for the populate() method that I'm working on in my <a href="http://www.silverwareconsulting.com/index.cfm/2009/8/31/A-Base-Persistent-ORM-Object-for-CF9">Base Persistent Object</a>. Note that my use of the <em>isNull()</em> function will only allow the above code to run on CF9.  It can easily be changed to run on CF7 and CF8 by changing that to use <em>isDefined()</em>.
Oh, and I have <a href="http://www.elliottsprehn.com/blog/" target="_blank">Elliott Sprehn</a> to thank for this idea. I spotted it in a <a href="http://www.bennadel.com/blog/1320-ColdFusion-CFInvoke-Eliminates-The-Need-For-Evaluate-When-Dynamically-Executing-User-Defined-Functions.htm" target="_blank">comment</a> on <a href="http://www.bennadel.com/index.cfm" target="_blank">Ben Nadel</a>'s blog.  Thanks guys!</p>
