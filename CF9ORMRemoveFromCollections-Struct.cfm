CF9 ORM Quick Tip - Removing all items from a collection defined as a structure

I wrote a <a href="http://www.silverwareconsulting.com/index.cfm/2009/10/13/CF9-ORM-Quick-Tip--Removing-All-Items-from-A-Collection">Quick Tip awhile back</a> on removing all items from a collection, which a number of folks were kind enough to comment on and provide even better solutions.
I was recently faced with the same problem, but this time I wanted to remove all items from a collection that was defined as a structure (last time it was an array).
My initial code generated an error, so I had to get creative. I'm putting this out there to see if anyone has any better ideas for doing this.</p>
For this example, let's assume we have a User object and a Department object. The User object is defined like this:
<code>component persistent="true" output="false" entityname="User" {
	property name="UserId" fieldtype="id" generator="native";
	property name="UserName";
}</code></p>
<p>The Department has a collection of Users, like so:
<code>component persistent="true" output="false" entityname="Department" {
	property name="DeptId" fieldtype="id" generator="native";
	property name="Name";
	property name="Users" fieldtype="one-to-many" type="struct"
		cfc="User" fkcolumn="DeptId" singularname="User"
		structkeycolumn="UserName" structkeytype="string";
}</code></p>
<p>Let's also say that Department 1 currently has 3 Users assigned to it, call them User1, User2 and User3. Now, we want to write some code that will empty the Department's collection of Users. 
A first attempt might look something like:
<code>Users = Department.getUsers();
for (user in Users) {
	Department.removeUser(user);
}</code></p>
<p>Unfortunately, this code throws a <em>java.util.ConcurrentModificationException</em> error. A bit of <a href="http://www.google.ca/search?q=java.util.ConcurrentModificationException+HashMap" target="_blank">Googling</a>
led me to believe that this is an issue with the way Hibernate is manipulating the collection, which is a Java HashMap. 
It sounds like when you're iterating over a HashMap you must ask the iterator to remove an item, rather than removing it yourself.
This sounds like a bug in Hibernate, but I'd be very surprised if there were such an obvious bug in Hibernate, so maybe it has something to do with the way
that Hibernate has been integrated into CF.  Either way, it simply doesn't work, so I needed to come up with another way of removing all of the items from the collection.
</p>
<p>As with my last post on the topic, the simplest way to achieve this is to call the setter for the collection and pass in an empty struct:
<code>Department.setUsers({});</code></p>
<p>The way that I ended up doing it was to use a while loop, checking whether the collection has any remaining items, and to remove the first item in the collection inside the loop.
It looks like this:
<code>Users = Department.getUsers();
while (Department.hasUser()) {
	user = listFirst(structKeyList(Users));
	Department.removeUser(user);
}</code></p>
<p>As discussed in the last post, I prefer the latter approach. The first seems a bit hacky to me, although both of them require that you program to the implementation of the collection 
(you are writing code expecting the collection to be a structure). Also as discussed previously you could make that a bit less painful by moving the code into the actual object itself.
For example, in the Department object, add the following method:
<code>function void removeAllUsers() {
	var Users = this.getUsers();
	while (this.hasUser()) {
		Department.removeUser(listFirst(structKeyList(Users)));
	}
}</code></p>
<p>Now you can call removeAllUsers() from outside of the object (e.g., from a Service) and nothing other than the object will have to know that your collection has been
implemented as a structure.</p>
<p>What other methods can people think of for achieving this?</p>
