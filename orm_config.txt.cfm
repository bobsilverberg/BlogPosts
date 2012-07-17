== ColdFusion ORM ==
ColdFusion ORM is available in ColdFusion versions 9.0 and above, so no installation is necessary.

Create a 'transfer' directory in {webroot}/fooproject/config and also a 'transfer' directory inside {webroot}/fooproject/model.

Make sure that you have ORM enabled in your Application.cfc file. An example is: 
{{{
<cfset this.ormenabled = true />
<cfset this.datasource = "FooDataSourceName" />
<cfset this.ormsettings = {flushAtRequestEnd=false,automanageSession=false} />
}}}


Connect ColdFusion ORM to !ModelGlue through !ColdSpring. Open {webroot}/fooproject/config/ColdSpring.xml and paste the following definitions:


{{{
 <!-- Example ColdSpring.xml for ColdFusion ORM in an MG:3 application -->
 <beans>
  ...
  <alias alias="ormAdapter" name="ormAdapter.cfORM" />
  <alias alias="ormService" name="ormService.cfORM" />
 </beans>
}}}

You should now be able to use !ModelGlue [[http://docs.model-glue.com/wiki/HowTos/HowToUseGenericDatabaseMessages Generic Database Messages]] and [[http://docs.model-glue.com/wiki/HowTos/HowToUseScaffolds Scaffolds]] powered by ColdFusion ORM in your application.

'''References'''

 * [http://help.adobe.com/en_US/ColdFusion/9.0/Developing/WSD628ADC4-A5F7-4079-99E0-FD725BE9B4BD.html]
