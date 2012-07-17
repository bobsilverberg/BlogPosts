Dumping CFQUERY

I just learned something new about CFQUERY, so I thought I'd share it.  Now don't get excited.  This is something that I'm guessing many of you already know, but I think it's cool nonetheless.</p>
<p>If you do a CFDUMP of a query, only in CF8 I believe, you don't just see the contents of the query, you can also see some interesting facts about the query as well.  So, if I run the following code:
<code>
	<cfquery name="qryResult" datasource="myDSN">
		SELECT	DISTINCT ProductId, ProductCode, ActiveFlag
		FROM	tblProduct
		WHERE	ProductId IS NOT NULL
		AND		Level1CategoryId = 
			<cfqueryparam cfsqltype="cf_sql_integer" value="1" /> 
		AND		Level2CategoryId = 
			<cfqueryparam cfsqltype="cf_sql_integer" value="15" /> 
		AND		Level3CategoryId = 
			<cfqueryparam cfsqltype="cf_sql_integer" value="17" />
		ORDER BY ActiveFlag DESC, ProductId
	</cfquery>
	<cfdump var="#qryResult#">
</code>
</p>
<p>I see:
<img src="images/dump_cfquery1.gif" width="531" height="501" alt="cfdump sample 1" class="float-left" />
</p>
<p>So evidently the query object is made up of a number of other objects, one of which is the actual query ResultSet.  What I found interesting about this is that you cannot actually use any of that information.  If you try to refer to qryResult.ResultSet or qryResult.SQL ColdFusion throws an error.  So really, you can only see that information via CFDUMP.  And, if you want to use the ResultSet, as we all know, you just refer to the query itself.  I guess that internally ColdFusion knows that when a template asks for qryResult, it's really asking for the ResultSet that's stored in qryResult.</p>
<p>My investigation into this also revealed to me that ColdFusion MX 7 added the result attribute to the CFQUERY tag, which does allow you to gain access to all of this information (except ResultSet, of course).  For example, if I run this code:
<code>
	<cfquery name="qryResult" datasource="myDSN" result="strResult">
		SELECT	DISTINCT ProductId, ProductCode, ActiveFlag
		FROM	tblProduct
		WHERE	ProductId IS NOT NULL
		AND		Level1CategoryId = <cfqueryparam cfsqltype="cf_sql_integer" value="1" /> 
		AND		Level2CategoryId = <cfqueryparam cfsqltype="cf_sql_integer" value="15" /> 
		AND		Level3CategoryId = <cfqueryparam cfsqltype="cf_sql_integer" value="17" />
		ORDER BY ActiveFlag DESC, ProductId
	</cfquery>
	<cfdump var="#strResult#">
</code>
</p>
<p>I see:
<img src="images/dump_cfquery2.gif" width="532" height="248" alt="cfdump sample 2" class="float-left" />
</p>
<p>I didn't even know about that new result attribute until I stated digging into this issue.  So, what does all of this mean?  Well, if you didn't already know about the result attribute, perhaps you can think of some uses for it.  And if your CFDUMP of a query doesn't look the way you expected, don't be scared like me, just chock it up to CF8.</p>
