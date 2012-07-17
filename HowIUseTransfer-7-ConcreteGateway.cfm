How I Use Transfer - Part VII - A Concrete Gateway Object

In the <a href="http://www.silverwareconsulting.com/index.cfm/2008/7/14/How-I-Use-Transfer--Part-VI--My-Abstract-Gateway-Object">previous post</a>, I described my Abstract Gateway Object.  As I did with the Service Objects, I'm going to take a moment to describe a Concrete Gateway Object as an illustration of how I use the Abstract Gateway.  I'll start with a recap of the differences between the Abstract Gateway and Concrete Gateways, followed by a look at the code of a specific Concrete Gateway.</p>
<ul><strong>The Abstract Gateway Object</strong>
	<li>Is never instantiated as an object.</li>
	<li>Cannot be used as is.</li>
	<li>Is only ever used as a base object for Concrete Gateway Objects.</li>
	<li>There is only one Abstract Gateway Object, called AbstractGateway.cfc.</li>
	<li>Does not have any Transfer classes associated with it.</li>
</ul>
<ul><strong>Concrete Gateway Objects</strong>
	<li>Are instantiated as objects.</li>
	<li>Methods on them are called by Service Objects.</li>
	<li>All extend AbstractGateway.cfc.</li>
	<li>There are many Concrete Gateway Objects, e.g., UserGateway.cfc, ProductGateway.cfc, ReviewGateway.cfc, etc.</li>
	<li>Have one "main" Transfer class associated with them, but can interact with others via code specific to the Concrete Gateway.</li>
</ul>
<p>One thing to note here is that my Gateway Objects are all injected into Service Objects via Coldspring, and are only called by Service Objects.  So the Service acts as an API to the entire model.  If a Business Object needs to call a method on a gateway, it calls it via a Service Object that is injected into the Business Object.
<more/>
Let's take a look at an example of a Concrete Gateway Object, ProductGateway.cfc.  To start, here's the Bean definition of this gateway from my Coldspring config file:
<code>
<bean id="ProductGateway" class="model.Gateway.ProductGateway">
	<property name="TransferClassName"><value>product.product</value></property>
	<property name="DescColumn"><value>ProductCode</value></property>
</bean>
</code>
</p>
<p>In here I indicate that the main Transfer class with which this service interacts is
<em>product.product</em>.  That means that calls to GetList(), GetActiveList() and ReInitActiveList() will be directed at the table defined to Transfer as product.product.  I can write additional methods in my gateway that will interact with other Transfer classes, but the default methods, inherited from the AbstractGateway, will be directed at product.product.</p>
<p>I also indicate that the property that represents the description of the main class is <em>ProductCode</em>.  That is used as a default sort sequence for the default methods.</p> 
<p>And here's what's inside ProductGateway.cfc:
<code>
<cffunction name="GetList" access="public" output="false" returntype="any" hint="Interface to the getByAttributesQuery method">
	<cfargument name="Level1CategoryId" type="any" required="false" />
	<cfargument name="Level2CategoryId" type="any" required="false" />
	<cfargument name="Level3CategoryId" type="any" required="false" />
	<cfargument name="ProductName" type="any" required="false" />
	<cfargument name="SKU" type="any" required="false" />
	<cfargument name="ProductCode" type="any" required="false" />
	
	<cfset var TQL = "" />
	<cfset var TQuery = "" />	
	<cfsavecontent variable="TQL">
	<cfoutput>
		SELECT	Product.ProductId, Product.ProductCode, Product.SKU, Product.ActiveFlag,
				Product.ProductName, Product.Level1CategoryName, Product.Level2CategoryName, 
				Product.Level3CategoryName
		FROM	product.catalog_admin AS Product
		WHERE	Product.ProductId IS NOT NULL
	<cfif structKeyExists(arguments,"Level1CategoryId") and Val(arguments.Level1CategoryId)>
		AND		Product.Level1CategoryId = :Level1CategoryId
	</cfif>
	<cfif structKeyExists(arguments,"Level2CategoryId") and Val(arguments.Level2CategoryId)>
		AND		Product.Level2CategoryId = :Level2CategoryId
	</cfif>
	<cfif structKeyExists(arguments,"Level3CategoryId") and Val(arguments.Level3CategoryId)>
		AND		Product.Level3CategoryId = :Level3CategoryId
	</cfif>
	<cfif structKeyExists(arguments,"ProductName") and Len(arguments.ProductName)>
		AND		Product.ProductName like :ProductName
	</cfif>
	<cfif structKeyExists(arguments,"SKU") and Len(arguments.SKU)>
		AND		Product.SKU like :SKU
	</cfif>
	<cfif structKeyExists(arguments,"ProductCode") and Len(arguments.ProductCode)>
		AND		Product.ProductCode like :ProductCode
	</cfif>
		ORDER BY Product.ActiveFlag DESC, Product.ProductName
	</cfoutput>
	</cfsavecontent>
	<cfset TQuery = getTransfer().createQuery(TQL) />
	<cfif structKeyExists(arguments,"Level1CategoryId") and Val(arguments.Level1CategoryId)>
		<cfset TQuery.setParam("Level1CategoryId",arguments.Level1CategoryId) />
	</cfif>
	<cfif structKeyExists(arguments,"Level2CategoryId") and Val(arguments.Level2CategoryId)>
		<cfset TQuery.setParam("Level2CategoryId",arguments.Level2CategoryId) />
	</cfif>
	<cfif structKeyExists(arguments,"Level3CategoryId") and Val(arguments.Level3CategoryId)>
		<cfset TQuery.setParam("Level3CategoryId",arguments.Level3CategoryId) />
	</cfif>
	<cfif structKeyExists(arguments,"ProductName") and Len(arguments.ProductName)>
		<cfset TQuery.setParam("ProductName","%" & arguments.ProductName & "%") />
	</cfif>
	<cfif structKeyExists(arguments,"SKU") and Len(arguments.SKU)>
		<cfset TQuery.setParam("SKU","%" & arguments.SKU & "%") />
	</cfif>
	<cfif structKeyExists(arguments,"ProductCode") and Len(arguments.ProductCode)>
		<cfset TQuery.setParam("ProductCode","%" & arguments.ProductCode & "%") />
	</cfif>
	
	<cfset TQuery.setDistinctMode(true) />
	<cfreturn getTransfer().listByQuery(TQuery) />

</cffunction>
</code>
</p>
<p>Here I'm overriding the default GetList() method to allow for criteria to be passed in by a user.  This function is based on one automatically generated for me by <a href="http://www.remotesynthesis.com/">Brian Rinaldi's</a> most excellent <a href="http://code.google.com/p/cfcgenerator/">Illudium PU-36 Code Generator</a>.  One thing to note in here is the Transfer Class that this TQL is referring to.  It's called product.catalog_admin, and is actually pointing at a view in my database.  The product information in this application is spread across many tables, and rather than having to write a complicated TQL statement with multiple inner and outer joins, I just write my TQL against a view that already joins everything together.</p>
<p>Let's look at another method on the Concrete Gateway:
<code>
<cffunction name="getApprovedReviews" access="public" output="false" returntype="any" hint="Returns a query of Approved Reviews for a given Product">
	<cfargument name="ProductId" type="any" required="true" />
	<cfset var TQuery = 0 />
	<cfset var TQL = "" />
	<cfsavecontent variable="TQL">
		<cfoutput>
			SELECT	Review.ReviewId, TUser.Nickname, Review.Rating, Review.Comments, Review.LastUpdateTimestamp
			FROM	product.product AS Product
			JOIN	product.review AS Review
			JOIN	product.reviewstatus AS ReviewStatus
			JOIN	user.user AS TUser
			WHERE	Product.ProductId = :ProductId
			AND		ReviewStatus.ReviewStatusDesc = :ReviewStatus
			ORDER BY Review.LastUpdateTimestamp
		</cfoutput>
	</cfsavecontent>
	<cfset TQuery = getTransfer().createQuery(TQL) />
	<cfset TQuery.setParam("ProductId",Val(arguments.ProductId)) />
	<cfset TQuery.setParam("ReviewStatus","Approved") />
	<cfreturn getTransfer().listByQuery(TQuery) />
</cffunction>
</code>
</p>
<p>This is basically just another query that I need within the application.  My Concrete Gateways are quite simple in that they only include methods that return query objects.</p>
<p>As I alluded to in a <a href="http://www.silverwareconsulting.com/index.cfm/2008/7/8/How-I-Use-Transfer--Part-V--A-Concrete-Service-Object">previous post</a>, I have one "special" Concrete Gateway Object, called ValueListGateway, which I use to interact with all of my "code" or "lookup" objects.  It is used for objects like UserGroup, OrderStatus, ProductCategory, Colour, etc.  It too extends AbstractGateway, but is built itself in an abstract way so that I can use it to interact with all of those "code" objects, without having to write a Concrete Gateway Object for each one.  I plan on discussing that in a future post.</p>
<p>In the next installment I'm going to start looking at my AbstractTransferDecorator, which can be thought of as an Abstract Business Object.</p>
