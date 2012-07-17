CF9 ORM Gotcha - Adding Items to a Struct Collection

I was just bitten by this one, so I thought I'd quickly blog it to help anyone else who comes across it. 
If you've got a one-to-many or a many-to-many property in your ColdFusion ORM entity, and you've specified that the collection of objects should be stored as a struct, when
adding an item to that struct you must pass both the key for the item and the item itself into the add method. For example, using the following Department object:
<code>component persistent="true" output="false" entityname="Department" {
	property name="DeptId" fieldtype="id" generator="native";
	property name="Name";
	property name="Users" fieldtype="one-to-many" type="struct"
		cfc="User" fkcolumn="DeptId" singularname="User"
		structkeycolumn="UserName" structkeytype="string" cascade="save-update";
}</code></p>
<p>Forgetting that I had to specify the key for the struct as well as the object, my first take at adding a User object to the Department's collection of Users was something like this:
<code>Department = entityLoad("Department",1);
User = new User();
User.setUserName("Bob");
Department.addUser(User);
entitySave(Department);</code></p>
<p>Unfortunately, this code throws an error stating "The User parameter to the ADDUSER function is required but was not passed in."
Being a bit dim-witted, I was totally confused by this. "Hey," I said to my computer, "I know that I'm passing a User object into the method."
It took me awhile to remember that I had to pass both key to the struct and the User object into the addUser() method. Changing the code to:
<code>Department = entityLoad("Department",1);
User = new User();
User.setUserName("Bob");
Department.addUser("Bob",User);
entitySave(Department);</code></p>
<p>Did the trick. So remember:
<ul>
	<li>When adding an item to a collection that is a struct, you must pass both the key to the struct and the object into the add method.</li>
	<li>You must pass the key to the struct in as the first argument, and the object as the second argument.</li>
</ul>
</p>
<p>Conversely, when removing an item from a struct collection using the remove method, you only need specify the key to the struct. I hope this tidbit saves someone else the time that ColdFusion stole from me. ;-)</p>
