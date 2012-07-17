Strange ColdFusion Error Object

Today I came across a very strange ColdFusion error object.  We've all seen the standard CF Error object when doing a try/catch/dump.  It can be generated and viewed quite easily using a few lines of code such as this:
<code>
<cftry>
	<cfset myVar = UndefinedVar />
	<cfcatch type="any">
		<cfdump var="#cfcatch#" />
	</cfcatch>
</cftry>
</code>
</p>
<p>That yields the following dump:
<img src="/images/weird_error_1.png" />
</p>
<p>The exception being thrown is a coldfusion.runtime.UndefinedVariableException.  Notice the Type key in the above struct.  It's a string.  We've all seen dumps like that many times.  But, if I run this:
<code>
<cftry>
	<cfset str = StructNew() />
	<cfset ArrayAppend(str,"Test") />
	<cfcatch type="any">
		<cfdump var="#cfcatch#" />
	</cfcatch>
</cftry>
</code>
<more/>
<p>I get this object:
<img src="/images/weird_error_2.png" />
</p>
<p>In this case the exception being thrown is a coldfusion.runtime.NonArrayException.  Look at the Type key in the Error struct.  No wait, look at the type key.  Wait a minute, there's a Type key (upper case "T") <strong>and</strong> a type key (lower case "t").  And neither is a string.  They're both java classes.  See, I told you it was strange.  Strange enough to break the <a href="http://mxunit.org" target="_blank">MXUnit</a> Eclipse Plugin.  Until Marc Esher fixed it, that is.  Thanks Marc.</p>
<p>The <a href="http://livedocs.adobe.com/coldfusion/8/htmldocs/help.html?content=Tags_c_04.html" target="_blank">docs</a> don't specifically say that the Type key in a cfcatch struct will always be a string, so I guess this doesn't qualify as a bug, but I wonder how many other CF exceptions behave this way?</p>
