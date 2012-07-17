Managing Bi-directional Relationships in ColdFusion ORM - Struct-based Collections

In the <a href="?" target="_blank">last article</a> about Managing Bi-directional Relationships in ColdFusion ORM I discussed some issues around
bi-directional relationships and showed some code that I wrote that allows me to override my add() and remove() methods when working with
array-based collections. In this follow-up I'll do the same thing, but this time looking at struct-based collections. If you haven't read the
previous post I suggest you <a href="?" target="_blank">do it now</a>.</p>
<p>Once again we'll be looking at Countries and Languages, with the cfcs being identical to those we looked at last time, with the exception that
the collections are implemented as structures and not arrays. Let's take a look at the cfcs:
<code>component persistent="true" hint="This is Country.cfc"
{
	property name="CountryId" fieldtype="id" generator="native";
	property name="CountryCode" length="2" notnull="true";
	property name="CountryName" notnull="true";
	property name="Languages" fieldtype="many-to-many" cfc="Language"
		type="struct" structkeycolumn="LanguageName" structkeytype="string"
		singularname="Language" linktable="CountryLanguage";
}

component persistent="true" hint="This is Language.cfc"
{
	property name="LanguageId" fieldtype="id" generator="native";
	property name="LanguageName" notnull="true";
	property name="Countries" fieldtype="many-to-many" cfc="Country"
	type="struct" structkeycolumn="CountryCode" structkeytype="string"
	singularname="Country" linktable="CountryLanguage" inverse="true";
}</code></p>
<p><strong>Note:</strong> The above setup <strong>will not work</strong>. In my testing I found that it was impossible to get a many-to-many relationship
that is implemented as two structures to work properly. In my actual code I have one side as a structure and the other as an array. I am using the example
of both sides being structures simply because it's simpler to explain and requires me to show less code. If you do want to create a bi-directional
many-to-many and you want to use a structure you'll have to choose one side or the other to implement as a structure and make the other one an array.</p>
<p>Just like last time, in order to ensure that both sides of the relationship are set whenever one side is explicitly set 
I need to override <em>addLanguage()</em> and <em>removeLanguage()</em> in Country.cfc
and I need to override <em>addCountry()</em> and <em>removeCountry()</em> in Language.cfc. 
The code in each is virtually identical, as both sets of collections are
implemented as structures, so let's just look at Language.cfc:
<code>component persistent="true" hint="This is Language.cfc"
{
	property name="LanguageId" fieldtype="id" generator="native";
	property name="LanguageName" notnull="true";
	property name="Countries" fieldtype="many-to-many" cfc="Country"
	type="struct" structkeycolumn="CountryCode" structkeytype="string"
	singularname="Country" linktable="CountryLanguage" inverse="true";

	public void function addCountry(required string key, required Country Country)
		hint="set both sides of the bi-directional relationship" {
		// set this side
		variables.Countries[arguments.key] = arguments.Country;
		// set the other side
		if (not arguments.Country.hasLanguage(variables.LanguageName)) {
			arguments.Country.addLanguage(variables.LanguageName,this);
		}
	}

	public void function removeCountry(required string key) 
		hint="set both sides of the bi-directional relationship" {
		// set the other side
		var Country = (structKeyExists(variables.Countries,arguments.key) ? variables.Countries[arguments.key] : "");
		if (isObject(Country) and Country.hasLanguage(arguments.key)) {
			Country.removeLanguage(arguments.key);
		}
		// set this side
		structDelete(variables.Countries,arguments.key);
	}
}</code></p>
<p>As you can see, when working with a struct-based collection some of the code for overriding the methods is simpler, while some involves new complexities.
Let's start by looking at the <em>addCountry()</em> method. As discussed in the last post,  
because I'm overriding the implicit <em>addCountry()</em> method I have to implement it myself, which means that I have to add the Country object that 
was passed in to the current Language object. With a structure this is as simple as placing the object into the appropriate key. I don't even need to
check whether the object passed in is already in the structure. Setting the other side (adding the current Language object to the Country object 
that was passed in) is similar to what I did with the array-based collection, the only exceptions being that the signatures for the <em>hasLanguage()</em> 
and <em>addLanguage()</em> methods is different. <em>hasLanguage()</em> requires that the key to the struct be passed, and <em>addLanguage()</em> requires
both the key and the object itself. I know that the key is going to be the contents of the LanguageName property, so I pass that in via
<em>variables.LanguageName</em>, and, of course, the current object is available via <em>this</em>.</p>
<p>Next we'll look at the the <em>removeCountry()</em> method. In this case I have a new challenge. I know that I need to set the relationship on both sides,
and until now it was easy to set the relationship on the <em>other</em> side because I had a pointer to the other object; it was passed into the method.
With the <em>removeCountry()</em> method, however, only the key is passed in. That means I have to find a way of getting access to the object that 
represents the other side. No problem. 
All we have to do is use the key that was passed in to retrieve the Country object from the <em>variables.Countries</em> struct,
after which, if one is found and the current Language object isn't already assigned to it, we can call the <em>removeLanguage()</em> method on it.
Note that we do this first, we have to set the <em>other</em> side first, before using removing the Country from the current Language,
because if we did <em>that</em> first we'd no longer be able to get the Country object from the <em>variables.Countries</em> struct.
Finally we can simply remove the Country from the current object's Countries collection using <em>structDelete()</em>.</p>
<p>As was discussed in the last post, this all works pretty well, but we can run into errors when we're working with a brand new object.
If we create a new instance of Language.cfc, for example by we calling <em>entityNew("Language")</em>, the contents of the Countries
property will not be an empty structure, it will be null. Again, I'm going to address that issue
by defaulting the collection to an empty structure in the constructor. I'll add the following <em>init()</em> method to my cfc:
<code>public Language function init() {
	if (isNull(variables.Countries)) {
		variables.Countries = {};
	}
	return this;
}</code></p>
<p>I mentioned in the last post that an altogether different approach could be taken in which
one creates new methods (e.g., <em>assignCountry()</em> and <em>clearCountry()</em>) for managing the relationships. I'll cover that approach
in a future blog post as well.</p>
<p>As always, if you can think of ways of improving this code please leave your suggestions as comments.</p>
