Dumping Results of EntityLoads in CF9 ORM

I've started to do some more testing with ColdFusion 9's Hibernate (ORM) integration, and I noticed something interesting about a cfdump result.
I've got an entity called UserGroup, and I wanted to see a dump of the results of calling EntityLoad in different ways, so I ran the following script:
<code><cfscript>
	stuff = {};
	stuff.allGroups = EntityLoad("UserGroup");
	stuff.group1AsArray = EntityLoad("UserGroup",1);
	stuff.group1AsObject = EntityLoad("UserGroup",1,true);
</cfscript>
<cfdump var="#stuff#"></code>
</p>
<p>And this is what I see:</p>
<img src="/images/CF9ORMDump1.jpg" class="float=left" />
<p>Notice that in the first key in the struct, <em>allGroups</em>, which is the result of the call to EntityLoad("UserGroup"), I can see two objects which represent two records in the underlying table.
Notice that in the second key in the struct, <em>group1AsArray</em>, I don't see any info on the object itself, but rather a pointer back to the dump of the object in the <em>allGroups</em> key.
The same holds true for the final key in the struct, <em>group1AsObject</em>.
</p>	
<p>If I remove the call to EntityLoad("UserGroup"), like so:
<code><cfscript>
	stuff = {};
	stuff.group1AsArray = EntityLoad("UserGroup",1);
	stuff.group1AsObject = EntityLoad("UserGroup",1,true);
</cfscript>
<cfdump var="#stuff#"></code>
</p>
<p>then my dump looks like this:</p>
<img src="/images/CF9ORMDump2.jpg" class="float=left" />
<p>Notice that again the actual dump of the object only appears once, in the first key, with a pointer to the first key appearing in the second key.
</p>	
<p>Perhaps this is linked in some way to Hibernate's session cache, or maybe it's just a way for Adobe to optimize cfdump for ORM entities. 
Either way I'm not sure that the information (about how cfdump output appears) is particularly useful, but I do find it interesting.</p>
