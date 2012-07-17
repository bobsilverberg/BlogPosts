Gets run each time:

from scripts where runat='onGlobalRequestStart'

from scripts where runat='onSiteRequestInit' and siteID='default'

session tracking INSERT and DELETE


Cached:

select * from variables.rsPlugins where	pluginID=9

select * from variables.rsSettings where  moduleID='FBDD02FA-1517-0AA5-64407D16575104DC'

select pluginID, package, directory, scriptfile,name, docache, moduleID from variables.rsScripts 
	where runat='standardSetContentRendererHandler'	and siteID='default'
	
select pluginID, package, directory, scriptfile,name, docache, moduleID from variables.rsScripts 
	where runat='standardSetContentHandler'	and siteID='default'

	select pluginID, package, directory, scriptfile,name, docache, moduleID from variables.rsScripts 
	where runat='standardSetAdTrackingHandler'	and siteID='default'

select tcontent.*, tfiles.fileSize, tfiles.contentType, tfiles.contentSubType, tfiles.fileExt from tcontent 
left join tfiles on (tcontent.fileid=tfiles.fileid)
where tcontent.filename is null
and  tcontent.active=1 and 
 tcontent.type in('Page','Portal','Calendar','Gallery') 
and  tcontent.siteid='default'
		

select contenthistid, contentid, menutitle, filename, parentid, type, target, targetParams, 
siteid, restricted, restrictgroups,template,inheritObjects,metadesc,metakeywords,sortBy,
sortDirection,
len(Cast(path as varchar(1000))) depth
from tcontent where 
contentID in ('00000000000000000000000000000000001')
and active=1 
and siteid= 'default'
order by depth desc

select pluginID, package, directory, scriptfile,name, docache, moduleID from variables.rsScripts 
where runat='standard404Validator'
and siteID='default'
	
select pluginID, package, directory, scriptfile,name, docache, moduleID from variables.rsScripts 
where runat='standardWrongDomainValidator'	and siteID='default'

select pluginID, package, directory, scriptfile,name, docache, moduleID from variables.rsScripts
where runat='standardTrackSessionValidator'	and siteID='default'

select pluginID, package, directory, scriptfile,name, docache, moduleID from variables.rsScripts 
where runat='standardTrackSessionHandler'	and siteID='default'
