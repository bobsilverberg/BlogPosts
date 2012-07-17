Managing Bi-directional Relationships in ColdFusion ORM - Array-based Collections

It's important to know that when you have a bi-directional relationship you should set the relationship on both sides when setting one side. 
There have been a number of discussions about this on the cf-orm-dev google group, including this one
(http://groups.google.com/group/cf-orm-dev/browse_thread/thread/86c9a47f95dcba10/74de895df3ad1897)
in which Barney Boisvert (http://www.barneyb.com/barneyblog/) provides a very
good explanation of why this is important. Brian Kotek (http://www.briankotek.com/blog/) has also written
(http://www.briankotek.com/blog/index.cfm/2009/12/16/Bidirectional-Association-Management-in-ColdFusion-9-ORM)
(http://www.briankotek.com/blog/index.cfm/2009/12/21/More-on-CF9-ORM-Relationships)
two articles on the subject in the past.</p>
<p>While doing some testing of the new CF9 ORM adapter for Model-Glue along with the new scaffolding mechanism that we're developing I ran into a
situation in which I needed to address this issue. I had a many-to-many relationship and I needed to make sure that both sides of the relationship
were being set when one of the objects was updated. Here is what the cfcs in question looked like:
<code>component persistent="true" hint="This is Country.cfc"
{
	property name="CountryId" fieldtype="id" generator="native";
	property name="CountryCode" length="2" notnull="true";
	property name="CountryName" notnull="true";
	property name="Languages" fieldtype="many-to-many" cfc="Language"
		type="struct" structkeycolumn="LanguageName" structkeytype="string"
		singularname="Language" linktable="CountryLanguage";
}

component persistent="true" hint="This is Language.cfc"
{
	property name="LanguageId" fieldtype="id" generator="native";
	property name="LanguageName" notnull="true";
	property name="Countries" fieldtype="many-to-many" cfc="Country"
	type="array"  inverse="true" 
	singularname="Country" linktable="CountryLanguage";
}</code></p>
<p>Because I'm developing a generic routine, in the ORM adapter, which should work for any and all cfcs (meaning that the code that will be running)
won't know that I'm working with these two specific cfcs), I chose to go the route that many suggest for dealing with setting both sides of the
relationship: overriding the methods in the cfcs themselves. This means that I have to override addLanguage() and removeLanguage() in Country.cfc
and I also have to override addCountry() and removeCountry() in Language.cfc. This raised a few issues, which I'm going to discuss below.</p>
<h3>Issue 1: Where's the Object?</h3>
<p>This issue emerges when you're working with a struct-based collection, as the Languages property in our Country object is.
As you no doubt already know if you've been reading my blog, dealing with struct-based collections is a bit different than dealing with array-based
collections. Specifically, the add() method that maintains the collection expects a key and an object to be passed to it, while the remove()
method expects just a key to be passed to it. If we want to override the add and remove methods in our cfcs we need to deal with the fact that the
remove method will not have an object passed to it. Why does that matter? Let's take a look at overriding the methods in Country.cfc:
<code>component persistent="true" hint="This is Country.cfc"
{
	property name="CountryId" fieldtype="id" generator="native";
	property name="CountryCode" length="2" notnull="true";
	property name="CountryName" notnull="true";
	property name="Languages" fieldtype="many-to-many" cfc="Language"
		type="struct" structkeycolumn="LanguageName" structkeytype="string"
		singularname="Language" linktable="CountryLanguage";

	public void function addLanguage(key,object) 
		hint="set both sides of the bi-directional relationship" {
		// set this side
		variables.Languages[arguments.key] = arguments.object;
		// set the other side
		if (not arguments.object.hasCountry(this)) {
			arguments.object.addCountry(this);
		}
	}

	public void function removeLanguage(key) 
		hint="set both sides of the bi-directional relationship" {
		// set this side
		structDelete(variables.Languages,arguments.key);
		// set the other side
		// hmm, where's the other object?
	}
}</code></p>
<p>You can see that overriding the addLanguage() method in Country.cfc is pretty straightforward. 
First we add the Language object that was passed in by putting it into the variables.Languages structure.
Then we set the other side of the realtionship by calling the addCountry() method on the Language object that was passed in, passing this into it
(because this represents the Country that we need to assign to that Language to set both sides of the relationship). 
But what happens in the removeLanguage() method?</p>
<p>You can see that we can easily set the current side by deleting the Language from the variables.Languages structure. 
We can do that because we know the key for that Language in the structure. But when we want to set the value on the other side of the relationship
we don't have a Language object on which we can call removeCountry(), as only the key was passed in. How can we deal with that? 
It's actually quite simple:
<code>component persistent="true" hint="This is Country.cfc"
	public void function removeLanguage(key) 
		hint="set both sides of the bi-directional relationship" {
		// set the other side
		var Language = (structKeyExists(variables.Languages,arguments.key) ? variables.Languages[arguments.key] : "");
		if (isObject(Language)) {
			Language.removeCountry(this);
		}
		// set this side
		structDelete(variables.Languages,arguments.key);
	}
}</code></p>
<p>All we have to do is use the key that was passed in to retrieve the Language object from the variables.Languages array, after which, if one is found,
we can call the removeCountry() method on it. Note that we do this first, before using structDelete() to remove the Language from the Country
because if we did that first we'd no longer be able to get the Language object from the variables.Languages structure.</p>
<p>So we've now solved the "Where's the object" problem, but that's not the only issue facing us.</p>
<h3>Issue 2: Removing Items from an Array</h3>
<p>We have successfully overridden the addLanguage() and removeLanguage() methods in our Country object, so now we must do the same for our
Language object, because code could be setting the relationship from either side. The Language object stores its collection of Country objects as an
array, not a struct, so we don't need to worry about the Where's the Object issue, but we do have to worry about removing an item from an array.
Let's take a look at Language.cfc with the overridden methods: 
<code>component persistent="true" hint="This is Language.cfc"
{
	property name="LanguageId" fieldtype="id" generator="native";
	property name="LanguageName" notnull="true";
	property name="Countries" fieldtype="many-to-many" cfc="Country"
	type="array"  inverse="true" 
	singularname="Country" linktable="CountryLanguage";
	
	public void function addCountry(object) 
		hint="set both sides of the bi-directional relationship" {
		// set this side
		if (not hasCountry(arguments.object)) {
			arrayAppend(variables.Countries,arguments.object);
		}
		// set the other side
		if (not arguments.object.hasLanguage(this)) {
			arguments.object.addLanguage(variables.LanguageName,this);
		}
	}

	public void function removeCountry(object) 
		hint="set both sides of the bi-directional relationship" {
		// set this side
		if (isArray(variables.Countries)) {
			var index = arrayFind(variables.Countries,arguments.object);
			if (index gt 0) {
				arrayDeleteAt(variables.Countries,index);
			}
		}
		// set the other side
		arguments.object.removeLanguage(variables.LanguageName);
	}

}</code></p>
<p>Because the Countries property is an array in the Language object we need to write different code to override the addCountry() and removeCountry() methods.
addCountry() is pretty straightforward; we check to see if the variables.Countries array already has the Language, and if not we append it to the array, 
after which we simply call addLanguage() on the passed Country object, passing in the appropriate key as well as the current object.
The removeCountry() method is a bit more complicated. Because we are overriding the implicit removeCountry() method we need to remove the Country object
from the variables.Countries array manually. That's not as simple as a structDelete() call, instead we first must check that variables.Countries is an array
(it might not be if there are no Countries assigned) and then we use arrayFind to find the index of the passed Country object in that array. Once we
have the index we can then use arrayDeleteAt() to remove the Country object from the array. Finally, we call the removeLanguage() method on the passed
Country object.</p>
<p>This code is getting pretty complicated. I wanted to show how you could accomplish this if you wanted to do it this way, but there is actually a much 
simpler way to do this, which I'll demonstrate momentarily after discussing the next issue.</p>
<h3>Issue 3: How Do You Feel About Infinite Loops?</h3>
<p>If you were to run the code exactly as it is above you'd run into an issue. Can you see what it is?  Let's say I have a Language object and I call
addCountry(Country) on it. Let's also assume that this Country has not already been assigned to the Language object. What's going to happen?
<ol>
	<li>My overridden addCountry() method in Language.cfc will be invoked.</li>
	<li>The passed Country object will be added to the variables.Countries array.</li>
	<li>The addLanguage() method will be called on the passed Country object, passing the current Language object.</li>
	<li>This will invoke my overridden addLanguage() method on the Country object.</li>
	<li>The Language object will be added to the variables.Languages structure in the Country object.</li>
	<li>The addLanguage() method will be called on the passed Country object, passing the current Language object.</li>
</ol>


 add by assigning the object that was passed in

component persistent="true" hint="This is Language.cfc"
{
	property name="LanguageId" fieldtype="id" generator="native";
	property name="LanguageName" notnull="true";
	property name="Countries" fieldtype="many-to-many" cfc="Country"
	type="array"  inverse="true" 
	singularname="Country" linktable="CountryLanguage";
}</code></p>
<h3>Issue 1: Avoiding an Infinite Loop</h3>
<p>You might think that the easiest way of overriding the methods would be something like this:
Here's another tricky issue when working with collections of child objects that are stored as structs. Just like <a href="http://www.silverwareconsulting.com/index.cfm/2010/1/25/More-Fun-with-ColdFusion-ORM-StructBased-Collections">last time</a>, we'll look at a Department object
with a one-to-many property that holds a collection of Users which is stored as a struct. The difference this time is that we'll use a numeric property as the key to the struct,
rather than a string property:
<code>component persistent="true" output="false" entityname="Department" {
	property name="DeptId" fieldtype="id" generator="native";
	property name="Name";
	property name="SIN" ormtype="int";
	property name="Users" fieldtype="one-to-many" type="struct"
		cfc="User" fkcolumn="DeptId" singularname="User"
		structkeycolumn="SIN" structkeytype="int" cascade="save-update";
}</code></p>
<p>The nice thing about having the collection of Users in a struct is that we can access them individually. For example, if we have a Department object and we know we
want the User in that Department with a SIN of 12345, we could simply write:
<code>Department = entityLoad("Department",1);
User = Department.getUsers()[12345];
</code></p>
<p>If you're like me you'd probably think that would work, but it doesn't. You'll get an error like "Element 12345 is undefined in a Java object of type class org.hibernate.collection.PersistentMap." 
That error message is the key, and we'll get back to it in a minute, but for now, just so you can be as frustrated as I was, I'll point out that if I dump out the struct by calling
writeDump(Department.getUsers()), I will see what appears to be a standard ColdFusion struct with a key called 12345. So why, I wondered, can't I get at that key?  I tried a number of different methods:
<code>Department = entityLoad("Department",1);
Users = Department.getUsers();
User = structFind(Users,12345); // nope
User = Users[javacast("int",12345)]; // nope
User = Users[createObject("java","java.lang.Integer").init(12345)]; // nope
</code></p>
<p>Nothing worked! No matter how hard I tried I couldn't get my struct to give me my object. Then I looked at the error message again.  It said "Element 12345 is undefined in a Java object of type class <em>org.hibernate.collection.PersistentMap</em>."
So I Googled <a href="http://www.google.com/search?q=org.hibernate.collection.PersistentMap" target="_blank">org.hibernate.collection.PersistentMap</a> 
and found the <a href="https://www.hibernate.org/hib_docs/v3/api/org/hibernate/collection/PersistentMap.html" target="_blank">pertinent page in the Hibernate documentation</a>.
Lo and behold, the org.hibernate.collection.PersistentMap has a <em>get()</em> method that accepts a key. So I tried:
<code>Department = entityLoad("Department",1);
Users = Department.getUsers();
User = Users.get(javacast("int",12345));
</code></p>
<p>And it worked! I did some experimenting and it seems like this problem will occur with any datatype used as a structkeytype that isn't a string. 
It seems like the problem is that whenever you use standard struct syntax (either struct[key] or structFind(struct,key)) the key is first converted to a string,
and that's why Java cannot find the member. This also would explain why my attempts at casting the value to a Java Integer didn't help.
This seems like a bug to me.  Well, maybe not exactly a bug, but an enhancement that really should be there.  We should be able to get at a member of a collection using standard
struct syntax, without having to resort to calling methods on the underlying Java object.</p>