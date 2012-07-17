An Alternative Coldspring Lexicon for Fusebox

If you're using Coldspring with Fusebox (the XML version of Fusebox), you may find the Coldspring Lexicon for Fusebox handy.  It was written by <a href="http://www.qasimrasheed.com/">Qasim Rasheed</a>, and I've been using it for quite awhile.  I ran into some strange errors seemingly related to Coldspring with a site that recently went live, and I discussed the issue with <a href="http://www.briankotek.com/blog/">Brian Kotek</a>.  We determined that the likely culprit was a threading issue in Coldspring's getBean() method, which Brian identified and fixed immediately.</p>
<p>The only reason that the issue even affected the site is because with the XML version of Fusebox your controllers are not cfcs and therefore are not singletons cached in the application scope.  This means that you cannot cache Coldspring beans in your Controllers like you can in other frameworks, like Model-Glue.  That in turn means that you have to call Coldspring's getBean() method every time you want a bean from Coldspring.  This not only has performance implications, but also can lead to threading issues.</p>
<p>Brian and I discussed this issue, and he came up with an excellent idea, that was simple and easy to implement.  Why not add code to the lexicon that allows it to cache the Coldspring beans itself?  Then, wherever you need a bean from Coldspring the cache can be checked first, and if the bean is found it will return it from the cache rather than calling Coldspring's getBean().</p>
<p>So that's just what I did, I updated the get.cfm file in the Coldspring lexicon to include the following code:
<code>
// Create beancache struct if necessary
fb_.TempCode = '
<cfif NOT StructKeyExists(myFusebox.getApplication().getApplicationData(),"#fb_.beancache#")>
	<cflock name="#fb_.beancache#" type="exclusive" timeout="10">
		<cfif NOT StructKeyExists(myFusebox.getApplication().getApplicationData(),"#fb_.beancache#")>
			<cfset StructInsert(myFusebox.getApplication().getApplicationData(),"#fb_.beancache#",StructNew(),true) />
			<cfset myFusebox.getApplication().getApplicationData().#fb_.beancache#.Bean = StructNew() />	
			<cfset myFusebox.getApplication().getApplicationData().#fb_.beancache#.BeanDef = StructNew() />	
		</cfif>
	</cflock>
</cfif> ';
fb_appendSegment(fb_.TempCode);

// Setup variables depending on the type of call
if (structKeyExists(fb_.verbInfo.attributes,"bean")) {
          fb_.beantype = "Bean";
          fb_.beanmethod = "getBean";
          fb_.beanname = fb_.verbInfo.attributes.bean;
} else {
	if (structKeyExists(fb_.verbInfo.attributes,"beanDefinition")) {
          fb_.beantype = "BeanDef";
          fb_.beanmethod = "getBeanDefinition";
          fb_.beanname = fb_.verbInfo.attributes.beanDefinition;
	} else {
		// bean or beanDefinition is required
		fb_throw("fusebox.badGrammar.requiredAttributeMissing",
					"Required attribute is missing",
					"The attribute 'bean' or 'beanDefinition' is required, for a 'get' verb in fuseaction #fb_.verbInfo.circuit#.#fb_.verbInfo.fuseaction#.");
	}
}

// Check the cache for the bean or beandef and grab it if it isn't in the cache
fb_.TempCode = '
<cfif NOT StructKeyExists(myFusebox.getApplication().getApplicationData().#fb_.beancache#.#fb_.beantype#,"#fb_.beanname#")>
	<cfinvoke component="##myFusebox.getApplication().getApplicationData().#fb_.coldspringfactory###" method="#fb_.beanmethod#" returnVariable="#fb_.verbInfo.attributes.returnvariable#" beanName="#fb_.beanname#" />
	<cfset StructInsert(myFusebox.getApplication().getApplicationData().#fb_.beancache#.#fb_.beantype#,"#fb_.beanname#",#fb_.verbInfo.attributes.returnvariable#,true) />
<cfelse>
	<cfset #fb_.returnvariable#myFusebox.getApplication().getApplicationData().#fb_.beancache#.#fb_.beantype#.#fb_.beanname# />
</cfif> ';
fb_appendSegment(fb_.TempCode);
</code>
</p>
<p>Now, if you've never looked at code inside a Fusebox lexicon that may seem like gibberish to you, so let's walk through it.</p>
<p>The first thing to understand is what the purpose of the lexicon file is; it is designed to insert code into the file that is created when the Fusebox framework parses a fuseaction.  So really it just builds up blocks of code and then asks for them to be inserted into the parsed file.  That's what <em>fb_appendsegment()</em> does.  Also, there are some variables that exist only during the parsing process, and those are in the <em>fb_.verbInfo</em> struct.  Finally, the <em>fb_</em> struct is available as a temporary scope during the parsing process, so I use that to store some local variables that are required during the parse.  Now, on to the code:</p>
<p>First, I need to generate a block of code that will check to see whether the cache, which is a struct that is stored in the framework's application scope, exists.  If it doesn't then it must be created.  The cache struct in turn holds two structs, one for beans and one for bean definitions, so these must be created as well.  I've never had to ask for a bean definition, so I'm not sure what the use case is for that, but it exists in the current lexicon and I wanted to make this backward compatible.  I'm wrapping all of this in a double-lock so the cache won't disappear in the middle of a request.  I'm not sure how necessary that is.</p>
<p>Next I create some local variables that are required to support the fact that the lexicon can be used to return either a bean or a bean definition.</p>
<p>Finally, I'm generating a block of code that will check to see whether the current bean being requested already exists in the cache.  If it doesn't then I ask Coldspring for it, and add it to the cache.  If it does then I just return it from the cache.</p>
<p>And that's pretty much it.  Using this lexicon I now have a scenario that emulates caching the Coldspring beans in my controller, as I am able to do with other frameworks.</p>
<p>I discussed this new version of the lexicon with Qasim, the original author, and he raised a few valid points about why he wouldn't rush out to adopt this approach:
<ul>
	<li>It is placing more responsibility in the lexicon than one might wish.</li>
</ul></p>
