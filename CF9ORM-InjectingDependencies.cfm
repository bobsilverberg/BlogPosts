Injecting Dependencies into CF9 ORM Entities

There has been a bit of discussion in the blogs about injecting dependencies into ORM entities so I thought I'd chime in with the method that I've developed. 
<p>
When I started working with ColdFusion 9's ORM capabilities I quickly ran into situations in which I wanted to inject other objects into my persistent objects.  I suppose this raises a couple of questions, namely:
<ul>
	<li>What do you mean, <em>inject other objects into persistent objects</em>?</li>
	<li>Why would I want to inject other objects into my persistent objects?</li>
</ul>
</p>
<p>So let's address those first.</p>
<h3>What do you mean, <em>inject other objects into persistent objects</em>?</h3>
<p>First off, I'm using the term persistent object to refer to a ColdFusion 9 cfc that has a <em>persisten="true"</em> attribute.  
That is, an object that has been created from a cfc that will be persisted to a database via Hibernate, using CF9's ORM integration.  
These are variously referred to as persistent objects, ORM objects, entity objects, etc. 
So when I say <em>other objects</em>, I mean objects that have been created from cfcs that do not have a <em>persisten="true"</em> attribute. 
That is, the plain old objects that we're used to working with in CF 6, 7 and 8.
So, when I say <em>injecting other objects</em> into a persistent object I simply mean that we pass a reference to one of those <em>plain jane</em> objects to the persistent object, 
and store it inside the persistent object, often in the <em>variables</em> scope.
That leads us nicely to the next question:
</p>
<h3>Why would I want to inject other objects into my persistent objects?</h3>
<p>The main reason that I inject other objects into a persistent objects is to add behaviour to my persistent object.
Some examples of that include:
<ul>
	<li>To allow the object to validate itself by injecting a <em>Validator</em> object.</li>
	<li>To allow the object to save and delete itself by injecting a <em>Gateway</em> object.</li>
	<li>To allow the object to interact with the file system by injecting a <em>FileSystem</em> object.</li>
	<li>To allow the object to interact with other, unrelated objects by injecting a <em>Service</em> object.</li>
</ul>
</p>
<p>By injecting one of the above mentioned objects into my persistent object I can then ask the persistent object to do things that it doesn't really know how to do.  
So, for example, I can keep the logic for validation and ORM access encapsulated in other objects (a Validator and Gateway respectively), but still add the desired behaviour to my persistent object.
I describe the relationship between the persistent object and the <em>other</em> object as a dependency because the persistent object <em>depends</em> on the other object to get its job done.</p>
<p>OK, now that the what and thew why are out of the way, it's time to address the how.</p>
<h3>How do I inject other objects into my persistent objects?</h3>
<p>As discussed above, injecting other objects into your persistent objects involves passing a reference to the <em>other</em> object into a method of your persistent object and then storing it,
 ususally in the <em>variables</em> scope. So, in order to inject a dependency we need a method into which we can pass the other object.  
To avoid having to keep using generic language like <em>other object</em>, for the remainder of this post let's assume that we have a persistent <em>User</em> object, 
and that we want to inject a <em>Validator</em> object into it. Let's take a quick peek at out User.cfc as it stood before we realized that we needed to inject a Validator into it:
<code><cfcomponent persistent="true" entityname="User" table="tblUser" >
	<cfproperty name="UserId" fieldtype="id" generator="native" />
	<cfproperty name="UserName" />
	<cfproperty name="UserPass" />
</cfcomponent></code>
</p>
<p>We now realize that we want to inject a Validator object into this User object, and therefore we need a method to do that. 
Now, if this were not a persistent object we could use the constructor for this purpose. 
The constructor is a method that needs to get called in order to properly create an instance of the component. It is common practice in ColdFusion to create a method called init() for this purpose.
In fact, CF9's ORM features will automatically call the init() method for you when it creates an object, and that is precisely the problem. 
Because CF9 does this in the background there is no opportunity to pass anything into the init() method, except when you are creating a new, empty object. 
Therefore, it is not possible to pass a reference to our Validator object into the init() method of our User object when we are working with an existing object (i.e., an object obtained via EntityLoad()).
This means that we need to define an alternate method, which we can call ourselves, and pass in a reference to the Validator object.
It was common practice, pre-CF9 to create a <em>setter</em> method for this.  In our example that would involve creating a method called <em>setValidator()</em> that would look something like this:
<code><cffunction name="setValidator" returntype="void" access="public" output="false">
	<cfargument name="Validator" type="any" required="true" />
	<cfset variables.Validator = arguments.Validator />
</cffunction></code>
</p>
<p>Thanks to CF9's implicit getters and setters we no longer have to create this <em>setValidator()</em> method. 
We can simply add a cfproperty tag for a <em>Validator</em> property and CF9 will automagically create the setter for us:
<code><cfcomponent persistent="true" entityname="User" table="tblUser" >
	<cfproperty name="UserId" fieldtype="id" generator="native" />
	<cfproperty name="UserName" />
	<cfproperty name="UserPass" />
	<cfproperty name="Validator" persistent="false" />
</cfcomponent></code>
</p>
<p>Note that we specify the <em>persistent</em> attribute of the Validator property to be <em>false</em>, because Validator is not a property that we need to be persisted to the database.
We are only using it to store an object that will be used by an active instance of our cfc.</p>
<p>OK, now we can call setValidator() on our User object and whatever we pass in will be stored in variables.Validator, whence it can be retrieved when the time comes to validate the object. 
So how do we pass a reference to our Validator object into the setValidator() method?  The most basic example would be something like this:
<code><cfset User = EntityLoad("User",1,true) />
<cfset Validator = New Validator() />
<cfset User.setValidator(Validator) /></code>
</p>
<p>And we now have a reference to our Validator object inside our User object. But we all know that using New() or CreateObject() throughout our code is not a great idea, which is one of the reasons that
Coldspring was developed, so we'll use Coldspring to manage our Validator object for us:
<code><cfset User = EntityLoad("User",1,true) />
<cfset User.setValidator(application.beanFactory.getBean("Validator")) /></code>
</p>
<p>That's a bit better, but wouldn't it be even better if we could have that dependency injected into our User object when it was created, rather than having to do it manually each time we asked for an object?
 Enter CF9's ORM EventHandler.</p>
<h3>Using an EventHandler to Inject Dependencies</h3>
<p>The EventHandler is a cfc that must implement the <em>CFIDE.ORM.IEventHandler</em> interface, and that has methods that fire whenever certain ORM events take place.  
These events include loading objects, and inserting, updating and deleting records in underlying tables. So, in order to have our Validator injected automatically into our User object
 we can harness the power of the EventHandler's <em>preLoad()</em> method. 
An in-depth discussion of the EventHandler is outside the scope of this article, but here's a snippet of a preLoad() method that would inject a Validator object into all persistent objects:
<code>public void function preLoad(any entity) {
	arguments.entity.setValidator(application.BeanFactory.getBean("Validator"));
}
</code>
</p>
<p>So, what's wrong with that? Well, first off it will inject a Validator object into each and every persistent object in our system.  Maybe we don't want that. 
We could add some conditional code that checks to see whether the object expects a Validator and then only inject into those objects.
But maybe we want a UserValidator injected into all User objects and a ProductValidator injected into all Product objects. 
That conditional code would get pretty ugly pretty quickly. And wait, we probably don't just have Validators to inject.  
We may have lots of different objects that need to be injected into different persistent objects. 
All of the sudden we're maintaining information about dependencies within our Eventhandler, and isn't that what Coldspring is supposed to be doing for us?</p>
<p>Yes, it is.  And thanks to Brian Kotek, it can!  Enter Brian's BeanInjector.</p>
<h3>Using the BeanInjector to Inject Dependencies</h3>
<p>Brian created a BeanInjector component which works in conjunction with Coldspring to <em>autowire</em> a component.  
In a nutshell what this means is that it is able to match up setters in a component to bean definitions in Coldspring and automatically inject dependencies into objects. 
Again, it's not really possible to go into much detail about the BeanInjector in this article, so let's just look at a snippet that will allow the BeanInjector to autowire your persistent objects for you:
<code>public void function preLoad(any entity) {
	application.BeanFactory.getBean("BeanInjector").autowire(arguments.entity);
}
</code>
</p>
<p>Yes, it's really as simple as that! With that single line of code, and with some configuration in Coldspring, of course, all of your persistent objects will get injected with any required dependencies.
For example, if our User object requires a UserValidator object, a FileSystem object and a UserGateway object, we would define our User like so:
<code><cfcomponent persistent="true" entityname="User" table="tblUser" >
	<cfproperty name="UserId" fieldtype="id" generator="native" />
	<cfproperty name="UserName" />
	<cfproperty name="UserPass" />
	<cfproperty name="UserValidator" persistent="false" />
	<cfproperty name="FileSystem" persistent="false" />
	<cfproperty name="UserGateway" persistent="false" />
</cfcomponent></code>
 </p>
<p>As long as there are beans defined to Coldspring for UserValidator, FileSystem and UserGateway they will automatically be injected into any User objects loaded via the EntityLoad() function. 
But what about new entities, you may ask? Yes, that's a bit of a problem.  
New entities, those created via <em>CreateObject()</em>, <em>EntityNew()</em> or the <em>New</em> operator will not have the preLoad() EventHandler method called on them, so they won't get autowired. 
Unfortunately, as of the current beta version of CF9, there is no way to automatically inject dependencies into new objects. Well, that's a bit harsh. 
We can still use the BeanInjector to autowire our new objects, but we have to ask that it be done for us. We cannot rely on an EventHanlder to ensure that it gets done automactially.
Let's take a look at some code that will do that for a new User object:
<code><cfset User = EntityNew("User") />
<cfset application.BeanFactory.getBean("BeanInjector").autowire(User)</code>
</p>
<p>That's actually quite simple, but it does mean that every time we create a new persistent object we need to remember to ask the BeanInjector to autowire it for us.
My solution to that issue is to use a Service object to create all of my persistent objects, and to have an AbstractService object which contains the logic to do the autowiring.
That way, I simply ask my Service for an object and it will take care of the autowiring, meaning that I don't have to remember to write that extra line of code every time I create a new object. I will describe that in detail in a future article.</p>
