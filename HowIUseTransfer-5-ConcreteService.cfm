How I Use Transfer - Part V - A Concrete Service Object

I was going to describe my Abstract Gateway Object in this post, but during a conversation with a fellow developer it was suggested that I should take a moment to describe a Concrete Service Object, as there was still a bit of confusion in his mind about how I use the Abstract Service Object.</p>
<p>To recap a bit, I have a Abstract Service Object and it is used as an extension point for most of my Concrete Service Objects.  Perhaps a bit more of a definition is in order.</p>
<ul><strong>The Abstract Service Object</strong>
	<li>Is never instantiated as an object.</li>
	<li>Cannot be used as is.</li>
	<li>Is only ever used as a base object for Concrete Service Objects.</li>
	<li>There is only one Abstract Service Object, called AbstractService.cfc.</li>
	<li>Does not have any Transfer classes associated with it.</li>
</ul>
<ul><strong>Concrete Service Objects</strong>
	<li>Are instantiated as objects.</li>
	<li>Methods on them are called by Controllers, other Concrete Service Objects and Business Objects.</li>
	<li>Most extend AbstractService.cfc.</li>
	<li>There are many Concrete Service Objects, e.g., UserService.cfc, ProductService.cfc, ReviewService.cfc, etc.</li>
	<li>Have one "main" Transfer class associated with them, but can interact with others via code specific to the Concrete Service.</li>
</ul>
<p>I'll digress for a moment to discuss the comment that "Most extend AbstractService.cfc."  Really, the Abstract Service Object is a starting point for all Service Objects that persist their data in a database, like UserService, ProductService, etc.  If a Service Object does not persist data in a database, it really gains nothing by extending AbstractService.  For example, I have a CartService Object, which only persists data in the session scope.  Therefore my CartService Object does not extend AbstractService.</p>
<p>Let's take a look at an example of a Concrete Service Object, ReviewService.cfc.  To start, here's the Bean definition of this service from my Coldspring config file:
<code>
<bean id="ReviewService" class="model.service.ReviewService">
	<property name="TransferClassName"><value>product.review</value></property>
	<property name="EntityDesc"><value>Review</value></property>
	<property name="TheGateway">
		<ref bean="ReviewGateway" />
	</property>
</bean>
</code>
</p>
<p>In here I indicate that the main Transfer class with which this service interacts is
<em>product.service</em>.  That means that calls to Get(), Update() and Delete() will be directed at the table defined to Transfer as product.review.  I can write additional methods in my service that will interact with other Transfer classes, but the default methods, inherited from the AbstractService, will be directed at product.review.</p>
<p>I also indicate that the description of the main class is <em>Review</em>.  That will be used for UI messages (e.g., "The Review has been updated").  And I specify that the <em>ReviewGateway</em>, which is defined in a separate Coldspring bean, is the default Gateway Object for this service.  That means that calls to GetList() will be directed at that Gateway Object.</p> 
<p>And here's the code for ReviewGateway.cfc:
<code>
<cfcomponent displayname="ReviewService" output="false" hint="I am the service layer component for the Review model." extends="AbstractService">

<cffunction name="Get" access="Public" returntype="any" output="false" hint="I override the abstract get in order to determine the proper ReviewId for a member.">
	<cfargument name="theId" type="any" required="yes" />
	<cfargument name="needsClone" type="any" required="false" default="false" />
	<cfargument name="args" type="any" required="no" default="" />

	<cfset var TQL = "" />
	<cfset var TQuery = "" />
	<cfset var qryReview = "" />
	<cfset var ReviewId = 0 />
	
	<cfif StructKeyExists(arguments.args,"CurrentUser")>
		<cfif arguments.args.CurrentUser.IsAdmin()>
			<cfset ReviewId = arguments.theId />
		<cfelse>
			<cfsavecontent variable="TQL">
				<cfoutput>
					SELECT	Review.ReviewId
					FROM	product.review AS Review
					JOIN	product.product AS Product
					JOIN	user.user AS TUser
					WHERE	TUser.UserId = :UserId
					AND		Product.ProductId = :ProductId
				</cfoutput>
			</cfsavecontent>
			<cfset TQuery = getTransfer().createQuery(TQL) />
			<cfset TQuery.setParam("UserId",arguments.args.CurrentUser.getUserId()) />
			<cfset TQuery.setParam("ProductId",arguments.args.ProductId) />
			<cfset TQuery.setCacheEvaluation(true) />
			<cfset qryReview = getTransfer().listByQuery(TQuery) />
			<cfif qryReview.RecordCount>
				<cfset ReviewId = qryReview.ReviewId />
			</cfif>
		</cfif>
	</cfif>

	<cfreturn super.Get(ReviewId,arguments.needsClone,arguments.args) />
</cffunction>

</cfcomponent>
</code>
</p>
<p>No big surprise, there's almost nothing in there!  My ReviewService is inheriting GetList(), Update() and Delete() from the AbstractService, as it doesn't have to do anything special in those methods.  The only method that I need to override (in fact I'm extending it, not overriding it) is Get().</p>
<p>The issue with Get() is that I have two different algorithms for determining which Review I should return, depending on whether the current user is logged in as an administrator or not.  If the user <em>is</em> an administrator then I just return whichever review they requested, as an administrator is able to read and edit all reviews.  However, if the user <em>is not</em> an administrator then I must return only <em>their own</em> review.</p>
<p>Because Review is a child of Product, and User is a child of Review:
<code>
<package name="product">
	<object name="product" table="tblProduct" decorator="model.product">
		<id name="ProductId" type="numeric" />
		<property name="ProductName" type="string" column="ProductName" />
		...
		<onetomany name="Review" lazy="true">
 				<link to="product.review" column="ProductId"/>
			<collection type="array">
				<order property="LastUpdateTimestamp" order="desc" />
			</collection>
		</onetomany>
	</object>
	<object name="review" table="tblReview" decorator="model.review">
		<id name="ReviewId" type="numeric" />
		<property name="Rating" type="numeric" column="Rating" />
		<property name="LastUpdateTimestamp" type="date" column="LastUpdateTimestamp" />
		...
		<manytoone name="User">
			<link to="user.user" column="UserId"/>
		</manytoone>
	</object>
</package>
</code>
</p>
<p>I need to use TQL to join the objects together to find the Review that corresponds to the current user, and the ProductId (which is passed in via args).  That's what the bulk of the code above is doing.  Once I have the proper ReviewId, I then call super.Get() to actually return the Transfer Object.  This allows me to use all of the logic that is built in to the Get() method in the AbstractService, so I don't need to duplicate any of that in the ReviewService.</p>
<p>So that's a simple example of a Concrete Service Object that extends my Abstract Service Object.  I actually have one "special" Concrete Service Object, called ValueListService, which I use to manage all of my "code" or "lookup" objects.  This is used for objects like UserGroup, OrderStatus, ProductCategory, Colour, etc.  It too extends AbstractService, but is built itself in an abstract way so that I can use it to manage all of those "code" objects, without having to write a Concrete Service Object for each one.  I plan on discussing that in a future post.</p>
<p>In the next installment I'll start looking at the Abstract Gateway Object.</p>
