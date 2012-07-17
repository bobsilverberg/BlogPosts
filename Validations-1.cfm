ValidateThis! - An Object Oriented Approach to Validations

I have <a href="http://www.silverwareconsulting.com/index.cfm/2008/6/23/How-I-Use-Transfer--Part-I--Introduction">written</a> in the past about the <a href="http://www.silverwareconsulting.com/index.cfm/2008/6/24/How-I-Use-Transfer--Part-II--Model-Architecture">approach</a> I take to building an object oriented model layer for my ColdFusion applications.  For the most part I was happy with the way I designed things and the code that I wrote.  There was one area, however, that I was never really that pleased with; validations.</p>
<p>So I spent the past several weeks working on a whole new approach to doing validations, and I am now ready to share it with anyone who is interested.  Because I intend for this to become a standard tool in my development toolset, I am going to refer to it as a Validation Framework.  I'm not sure if that is an appropriate use of the term, but it's my code and my blog, so that's what I'm going to call it. 
</p>
<p>I had the following goals for my validation framework:
<more/>
<h3>Flexible Validations</h3>
<p>It should be possible to create an unlimited number of validation types, and any validation type imaginable should be possible.  It should be possible to create new validation types without having to touch any of the existing framework code.  Examples of validation types are:
<ul>
	<li>Required - which includes three variations:
		<ul>
			<li>Simple - this field is always required</li>
			<li>Dependent - this field is required if field x is supplied</li>
			<li>Conditional - this field is required if condition x is true</li>
		</ul>
	</li>
	<li>EqualTo - the value of this field must be equal to the value of field x</li>
	<li>Min - the value of this field must be at least x</li>
	<li>MinLength - the length of this field must be at least x</li>
	<li>Range - the value of this field must be between x and y</li>
	<li>RangeLength - the length of this field must be between x and y</li>
	<li>Date -  the value of this field must be a date</li>
	<li>Email -  the value of this field must be an Email Address</li>
	<li>Custom - allows for a method to be defined inside the Business Object that returns either true or false</li>
</ul>
</p>
<p>It should also be possible to create an unlimited number of client-side validation implementations, and a new implementation can be created without having to touch any of the existing framework code.  An implementation is a way of converting the business rules into JavaScript code.  Examples of implementations are:
<ul>
	<li>jQuery Validation Plugin</li>
	<li>qForms</li>
	<li>Any homegrown JS validation scheme</li>
</ul>
<more/>
<h3>Code Generation</h3>
<p>One should be able to define the validation rules as business rules, and the framework will generate all server-side and client-side validation code automatically.  Examples of validation rules are:
<ul>
	<li>UserName is required</li>
	<li>UserName must be between 5 and 10 characters long</li>
	<li>UserName must be unique</li>
	<li>Password must be equal to VerifyPassword</li>
	<li>If ShippingType is "Express", a ShippingMethod must be selected</li>
</ul>
<p>	
The framework should be able to generate generic, but specific, validation failure messages, any of which can be overridden by an application developer.  Examples of generic failure messages corresponding to the example rules above are:
<ul>
	<li>The User Name is required.</li>
	<li>The User Name must be between 5 and 10 characters long.</li>
	<li>The User Name must be unique.</li>
	<li>The Password must be the same as the Verify Password.</li>
	<li>The Shipping Method is required when selecting a Shipping Type of "Express".</li>
</ul>
</p>
<h3>Flexible Feedback</h3>
<p>The framework should return flexible metadata back to the calling application which will allow for customization of how the validation failures will appear to the user.  This metadata will include more than just the failure messages generated.  The framework will not dictate in any way how the view will communicate validation failures to the user.</p>
<p>Any invalid values supplied by a user should be returned by the Business Object when requested.  For example, if one has a Product Business Object with a Price property that can only accept numeric data, if a user provides the value "Bob" in the Price field of a form, when the Product object is returned to the view calling getPrice() will return the value "Bob".</p>
<h3>Persistence Layer Agnostic</h3>
<p>Although I am currently using Transfer, and have designed the framework to work with Transfer, that should be irrelevant to the framework.  It should be possible to implement the framework, without making any modifications, into a model that uses any ORM or no ORM at all. The only requirement is that the model makes use of Business Objects.</p>
<h3>MVC Framework Agnostic</h3>
<p>It should be possible to implement the framework in any application using any MVC framework.  That would include Fusebox, Model-Glue, Mach-II, ColdBox, and any homegrown MVC framework.  This kind of goes without saying, as the framework is specific to the model layer of your application.</p>
<p>I believe that I have come up with an initial version of the framework that meets all of the above goals.  I plan to write a number of posts explaining how I have designed this framework, why I made the choices I have made, and reviewing all of the code.  Hopefully I will receive some feedback that will allow me to improve the framework, after which I hope to release it on RIAForge.</p>
