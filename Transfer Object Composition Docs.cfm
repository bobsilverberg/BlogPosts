Managing Relationships and Compositions

* Short section on how PK->FK relationships become object compositions (I don't think it qualifies as short, but I think it could be useful)

This section will describe how to work with relationships and compositions in Transfer.  Relationships always map back to a foreign key in yor database, so let's start by looking at a sample database.

Sample Database
---------------

This database is used by the tBlog sample application, which can be downloaded here{link}.  It is comprised of 5 tables, each of which is required to support the blog application:

Table:		tbl_User
Purpose:	Each blog post is owned by a single user.  Those user records are stored in this table.
<table>
	<tr>
		<th>Column</th>
		<th>Datatype</th>
		<th>Purpose</th>
	</tr>
	<tr>
		<td>IDUser</td>
		<td>numeric</td>
		<td>Primary Key (auto-generated)</td>
	</tr>
	<tr>
		<td>User_Name</td>
		<td>string</td>
		<td>The name of the User</td>
	</tr>
	<tr>
		<td>User_Email</td>
		<td>string</td>
		<td>The email address of the User</td>
	</tr>
</table>

Table:		tbl_Post
Purpose:	The records for individual blog posts are stored in this table.
<table>
	<tr>
		<th>Column</th>
		<th>Datatype</th>
		<th>Purpose</th>
	</tr>
	<tr>
		<td>IDPost</td>
		<td>numeric</td>
		<td>Primary Key (auto-generated)</td>
	</tr>
	<tr>
		<td>lnkIDUser</td>
		<td>numeric</td>
		<td>Foreign Key back to tbl_User, links the Post with its corresponding User</td>
	</tr>
	<tr>
		<td>post_Title</td>
		<td>string</td>
		<td>The title of the Post</td>
	</tr>
	<tr>
		<td>post_Body</td>
		<td>string</td>
		<td>The contents of the Post</td>
	</tr>
	<tr>
		<td>post_DateTime</td>
		<td>datetime</td>
		<td>The date/time that the Post was added</td>
	</tr>
</table>

Table:		tbl_Comment
Purpose:	Each blog post can have multiple comments associated with it.  The records for those comments are stored in this table.
<table>
	<tr>
		<th>Column</th>
		<th>Datatype</th>
		<th>Purpose</th>
	</tr>
	<tr>
		<td>IDComment</td>
		<td>numeric</td>
		<td>Primary Key (auto-generated)</td>
	</tr>
	<tr>
		<td>lnkIDPost</td>
		<td>numeric</td>
		<td>Foreign Key back to tbl_Post, links the Comment with its corresponding Post</td>
	</tr>
	<tr>
		<td>comment_Name</td>
		<td>string</td>
		<td>The name associated with the Comment</td>
	</tr>
	<tr>
		<td>comment_Value</td>
		<td>string</td>
		<td>The text of the Comment</td>
	</tr>
	<tr>
		<td>comment_DateTime</td>
		<td>datetime</td>
		<td>The date/time that the Comment was recorded</td>
	</tr>
</table>

Table:		tbl_Category
Purpose:	Blog posts can be assigned to categories.  The records that describe each category are stored in this table.
<table>
	<tr>
		<th>Column</th>
		<th>Datatype</th>
		<th>Purpose</th>
	</tr>
	<tr>
		<td>IDCategory</td>
		<td>numeric</td>
		<td>Primary Key (auto-generated)</td>
	</tr>
	<tr>
		<td>category_Name</td>
		<td>string</td>
		<td>The name of the Category</td>
	</tr>
	<tr>
		<td>category_OrderIndex</td>
		<td>numeric</td>
		<td>Used for sorting Categories for output</td>
	</tr>
</table>

Table:		lnk_PostCategory
Purpose:	Each blog post can be assigned to multiple categories, and each category can have multiple blog posts assigned to it. The records that keep track of the link between a single blog post and a single category are stored in this table.
<table>
	<tr>
		<th>Column</th>
		<th>Datatype</th>
		<th>Purpose</th>
	</tr>
	<tr>
		<td>lnkIDPost</td>
		<td>numeric</td>
		<td>Foreign Key back to tbl_Post</td>
	</tr>
	<tr>
		<td>lnkIDCategory</td>
		<td>numeric</td>
		<td>Foreign Key back to tbl_Category</td>
	</tr>
</table>

Where Are the relationships?
----------------------------

As mentioned above, relationships in Transfer are always manifested in your database as foreign keys.  So, if we want to find the relationships in our database we look for foreign keys.  The sample database contains four foreign keys:

tbl_post.lnkIDUser implements a one-to-many relationship between Users and Posts.
tbl_comment.lnkIDPost implements a one-to-many relationship between Posts and Comments.
lnk_postcategory.lnkIDPost AND lnk_postcategory.lnkIDCategory implements a many-to-many relationship between Posts and Categories.

Note that when talking about foreign keys in a relational database we only use the term one-to-many.  In terms of your physical database Transfer's concepts of OneToMany and ManyToOne are identical.  You cannot differentiate between a OneToMany and a ManyToOne in your physical database - they are both implemented via a foreign key.

That means that when creating a Transfer relationship from a one-to-many, as a result of a foreign key in our database, we need to decide whether to model that to Transfer as a OneToMany or a ManyToOne.  Note that this decision must be made.  You cannot define both a OneToMany and a ManyToOne to Transfer for a single foreign key in your database. More on how to make this decision can be found below.

The many-to-many is more straighforward.  A many-to-many in your database, implemented via a linking table, becomes a ManyToMany in Transfer.  The one exception to this is if you are storing data in your linking table that is not just the two foreign keys.  If you are storing additional data in your linking table you cannot use Transfer's built-in ManyToMany support.  You must model that as two OneToMany relationships.  More on that later. A simple rule to follow is that if you have more than 2 columns in your linking table, not including a auto-generated primary key, you cannot use a ManyToMany relationship.

OneToMany or ManyToOne?
-----------------------

So, how does one decide whether to model a one-to-many in a database as a OneToMany or a ManyToOne?

First it is important to understand the difference between a OneToMany and ManyToOne in Transfer, quoting from another part of the wiki:

{Note: this info is taken from http://docs.transfer-orm.com/wiki/What_is_the_difference_between_ManyToOne_and_OneToMany.cfm which introduces some duplication into the wiki.  That's not great, but I don't think just a link would be a good idea either as I think it's more valuable to have all of this info in one place.}

OneToMany composition is useful when you wish for TransferObjects on both sides of the relationship to see each other, or for the Parent to have a collection of the child objects attached to it.

A ManyToOne collection is useful when, either for application design, or performance reasons, you only want an Objects to load one side of the relationship, and not generate a collection of Objects.

For example, we have a series of Comments on a Blog Post, we want the Post to have a collection of Comments on it, so we would use a OneToMany.

However, if we had a Product which could be included in hundreds of Orders, we would build our Order object with a ManyToOne to Product, so that an Order would have a Product attached, but the Product would have no need to be aware of its Orders.

In other words, you can think of OneToMany as OneWithMany, and ManyToOne as one of ManyWithOne. 

-----------------------------------------------

This next section addresses each of the relationship types, based on your outline:

-----------------------------------------------

* ManyToOne
** Definition of m2o
** DB Table example of a m2o
** Mapping example of the m2o
** Example of setting a m2o and saving the value.
** Example of using the get() method to retrieve a m2o composition

ManyToOne
---------

Database Tables
---------------

tbl_User
<table>
	<tr>
		<th>Column</th>
		<th>Datatype</th>
		<th>Purpose</th>
	</tr>
	<tr>
		<td>IDUser</td>
		<td>numeric</td>
		<td>Primary Key (auto-generated)</td>
	</tr>
	<tr>
		<td>User_Name</td>
		<td>string</td>
		<td>The name of the User</td>
	</tr>
	<tr>
		<td>User_Email</td>
		<td>string</td>
		<td>The email address of the User</td>
	</tr>
</table>

tbl_Post
<table>
	<tr>
		<th>Column</th>
		<th>Datatype</th>
		<th>Purpose</th>
	</tr>
	<tr>
		<td>IDPost</td>
		<td>numeric</td>
		<td>Primary Key (auto-generated)</td>
	</tr>
	<tr>
		<td>lnkIDUser</td>
		<td>numeric</td>
		<td>Foreign Key back to tbl_User, links the Post with its corresponding User</td>
	</tr>
	<tr>
		<td>post_Title</td>
		<td>string</td>
		<td>The title of the Post</td>
	</tr>
	<tr>
		<td>post_Body</td>
		<td>string</td>
		<td>The contents of the Post</td>
	</tr>
	<tr>
		<td>post_DateTime</td>
		<td>datetime</td>
		<td>The date/time that the Post was added</td>
	</tr>
</table>

Transfer.xml Configuration
--------------------------

<package name="user">
	<object name="User" table="tbl_User">
		<id name="IDUser" type="numeric"/>
		<property name="Name" type="string" column="user_Name"/>
		<property name="Email" type="string" column="user_Email"/>
	</object>
</package>
<package name="post">
	<object name="Post" table="tbl_Post">
		<id name="IDPost" type="numeric"/>
		<property name="Title" type="string" column="post_Title"/>
		<property name="Body" type="string" column="post_Body"/>
		<property name="DateTime" type="date" column="post_DateTime"/>
		<manytoone name="User">
			<link to="user.User" column="lnkIDUser"/>
		</manytoone>
	</object>
</package>

Note that we place the ManyToOne declaration in the object whose table contains the foreign key.  We tell transfer the name of the column that represents the foreign key, and the name of the object whose table contains the corresponding primary key.

Sample Code
-----------

Setting a ManyToOne
<cfscript>
	post = Transfer.new("post.Post");
	post.setTitle("My Title");
	post.setBody("The body of my post");
	post.setDateTime(Now());
	user = Transfer.get("user.User",1);
	post.setUser(user);
	Transfer.save(post);	
</cfscript>

In order to set the User for a Post, we must first get the Transfer Object that corresponds to the User, and then pass that into the setUser() method of the Post object.


Getting a ManyToOne
<cfscript>
	post = Transfer.get("post.Post",1);
	if (post.hasUser()) {
		user = post.getUser();
	}
</cfscript>

In order to retrieve the User from a Post, we simply call the getUser() method, which returns a User Transfer Object to us.  Note that if it is possible that the User may not be set for the Post (e.g., if the lnkIDUser allows NULLs), it is wise to check for the existence of a User first by calling hasUser().


* OneToMany
** Definition of o2m
** DB Table example of a o2m
** Mapping example of the o2m
** Example of setting a o2m and saving the value.
** Example of using the getParent(), get(), getArray() methods to
retrieve a o2m compositions

OneToMany
---------

Database Tables
---------------

tbl_Post
<table>
	<tr>
		<th>Column</th>
		<th>Datatype</th>
		<th>Purpose</th>
	</tr>
	<tr>
		<td>IDPost</td>
		<td>numeric</td>
		<td>Primary Key (auto-generated)</td>
	</tr>
	<tr>
		<td>lnkIDUser</td>
		<td>numeric</td>
		<td>Foreign Key back to tbl_User, links the Post with its corresponding User</td>
	</tr>
	<tr>
		<td>post_Title</td>
		<td>string</td>
		<td>The title of the Post</td>
	</tr>
	<tr>
		<td>post_Body</td>
		<td>string</td>
		<td>The contents of the Post</td>
	</tr>
	<tr>
		<td>post_DateTime</td>
		<td>datetime</td>
		<td>The date/time that the Post was added</td>
	</tr>
</table>

tbl_Comment
<table>
	<tr>
		<th>Column</th>
		<th>Datatype</th>
		<th>Purpose</th>
	</tr>
	<tr>
		<td>IDComment</td>
		<td>numeric</td>
		<td>Primary Key (auto-generated)</td>
	</tr>
	<tr>
		<td>lnkIDPost</td>
		<td>numeric</td>
		<td>Foreign Key back to tbl_Post, links the Comment with its corresponding Post</td>
	</tr>
	<tr>
		<td>comment_Name</td>
		<td>string</td>
		<td>The name associated with the Comment</td>
	</tr>
	<tr>
		<td>comment_Value</td>
		<td>string</td>
		<td>The text of the Comment</td>
	</tr>
	<tr>
		<td>comment_DateTime</td>
		<td>datetime</td>
		<td>The date/time that the Comment was recorded</td>
	</tr>
</table>

Transfer.xml Configuration
--------------------------

<package name="post">
	<object name="Post" table="tbl_Post">
		<id name="IDPost" type="numeric"/>
		<property name="Title" type="string" column="post_Title"/>
		<property name="Body" type="string" column="post_Body"/>
		<property name="DateTime" type="date" column="post_DateTime"/>
		<onetomany name="Comment">
			<link to="post.Comment" column="lnkIDPost"/>
			<collection type="array">
				<order property="DateTime" order="asc"/>
			</collection>
		</onetomany>
	</object>
	<object name="Comment" table="tbl_Comment">
		<id name="IDComment" type="numeric"/>
		<property name="Name" type="string" column="comment_Name"/>
		<property name="Value" type="string" column="comment_Value"/>
		<property name="DateTime" type="date" column="comment_DateTime"/>
	</object>
</package>

Note that we place the OneToMany declaration in the object whose table *does not contain* the foreign key. We refer to that object as the Parent. We tell transfer to link back to the object whose table contains the foreign key. We refer to that object as the Child.  We must specify the name of the column in the Child table that represents the foreign key.

Because a OneToMany creates a collection, we need to tell Transfer whether that collection should be an array or a structure.  If it is to be an array, we can optionally specify a sort sequence for the items in that array.  This sort sequence must point to a property in the Child object.

We can also ask Transfer for create the collection as a structure, for example:

<onetomany name="Comment">
	<link to="post.Comment" column="lnkIDPost"/>
	<collection type="struct">
		<key property="DateTime"/>
	</collection>
</onetomany>

In this case we're asking for a struct, the keys of which are the values of the DateTime property in each of the Child objects.  Note that these values must be unique for a given Parent.
 
Sample Code
-----------

Setting a OneToMany
<cfscript>
	comment = Transfer.new("post.Comment");
	comment.setName("Bob Silverberg");
	comment.setValue("The content of my comment");
	comment.setDateTime(Now());
	post = Transfer.get("post.Post",1);
	comment.setParentPost(post);
	Transfer.save(comment);
</cfscript>

In order to set the Post for a Comment (which is the same as adding a Comment to a Post), we must first get the Transfer Object that corresponds to the Post, and then pass that into the setParentPost() method of the Comment object.


Removing a OneToMany
<cfscript>
	comment = Transfer.get("post.Comment",1);
	comment.removeParentPost();
	Transfer.save(comment);
</cfscript>

That will set the value of the foreign key in tbl_Comment to NULL, and will remove the Comment object from the collection stored in the Post object.


Getting a Parent
<cfscript>
	comment = Transfer.get("post.Comment",1);
	if (comment.hasParentPost()) {
		post = comment.getParentPost();
	}
</cfscript>

In order to retrieve the Post for a Comment, we simply call the getParentPost() method, which returns a Post Transfer Object to us.  Note that if it is possible that the Post may not be set for the Comment (e.g., if the lnkIDPost allows NULLs), it is wise to check for the existence of a Post first by calling hasParentPost().  In our example application this would be unneccesary, as it doesn't make sense to have a Comment that doesn't belong to a Post.


Getting a Collection
<cfscript>
	post = Transfer.get("post.Post",1);
	comments = post.getCommentArray();
</cfscript>

That will return an array that contains one Comment Transfer Object for each Comment that exists for the given Post.


Getting a Child
<cfscript>
	post = Transfer.get("post.Post",1);
	comment = post.getComment(1);
</cfscript>

That will return a Comment Transfer Object that is the first Child found in the Post's collection of Comments.  Note that this will throw an error if the child requested does not exist in the collection.


* ManyToMany
** Definition of m2m
** DB Table example of a m2m
** Mapping example of the m2m
** Example of setting a m2m and saving the value.
** Example of using the get(), getArray() methods to retrieve a m2m compositions

ManyToMany
---------

Database Tables
---------------

tbl_Post
<table>
	<tr>
		<th>Column</th>
		<th>Datatype</th>
		<th>Purpose</th>
	</tr>
	<tr>
		<td>IDPost</td>
		<td>numeric</td>
		<td>Primary Key (auto-generated)</td>
	</tr>
	<tr>
		<td>lnkIDUser</td>
		<td>numeric</td>
		<td>Foreign Key back to tbl_User, links the Post with its corresponding User</td>
	</tr>
	<tr>
		<td>post_Title</td>
		<td>string</td>
		<td>The title of the Post</td>
	</tr>
	<tr>
		<td>post_Body</td>
		<td>string</td>
		<td>The contents of the Post</td>
	</tr>
	<tr>
		<td>post_DateTime</td>
		<td>datetime</td>
		<td>The date/time that the Post was added</td>
	</tr>
</table>

tbl_Category
<table>
	<tr>
		<th>Column</th>
		<th>Datatype</th>
		<th>Purpose</th>
	</tr>
	<tr>
		<td>IDCategory</td>
		<td>numeric</td>
		<td>Primary Key (auto-generated)</td>
	</tr>
	<tr>
		<td>category_Name</td>
		<td>string</td>
		<td>The name of the Category</td>
	</tr>
	<tr>
		<td>category_OrderIndex</td>
		<td>numeric</td>
		<td>Used for sorting Categories for output</td>
	</tr>
</table>

lnk_PostCategory
<table>
	<tr>
		<th>Column</th>
		<th>Datatype</th>
		<th>Purpose</th>
	</tr>
	<tr>
		<td>lnkIDPost</td>
		<td>numeric</td>
		<td>Foreign Key back to tbl_Post</td>
	</tr>
	<tr>
		<td>lnkIDCategory</td>
		<td>numeric</td>
		<td>Foreign Key back to tbl_Category</td>
	</tr>
</table>

Transfer.xml Configuration
--------------------------

<package name="post">
	<object name="Post" table="tbl_Post">
		<id name="IDPost" type="numeric"/>
		<property name="Title" type="string" column="post_Title"/>
		<property name="Body" type="string" column="post_Body"/>
		<property name="DateTime" type="date" column="post_DateTime"/>
		<manytomany name="Category" table="lnk_PostCategory">
			<link to="post.Post" column="lnkIDPost"/>
			<link to="system.Category" column="lnkIDCategory"/>
			<collection type="array">
				<order property="OrderIndex" order="asc"/>
			</collection>
		</manytomany>
	</object>
</package>
<package name="system">
	<object name="Category" table="tbl_Category">
		<id name="IDCategory" type="numeric"/>
		<property name="Name" type="string" column="category_Name"/>
		<property name="OrderIndex" type="numeric" column="category_OrderIndex"/>
	</object>
</package>

Note that we place the ManyToMany declaration in the object from which we wish to navigate.  Because ManyToMany is not bi-directional, we must choose one object which will be the starting point for manipulating the relationship.  We will refer to that object as the Parent.  We will refer to the object that represents the other side of the ManyToMany relationship as the Child.  We tell transfer the name of the table in our database that is used to record the links between the two objects.  We also need to tell transfer the names of the foreign key columns in that table, as well as which object each foreign key points to.  Note that we must record the link to the Parent object first in the configuration file.

Because a ManyToMany creates a collection, we need to tell Transfer whether that collection should be an array or a structure.  If it is to be an array, we can optionally specify a sort sequence for the items in that array.  This sort sequence must point to a property in the Child object.

We can also ask Transfer for create the collection as a structure, for example:

<manytomany name="Category" table="lnk_PostCategory">
	<link to="post.Post" column="lnkIDPost"/>
	<link to="system.Category" column="lnkIDCategory"/>
	<collection type="struct">
		<key property="OrderIndex" order="asc"/>
	</collection>
</manytomany>

In this case we're asking for a struct, the keys of which are the values of the OrderIndex property in each of the Child objects.  Note that these values must be unique for a given Parent.
 
Sample Code
-----------

Setting a ManyToMany
<cfscript>
	post = Transfer.new("post.Post");
	post.setTitle("My Title");
	post.setBody("The body of my post");
	post.setDateTime(Now());
	category = Transfer.get("system.Category",1);
	post.addCategory(category);
	Transfer.save(post);	
</cfscript>

In order to add a Category to a Post, we must first get the Transfer Object that corresponds to the Category, and then pass that into the addCategory() method of the Post object.


Removing a ManyToMany
<cfscript>
	post = Transfer.get("post.Post",1);
	category = Transfer.get("system.Category",1);
	post.removeCategory(category);
	Transfer.save(post);
</cfscript>

In order to remove a Category from a Post, we must first get the Transfer Object that corresponds to the Category, and then pass that into the removeCategory() method of the Post object.


Clearing all ManyToManys
<cfscript>
	post = Transfer.get("post.Post",1);
	post.clearCategory();
	Transfer.save(post);
</cfscript>

That will remove all Categories from the Post.


Getting a Collection
<cfscript>
	post = Transfer.get("post.Post",1);
	categories = post.getCategoryArray();
</cfscript>

That will return an array that contains one Category Transfer Object for each Category that exists for the given Post.

Getting a Child
<cfscript>
	post = Transfer.get("post.Post",1);
	category = post.getCategory(1);
</cfscript>

That will return a Category Transfer Object that is the first Child found in the Post's collection of Category.  Note that this will throw an error if the child requested does not exist in the collection.
