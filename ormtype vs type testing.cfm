CF9 ORM - Weirdness when Experimenting with Datatypes

I've been playing around with the attributes that are available, as of ColdFusion 9, to the cfproperty tag that are meant to describe the datatype of the property for persistent objects.  Currently there are four options:
<ul>
	<li><em>type</em> - this is the standard <em>type</em> attribute that was available to the cfproperty tag pre-CF9.  You are only <em>supposed</em> to use valid CF types for this.</li>
	<li><em>ormtype</em> - this is used to tell Hibernate what the data type of the property should be.  It is a database agnostic value.  Hibernate will translate it into a valid datatype for the dbms in question.</li>
	<li><em>sqltype</em> - this is a dbms-specific datatype.  You would use this when you want to direct Hibernate to create a column with a specific datatype.</li>
	<li><em>none</em> -  if you are pointing your persistent object at an existing table, you can choose not to specify any of the above three attributes, and Hibernate will look at the database to determine the datatype.</li>
</ul>
</p>
<p>It may already be obvious that this is a bit confusing.  I have been trying to figure out how everything works, and what the ramifications of different combinations of attributes and values are.  
I plan a more in-depth post on that topic when I've got it clearer in my mind.  For now I'm posting the results of some testing that I did, as I find it interesting and it might help me and others understand 
this stuff better.</p>
<h3>type vs ormtype and Setters</h3>
<p>One thing that I do know is that, if you use the <em>type</em> attribute CF will generate typed setters for your properties, whereas if you use <em>ormtype</em> instead it will generate typeless setters.  Consider the following example:
</p>
<p>If you have an object like this:
<code><cfcomponent persistent="true">
	<cfproperty name="myDate" type="date" />
</cfcomponent></code></p>
<p>and try to do:
<code><cfset myObject.setMyDate("abc") /></code></p>
<p>CF will throw an error because "abc" isn't a valid date. But if you have an object like this:
<code><cfcomponent persistent="true">
	<cfproperty name="myDate" ormtype="date" />
</cfcomponent></code></p>
<p>and try to do:
<code><cfset myObject.setMyDate("abc") /></code></p>
<p>CF will happily set the value into the myDate property for you, and will only throw an error when you try to save the object.</p>
<h3>Testing type with ormtype values</h3>
<p>As part of the testing that I've been doing to figure this stuff out, I decided to try creating a cfc using all of the available ormtypes, but placing those values in the type attribute, rather than the ormtype attribute.
Here's what that cfc looks like:
<code><cfcomponent persistent="true" output="false">
	<cfproperty name="ID" fieldtype="id" generator="native" />
	<cfproperty name="string" type="string" />
	<cfproperty name="character" ormtype="character" />
	<cfproperty name="char" type="char" />
	<cfproperty name="short" type="short" />
	<cfproperty name="integer" type="integer" />
	<cfproperty name="int" type="int" />
	<cfproperty name="long" type="long" />
	<cfproperty name="big_decimal" ormtype="big_decimal" />
	<cfproperty name="float" type="float" />
	<cfproperty name="double" type="double" />
	<cfproperty name="Boolean" type="Boolean" />
	<cfproperty name="yes_no" ormtype="yes_no" />
	<cfproperty name="true_false" ormtype="true_false" />
	<cfproperty name="text" ormtype="text" />
	<cfproperty name="date" type="date" />
	<cfproperty name="timestamp" ormtype="timestamp" />
	<cfproperty name="binary" type="binary" />
	<cfproperty name="serializable" ormtype="serializable" />
	<cfproperty name="blob" ormtype="blob" />
	<cfproperty name="clob" ormtype="clob" />
</cfcomponent></code></p>
<p>When I reloaded the ORM, it didn't throw any errors, and happily created a table for me with one column for each of those properties. Here's what the generated MySQL table looked like:
<code>CREATE  TABLE `ormBlog_Intro`.`ORMTypeTest` (
  `ID` INT(11) NOT NULL AUTO_INCREMENT ,
  `string` VARCHAR(255) NULL DEFAULT NULL ,
  `character` CHAR(1) NULL DEFAULT NULL ,
  `char` CHAR(1) NULL DEFAULT NULL ,
  `short` SMALLINT(6) NULL DEFAULT NULL ,
  `integer` INT(11) NULL DEFAULT NULL ,
  `int` INT(11) NULL DEFAULT NULL ,
  `long` BIGINT(20) NULL DEFAULT NULL ,
  `big_decimal` DECIMAL(19,2) NULL DEFAULT NULL ,
  `float` FLOAT NULL DEFAULT NULL ,
  `double` DOUBLE NULL DEFAULT NULL ,
  `Boolean` BIT(1) NULL DEFAULT NULL ,
  `yes_no` CHAR(1) NULL DEFAULT NULL ,
  `true_false` CHAR(1) NULL DEFAULT NULL ,
  `text` LONGTEXT NULL DEFAULT NULL ,
  `date` DATE NULL DEFAULT NULL ,
  `timestamp` DATETIME NULL DEFAULT NULL ,
  `binary` TINYBLOB NULL DEFAULT NULL ,
  `serializable` TINYBLOB NULL DEFAULT NULL ,
  `blob` TINYBLOB NULL DEFAULT NULL ,
  `clob` LONGTEXT NULL DEFAULT NULL ,
  PRIMARY KEY (`ID`) )</code></p>
<p>That looks like a pretty close approximation of my types.  
I assume at this point that if no <em>ormtype</em> is specified that CF simply takes whatever is in <em>type</em> and uses it as an <em>ormtype</em>. So, what happens when I try to call the setters for these properties?</p>
<p>I set up a test template with the following code:
<code><cfset ORMTest = EntityNew("ORMTypeTest") />
<cfset valArray = [1,"a",Now(),1.1] />
<cfloop array="#valArray#" index="theVal">
	<cfloop array="#getMetaData(ORMTest).properties#" index="prop">
		<cfif prop.name NEQ "ID">
			<cftry>
			<cfinvoke component="#ORMTest#" method="set#prop.name#">
				<cfinvokeargument name="#prop.name#" value="#theVal#" />
			</cfinvoke>
			<cfoutput>Successfully set #theVal# into #prop.name#<br /><br /></cfoutput>
			<cfcatch type="any"><cfoutput>Error trying to set #theVal# into #prop.name#<br>#cfcatch.detail#<br />#cfcatch.message#<br />#cfcatch.type#<br /></cfoutput></cfcatch>
			</cftry>	
		</cfif>
	</cfloop>
	<cftry>
		<cfset EntitySave(ORMTest) />
		<cfset ormFlush() />
		<cfoutput>Successfully saved the Entity.<br /><br /></cfoutput>
		<cfcatch type="any"><cfoutput>Error saving<br>#cfcatch.detail#<br />#cfcatch.message#<br />#cfcatch.type#<br /></cfoutput></cfcatch>
	</cftry>
</cfloop></code></p>
<p>This code will attempt to set an integer, a string, a date, and a double into each property. If the setter works, I'll see a message on the screen to that extent.
If a setter fails I'll see a message, followed by some of the detail from the cfcatch.  After each property is set with one of those values, I attempt to save the entity.  If the save fails I display the details of the error for that as well. So, what did I find out by running this?</p>
<h3>Invalid Values for Type</h3>
<p>I found that the following values:</p>
<ul>
	<li>character</li>
	<li>big_decimal</li>
	<li>yes_no</li>
	<li>true_false</li>
	<li>text</li>
	<li>timestamp</li>
	<li>serializable</li>
	<li>blob</li>
	<li>clob</li>
</ul></p>
<p>all failed to work at all.  No matter what value I passed into the setters for those properties, I received the same error:
"The XXX argument passed to the setXXX function is not of type XXX."</p>
<p>Where XXX is the datatype/property name.  
I am assuming in this case that CF is treating these as custom types that should correspond to a cfc, and is therefore rejecting any simple values that I pass in. To continue with the experiment, I removed those properties from my object and ran the test code again.</p>
<h3>Results of Calling Setters</h3>
<p>When I passed the value <strong>1</strong> into each of my properties, they all accepted it, except for the <em>binary</em> property, which threw an error. This makes sense as all of those other datatypes should accept an integer as a valid value. My attempt to save the object succeeded.
Hibernate ended up putting a date of 1899-12-31 into my <em>date</em> property, which I assume is the correct translation of the number 1 into a date. I'm not sure if CF, Hibernate or MySQL did that translation.</p>
<p>When I passed the value <strong>a</strong> into each of my properties, the following setters failed: integer, float, boolean, date and binary, which is expected.  What was not expected, however, is that short, int, long and double each accepted the value.  
When I tried to save the object, it failed, not surprisingly. The error message is: "Root cause :org.hibernate.HibernateException: coldfusion.runtime.Cast$NumberConversionException: The value a cannot be converted to a number."
I guess Hibernate wasn't too happy about being asked to put the value <strong>a</strong> into one of those numeric columns.</p>
<p>When I passed the value <strong>Now()</strong> into each of my properties, the following setters failed: integer, boolean and binary, which is expected.  Again, as above, short, int, long and double each accepted the value, as did float, which had previously failed with the value <strong>a</strong>.
Again, when I tried to save the object, it failed. The error message is: "Root cause :org.hibernate.HibernateException: coldfusion.runtime.Cast$OutOfBoundsException: Cannot convert the value 40071.54907407407 to short because it cannot fit inside a short." Makes sense, kinda.</p>
<p>When I passed the value <strong>1.1</strong> into each of my properties, they all accepted it, except for binary and integer. This seems to make sense. When I tried to save the object, if failed.
The error message is: "Root cause :org.hibernate.HibernateException: coldfusion.runtime.Cast$CharCastException: Unable to cast object 1.1 to char.". The column char in the database is defined with a length of 1, so it makes sense that this would fail.
</p>
<h3>What Does It All Mean?</h3>
<p>That's a tough one. I <em>can</em> make the following general observations:
<ol>
	<li>Strictly for the purpose of table creation, you can use any valid ormtype value as a type, and a reasonable table will be created for you by Hibernate.</li>
	<li>You cannot use any of the following ormtype values if you want to be able to call a setter on the property:character, big_decimal, yes_no, true_false, text, timestamp, serializable, blob or clob.</li>
	<li>You can use any of the following ormtype values, but they will not create typed setters: char, short, int, long and double.</li>
	<li>The following ormtype values will create valid typed setters: integer, boolean, date and binary. The interesting item here is <em>integer</em>. 
	As far as I understand integer is not a native CF type. Perhaps that's been added under the hood somewhere.</li>
	<li>The ormtype value float appears to create a typed setter, but it allows a date to be passed.</li>
</ol>
</p>
<p>I guess the bottom line is that you <em>can</em> use ormtype values to specify the datatypes of your properties using the <em>type</em> attribute, which will sometimes result in typed setters, but that perhaps it's not such a good idea.</p>
