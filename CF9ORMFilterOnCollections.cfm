Filtering Collections in ColdFusion ORM

A <a href="http://groups.google.com/group/cf-orm-dev/browse_thread/thread/bbfaa2ebaf650a99?hl=en" target="_blank">question was asked</a> 
on the <a href="http://groups.google.com/group/cf-orm-dev/" target="_blank">cf-orm-dev Google Group</a> about returning just a subset of objects that make up a collection. 
Specifically, the developer had a Page object and a Content object with a many-to-many relationship. A simplified version of the objects is:</p>
<p>Page.cfc:
<code>component persistent="true" {
	property name="pageId" fieldtype="id" generator="native";
	property name="title";
	property name="contents" fieldtype="many-to-many" cfc="content"
		singularname="content" linktable="page_content";
}</code></p>
<p>Content.cfc:
<code>component persistent="true" {
	property name="contentId" fieldtype="id" generator="native";
	property name="column" ormtype="integer";
	property name="pages" fieldtype="many-to-many" cfc="page"
		singularname="page" linktable="page_content" inverse="true";
}</code></p>
<p>Each Page can have multiple pieces of Content, and each Content block appears in a particular column on that page. Each Page can have multiple Content objects in any given column.
The developer was wondering if he could do something like:
<code>Page = entityLoadByPK("Page",1);
column1Contents = Page.getContents({column=1});
</code></p>
<p>Which would return all of the Content objects assigned to that Page, but only those that are in column 1 (which is a property of the Content object).<more/>
At first glance this doesn't seem possible. Certainly that syntax is not available (passing criteria into a getter on a collection). 
There are other ways to get that data, however, including:
<ul>
	<li>
		 Use an HQL query with criteria that returns a set of Content objects for a given Page and column. The downside to that is that if you had 3 columns Hibernate would end up issuing 3 SQL queries.
	</li>
	<li>
		 Create a custom method which would loop through all of the Content objects for the Page, and only return those that match a particular column, 
		 the value of which could be passed into the method via an argument.
	</li>
</ul></p>
<p>I had a feeling that there yet another way to do this, using the features of Hibernate, and upon further reflection I realized that this would be a perfect candidate for a <a href="http://docs.jboss.org/hibernate/stable/core/reference/en/html/filters.html" target="_blank">Hibernate filter</a>.
Hibernate filters are very cool, and allow you to do a bunch of neat things, but for the purposes of this post we're just going to look at using them to filter collections.
Basically, a filter allows you to create a subset of data by specifying criteria. In this case we want to create a subset of all of the Content objects that belong to a Page by specifying
a value for the column property of the Content objects. The only slightly tricky part about working with Hibernate filters is that they are not directly accessible via 
built-in ColdFusion functions; we need to work directly with Hibernate to create them and work with them. There are two ways to create a Hibernate filter:
<ul>
	<li>Define it in an hbmxml file, which requires that you write, or generate, an hbmxml file for your component, and then edit that hbmxml file.  As this is a bit more complicated
		I won't be covering that in this blog post, but I will in a follow-up post.</li>
	<li>Use the <em>createFilter()</em> method that is available in the Hibernate Session object. This is what we'll look at next.</li>
</ul>
</p>
<p>There is more explanation than code required, so I'm going to start with the code and then walk through it. 
Here's a simple example of creating a filter that gives us a subset of Content objects for a given Page:
<code>Page = entityLoadByPK("Page",1);
column1Contents = ormGetSession().createFilter(Page.getContents(),"where column = 1").list();
</code></p>
<p>Because the createFilter() method exists in the Hibernate Session object, the first thing we have to do is get access to the current Hibernate Session.  
As you can see that's as simple as calling <em>ormGetSession()</em>. We can then call createFilter() to create the filter. 
It accepts two arguments, the first is the collection, which in this case is <em>Page.getContents()</em> and the second is an HQL query string.
The HQL query string has an implicit FROM clause, so we can leave that out. What we want to do in this situation is to only retrieve those Content objects with a column value of 1,
so we just specify that in the HQL WHERE clause. Finally, we call the <em>list()</em> method on the filter object, which returns the result to us.</p>
<p>Now that's pretty simple, but it's not very flexible: it only gives us all of the Content objects for column 1. What if we want column 2, column 3, etc.?
Let's tackle that issue, but first let's put this code where it really belongs, in the Page object itself. Let's add a method called <em>getColumnContents()</em> to our Page object.
Here's the new Page.cfc:
<code>component persistent="true" {
	property name="pageId" fieldtype="id" generator="native";
	property name="title";
	property name="contents" fieldtype="many-to-many" cfc="content"
		singularname="content" linktable="page_content";
		
	function getColumnContents(column) {
		return ormGetSession().createFilter(Page.getContents(),"where column = #arguments.column#").list();
	}
}</code></p>
<p>That was easy. Now we can ask our Page object for all of the Content objects in any given column by calling the getColumnContents() method. 
The only problem with that code is that it potentially opens us up to SQL injection attacks, as described by <a href="http://www.12robots.com/" target="_blank">Jason Dean</a> in <a href="http://www.12robots.com/index.cfm/2009/11/19/ORM-Hibernate-Injection--Security-Series-14" target="_blank">this informative blog post</a>.
Luckily there's an easy way to solve that problem; our filter provides us with methods of specifying parameters to be used by the HQL query. 
Here's what a new, safer version of this method would look like:
<code>function getColumnContents(column) {
	return ormGetSession().createFilter(Page.getContents(),"where column = :column").setInteger("column",arguments.column)list();
}</code></p>
<p>First we replace our inline variable with a named parameter, <em>:column</em>. Next, because our column property contains integer values, we use the setInteger() method to set
a value for that parameter, thusly protecting ourselves from evil doers. And with that we have a method in our Page object that can be used to return all of the Content
objects that belong in a certain column.
The code to use it would look something like this:
<code>Page = entityLoadByPK("Page",1);
column1Contents = Page.getColumnContents(1);
</code></p>
<p>Unfortunately, after I wrote this post I did some testing and it looks like Hibernate is going to execute a new SQL query each time that method is called, 
even if the entire collection of Content objects has already been loaded. I was disappointed to see this, and I'm going to experiment with the other way of creating filters (in the hbmxml file) to see
if they will make use of data that is already cached in the object. This means that this approach is really no better than simply writing an HQL query in your object that will
return all of the Content objects for a given column, which is something I hoped to avoid because it could result in numerous queries. 
I think I still prefer the design and syntax of using this filter method over writing out an entire HQL query, but there doesn't appear to be any performance advantages.</p>
