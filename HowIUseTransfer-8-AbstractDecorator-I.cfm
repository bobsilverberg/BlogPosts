How I Use Transfer - Part VIII - My Abstract Transfer Decorator Object - Simple Methods

In the <a href="http://www.silverwareconsulting.com/index.cfm/2008/7/14/How-I-Use-Transfer--Part-VI--My-Abstract-Gateway-Object">past</a> <a href="http://www.silverwareconsulting.com/index.cfm/2008/7/15/How-I-Use-Transfer--Part-VII--A-Concrete-Gateway-Object">two</a> posts in this series about <a href="http://www.transfer-orm.com/">Transfer</a> (an ORM for ColdFusion) I discussed how I have implemented my Abstract and Concrete Gateways.  As you may recall from <a href="http://www.silverwareconsulting.com/index.cfm/2008/6/24/How-I-Use-Transfer--Part-II--Model-Architecture">Part II</a>, that leaves my AbstractTransferDecorator Object as the final abstract object in my model.  There is a lot of code in this object, and I plan to provide a lot of explanation, so I'm going to break this up into a few posts.</p>
<p>My AbstractTransferDecorator acts as a base object for all of my Concrete Decorators, and, because most of my Business Objects are created for me by Transfer, it really acts as an Abstract Business Object.  For a basic overview of what a decorator is, and how one is used with Transfer, check out <a href="http://docs.transfer-orm.com/wiki/Writing_Decorators.cfm">this page</a> from the Transfer docs.</p>
<p>I have blogged about this object a <a href="http://www.silverwareconsulting.com/index.cfm/2007/9/26/A-Generic-Decorator-for-Transfer--A-Populate-Method">few</a> <a href="http://www.silverwareconsulting.com/index.cfm/2008/4/16/Using-Transfer-Decorators-to-Deal-with-Invalid-Data">times</a> <a href="http://www.silverwareconsulting.com/index.cfm/2008/6/17/Using-Transfer-Metadata-to-Create-a-Memento">before</a>, but the posts in this series will, for now, supercede all of those previous posts, as this object continues to change.  In fact, this object has a few methods and techniques the design of which I'm not crazy about right now.  There will definitely be changes coming, at some point down the road.<more/>
I think it's a good idea to start at a high level, so here is a description of the various methods in my AbstractTransferDecorator:
<ul>
	<li><strong>configure()</strong> - This method is called by Transfer after creating an instance of a Transfer Object.  It's basically a decorator's version of the standard Init().</li>
	<li><strong>save()</strong> - This allows the object to save itself.</li>
	<li><strong>delete()</strong> - This allows the object to delete itself.</li>
	<li><strong>onNewProcessing()</strong> - This allows the object to perform actions when a new instance of the object is about to be persisted to the database.</li>
	<li><strong>populate()</strong> - This is used to fill a Transfer Object, and its related objects, with data.  It's kind of like a setMemento() method, if you're familiar with that terminology.</li>
	<li><strong>copyToStruct()</strong> - This allows the object to return a simple struct that contains keys for all of its properties. It's kind of like a getMemento() method, if you're familiar with that terminology.</li>
	<li><strong>validate()</strong> - This contains generic validation routines that are shared by all Business Objects.</li>	
	<li><strong>getValidations()</strong> - This returns an array of validation rules that apply to the Business Object.</li>
	<li><strong>addValidation()</strong> - This is a helper method to make defining validations simpler.</li>
</ul>
</p>
<p>To keep this post reasonably short, we'll address the first four items, starting with configure():
<code>
	<cffunction name="configure" access="private" returntype="void" hint="I am like init() but for decorators">
		<cfset variables.myInstance = StructNew() />
		<cfset variables.myInstance.CleanseInput = true />
	</cffunction>
</code>
</p>
<p>The Configure method will be called by Transfer whenever a new instance of the object is created.  This behaviour is built into Transfer itself.  In here I create a struct to hold any private variables that the Business Object may need, and I set a default value of "true" for CleanseInput. CleanseInput is used by the Populate() method to determine whether or not to cleanse HTML from an object's properties prior to persisting it. This is a technique that I'm still kind of on the fence about.</p>
<p>The save() and delete() methods are both short and sweet:
<code>
	<cffunction name="save" access="public" output="false" returntype="void" hint="Calls Transfer.save().">
		<cfset getTransfer().save(this) />
	</cffunction>

	<cffunction name="delete" access="public" output="false" returntype="void" hint="Calls Transfer.delete().">
		<cfset getTransfer().delete(this) />
	</cffunction>
</code>
</p>
<p>As you can see, save() just calls getTransfer().save(), and delete() just calls getTransfer().delete().  I like this approach as it allows me to minimize references to Transfer in my service layer.  I also personally prefer myObject.save() to myService.save(myObject).</p>
<p>onNewProcessing() is called by the service layer prior to saving a new object. Because most objects don't require this functionality this method remains empty in the AbstractDecorator:
<code>
	<cffunction name="onNewProcessing" access="public" output="false" returntype="void" hint="Extra processing required for a new record.">
		<cfargument name="args" type="any" required="true" />
	</cffunction>
</code>
</p>
<p>I originally tried to use the <a href="http://docs.transfer-orm.com/wiki/Using_the_Transfer_Event_Model.cfm#BeforeCreate">BeforeCreate event</a> of Transfer's Event Model for this, but the processing that I wanted to do required data submitted by the user, and the Event Model does not provide a way to pass that in.  That is why this method accepts the args argument, which will contain all of the data from the attributes scope (everything the user submitted).</p>
<p>In the next post, I'll walk through the populate() method, which is the largest method in this object.</p>
