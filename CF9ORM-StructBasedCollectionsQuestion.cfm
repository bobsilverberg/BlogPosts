More Fun with ColdFusion ORM Struct-Based Collections

<a href="http://www.bennadel.com" target="_blank">Ben Nadel</a> asked a question in a comment to my <a href="http://www.silverwareconsulting.com/index.cfm/2010/1/19/CF9-ORM-Gotcha--Adding-Items-to-a-Struct-Collection">last post about struct-based collections with ColdFusion ORM</a>
which I thought was quite interesting and deserved some investigation. To recap the previous post, it simply pointed out that in order to add an object to a struct-based collection, when
calling the add method one must pass both the object to be added to the collection and the key to be used in the struct. This raised a great question from Ben, whom I quote:</p>
<blockquote>
<p>Does the ORM system do any validation on the Key that you pass in? Does it affect the way the data is persisted to the database (or will the persistence use the value as defined by the CFProperty structKeyColumn)?</p>
</blockquote>
<p>I'd never tested this myself, so I did just that, and what I found was somewhat surprising.<more/>
I interpreted the question as this: Because you define the property of the child object that is meant to be used as a key in the structure, what happens if you pass a value into the add method
that is not the same as the value of the property of the child object? That's a bit of a mouthful, so let's look at an example. Consider the following Department entity:
<code>component persistent="true" output="false" entityname="Department" {
	property name="DeptId" fieldtype="id" generator="native";
	property name="Name";
	property name="Users" fieldtype="one-to-many" type="struct"
		cfc="User" fkcolumn="DeptId" singularname="User"
		structkeycolumn="UserName" structkeytype="string" cascade="save-update";
}</code></p>
<p>We don't even need to look at the User entity, as for the purposes of this test we just need to know that the User entity has a property called <em>UserName</em>, and we know that to be
the case because the <em>Users</em> collection in the Department entity specifies a structkeycolumn of <em>UserName</em>. This tells us that for the structure that will be returned 
whenever we call <em>getUsers()</em> on a Department object, the keys in that structure will be the value of <em>UserName</em> for each individual User object. Let's take a look at
some code which would create a User and add it to a Department:
<code>U = new User();
U.setUserName("Bob");
entitySave(U);
D = entityLoadByPK("Department",1);
D.addUser("Bob",U);
entitySave(D);
ormFlush();
writeDump(D);
</code></p>
<p>The results of Dumping the Department object look like this:</p>
<img src="/images/structBased1.jpg" class="float=left" />
<p>Now, let's try messing with ColdFusion by passing a key value into the add method that doesn't match the actual value of the UserName property:
<code>U = new User();
U.setUserName("Bob");
entitySave(U);
D = entityLoadByPK("Department",1);
D.addUser("Ben",U);
entitySave(D);
ormFlush();
writeDump(D);
</code></p>
<p>Now the results of Dumping the Department object look like this:</p>
<img src="/images/structBased2.jpg" class="float=left" />
</p>
<p>Notice that the <em>UserName</em> property of the embedded User object still contains "Bob", but the key to the structure is "Ben", which is the value we passed into the <em>addUser()</em> method.
Perhaps that's not surprising, as that's exactly what we told ColdFusion to do, but it does seem invalid, doesn't it?</p>
<p>One thing to note here is that we're calling <em>writeDump(D)</em> after
<em>ormFlush()</em>, which means that the data for our objects has been written to the database, <strong>but</strong>, the variable <em>D</em> is still pointing to the object that is in the
current request, so it doesn't necessarily reflect the data that was written to the database. If we want to know what the object that was just written to the database looks like, we have to retrieve a fresh copy from the database.
In order to do that we're going to close the ORM session after calling <em>ormFlush()</em>, and then retrieve a fresh copy of the Department object from the database using <em>entityLoadByPK()</em>:
<code>U = new User();
U.setUserName("Bob");
entitySave(U);
D = entityLoadByPK("Department",1);
D.addUser("Ben",U);
entitySave(D);
ormFlush();
ormCloseSession();
D = entityLoadByPK("Department",1);
writeDump(D);
</code></p>
<p>Now the results of Dumping the Department object look like this:</p>
<img src="/images/structBased3.jpg" class="float=left" />
</p>
<p>Aha! Look at that. The value of the <em>UserName</em> property in the User object now <em>does</em> match the value of the key in the struct of Users, but, it has actually been changed to
the value that we passed into our key.  So the value of the <em>UserName</em> property was actually modified by calling <em>D.addUser("Ben",U)</em>. That is not what I expected to happen,
but I suppose it makes sense. The mismatch had to be resolved somehow, and I <em>did</em> specifically tell ColdFusion that I wanted the value to be "Ben", so it went ahead and changed
the UserName property to be "Ben".</p>
<p>To try to understand why this was happening I took a look at the SQL that was generated for the <em>addUser()</em> call. It looks like this:
<code>update `User` 
set DeptId=?, UserName=? 
where UserId=?

HIBERNATE DEBUG - binding '1' to parameter: 1
HIBERNATE DEBUG - binding 'Ben' to parameter: 2
HIBERNATE DEBUG - binding '1' to parameter: 3
</code></p>
<p>So, whenever an add method is called on a struct-based collection it generates an update on the child object which sets both the parent (as is obviously needed) and the value of the
structkeycolumn, which is what surprises me. I guess this is just how Hibernate is designed to work with struct-based collections, so I wouldn't call this a bug,
but I would call it unexpected behaviour and something that we all need to be aware of.</p>
<p>Of course, I think it's perfectly
valid to suggest that a developer should never write code like this, and if one does then they get what they deserve. If you write code that doesn't make sense then you shouldn't
have an expectation that the result will make sense. As I often say to my son, "Ask a silly question...".</p>
