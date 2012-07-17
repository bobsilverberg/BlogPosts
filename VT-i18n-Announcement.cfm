ValidateThis! 0.75 - Now Supports Internationalization (i18n)

A developer named Mischa Sameli asked a question about supporting internationalization (i18n) in ValidateThis!, my validation framework for ColdFusion objects, on the <a href="http://groups.google.com/group/validatethis" target="_blank">ValidateThis Google Group</a> a couple of weeks ago. His questions got me thinking about how I might do that, and those thoughts turned into design ideas, which turned into code. So I'm happy to announce that the latest version of VT, just released to <a href="http://validatethis.riaforge.org/" target="_blank">RIAForge</a>, has full support for i18n.</p>
<p>What does that mean? Well, in a nutshell, it means that all validation failure messages, both on the client side and on the server side, can now appear in multiple languages within a single application. A developer still only has to specify the metadata for each validation rule once (which is the primary objective of the framework), with the translations being provided via resource bundles. That's the simplified answer, read on for more details on how I implemented i18n support, and how to make use of it.
<more/>
<h3>The Translator Object</h3>
<p>I knew that I wanted to introduce i18n support based on resouce bundles, which is a standard in java and, I believe, in web applications in general. However, I also recognized that not everyone might choose to use resource bundles to store their translation metadata, so I didn't want to lock the framework into that single implementation. So I created a Translator object, which is used to perform all translations, and which can be easily overridden by a developer.</p>
<p>I actually created two Translator objects. The BaseTranslator actually does nothing. It accepts a term for translation and returns the identical term. That translator will be used by the framework when i18n is not required. The second Translator object, which extends the BaseTranslator is called the RBTranslator. It uses resource bundles to provide translations for terms. Because it is simple to override either of these Translator objects with your own object, if you want to provide translations in another format (e.g., from a database table), all you have to do it write a new Translator and tell the framework to use your Translator instead.</p>
<h3>What Gets Translated?</h3>
<p>Probably the biggest challenge I'm going to assume that anyone who is going to use the RBTranslator knows what resource bundles are and how to create them.</p>

I designed ValidateThis!, my validation framework for ColdFusion objects, to be framework agnostic, meaning that it could be used to provide validation services to Business Objects regardless of what other frameworks a developer chooses to use.  That was my goal, and that was how it was implemented.  But, up until about a week ago, I had never actually used it with anything other than Transfer.</p>
<p>As a result of some discussions I had with <a href="http://www.nodans.com/" target="_blank">Dan Wilson</a>, I determined that I needed to make sure that VT could actually work as easily with <a href="http://trac.reactorframework.org/" target="_blank">Reactor</a> as it does with <a href="http://www.transfer-orm.com/" target="_blank">Transfer</a>. Using the new <em>super-simple</em> integration technique that I mentioned in <a href="http://www.silverwareconsulting.com/index.cfm/2009/4/8/Stop-the-Presses--ValidateThis-Now-Easier-to-Use-Than-a-Mac" target="_blank">an earlier post</a>, I was able to get VT working with Reactor in exactly the same manner as Transfer, in a matter of minutes.</p>
<p>So I'm now satisfied that VT truly is framework agnostic, which is pretty cool, as I imagine it might come in handy working with the new ORM features being touted for CF9.</p>

