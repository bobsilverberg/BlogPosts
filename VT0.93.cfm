ValidateThis 0.93 - Automatic Property Descriptions

I've just released version 0.93 of ValidateThis, my validation framework for ColdFusion objects. 
It includes a small bug fix that affected the dependentPropertyValue param when used with ColdFusion ORM objects, and 
also includes one small enhancement.
</p>
<h3>Automatic Property Descriptions</h3>
<p>Until the release, if you wanted the description of your property to be different from its name, you had to provide a <em>desc</em> attribute for the
property in the xml file. For example, you might have a property called <em>firstName</em>. 
In order to have ValidateThis generate failure messages with <em>First Name</em> in them you would have had to add 
<pre>desc="First Name"</pre>
to your property definition.</p>
<p>While working on my presentation for cf.Objective() I realized that I could relieve some of this burden by allowing the framework to do this for you automatically.
So now, as of version 0.93, any property names that are camelCased will be automatically assigned descriptions, which will comprise of each word capitalized.
So <em>firstName</em> becomes <em>First Name</em> and <em>numberOfCarsOwned</em> becomes <em>Number Of Cars Owned</em>, etc.</p>
<p>I'm finding this very useful, and I hope others will too.</p>
<p>As always, the latest code is available from <a href="http://validatethis.riaforge.org/" target="_blank">the ValidateThis RIAForge site</a>,
and if you have any questions about the framework, or suggestions for enhancements, 
please send them to the <a href="http://groups.google.com/group/validatethis" target="_blank">ValidateThis Google Group</a>.
</p>

