<html>
CFinNC an Unqualified Success

I'm on the plane on the way home from CFinNC, a ColdFusion / Flex / AIR conference organized by Jim Priest, Dan Wilson, and the entire Triangle Area ColdFusion User Group. It was, quite frankly, outstanding. For a first-time, free conference everything ran smoothly, the sessions were pertinent, informative, and, dare I say, fun. I have been to a number of ColdFusion conferences in the past and CFinNC ranked right up there with them.  In fact, I'd say it was far better than a few of the smaller, not-free conferences that I've attended.  So conratulations to the whole CFinNC team for pulling off an amazing feat.
</p>
<p>
I enjoyed all of the presentations that I attended, and there were a few on my list that I didn't get a chance to see, either because I was presenting at the time, or because there were multiple simultaneous sessions that I wished to attend. That in itself is a testament to the quality of speakers and topics that the team brought together.
dFor this example, let's assume we have a User object and a Department object.  The Department has a collection of Users, like so:
<code>component persistent="true" output="false" entityname="Department" {
	property name="DeptId" fieldtype="id" generator="native";
	property name="Name";
	property name="Users" fieldtype="one-to-many" type="array"
		cfc="User" fkcolumn="DeptId" singularname="User";
}
</code>
</p>
<p>Let's also say that Department 1 currently has 3 Users assigned to it, call them User1, User2 and User3. Now, we want to write some code that will empty the Department's collection of Users. 
A first attempt might look something like:
<code>Users = Department.getUsers();
for (i = 1; i LTE ArrayLen(Users); i = i + 1) { 
	Department.removeUser(Users[i]);
}
</code>
</p>
<p>But this won't work.  In fact, if you run that code you'll see that you end up with a Department that still has User2 assigned to it. 
The reason this happens is that as soon as you remove User1 from the collection, the array shrinks, so User2 now occupies position 1 and User3 occupies position 2.
So the next time through the loop, User3 gets removed (because i now equals 2) and Users[2] is User3. Then the loop finishes because the condition is met.
</p>
<p>You might want to try doing an array loop using tags, like this:
<code><cfset Users = Department.getUsers() />
<cfloop array="#Users#" index="i">
	<cfset Department.removeUser(i) />
</cfloop>
</code>
</p>
<p>Nope, this throws an error. CF sets the length of the array at the beginning of the loop, so by the time it's inside the third iteration it's trying to access Users[3], which no longer exists.</p>
<p>There are a couple of ways of achieving the objective. The simplest, is to call the setter for the collection and pass in an empty array:
<code>Department.setUsers([]);</code>
</p>
<p>Another is to forget about trying to loop over the array, and instead do a conditional loop based on the current size of the array:
<code>Users = Department.getUsers();
while (ArrayLen(Users)) { 
	User.removeDept(Users[1]);
}
</code>
</p>
<p>Personally, I prefer the latter approach. The first seems a bit hacky to me, although both of them require that you program to the implementation of the collection (you are
writing code expecting the collection to be an array). One way to make that a bit less painful would be to move whichever method you choose into the actual object itself.
For example, in the Department object, add the following method:
<code>function void removeAllUsers() {
	var Users = this.getUsers();
	while (ArrayLen()) { 
		this.removeDept(Users[1]);
	}
}
</code>
</p>
<p>Now you can call removeAllUsers() from outside of the object (e.g., from a Service) and nothing other than the object will have to know that your collection has been
implemented as an array.
</p>
<p>OK, so I snuck an OO design principle into my Quick Tip. It was hard to resist.</p>
</html>