CF9 ORM Gotcha - Non-String Struct Collection Keys

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