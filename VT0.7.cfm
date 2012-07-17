ValidateThis! 0.7 - Super-Simple Integration

I've released version 0.7 of ValidateThis!, my validations framework for ColdFusion objects, on <a href="http://validatethis.riaforge.org/" target="_blank">RIAForge</a>. It includes the following changes:
<ul>
	<li>Introduction of the ValidateThis.cfc service object</li>
	<li>Removal of reliance on Coldspring</li>
	<li>Implementation of the ValidationErrorCollection interface in the Result.cfc object</li>
	<li>Renamed the tables in the demo database</li>
	<li>New QuickStart guide detailing how to use the ValidateThis.cfc service object</li>
</ul>
</p>
<p>The details of each of these items can be found below:
<more/>
<h3>Introduction of the ValidateThis.cfc service object</h3>
<p>Previous to this release the only way to make use of the framework was to integrate it into your Business Objects, thereby adding behaviour to them.  Although that is still my preferred method of using the framework, a new ValidateThis.cfc service object has been added which will allow a developer to use the framework by simply instantiating a single component.  One then invokes methods on that component, rather than on the business objects themselves.</p>
<p>When instantiating the ValidateThis.cfc object, one also must create a structure that includes some parameters required by the framework.  The keys in that structure mirror the ValidateThisConfig bean that was introduced in version 0.6.  Below is a description of the keys, along with the default value that is used if the key is missing from the struct:
<ul>
	<li><strong>definitionPath</strong> - This is the location of your xml files, one for each Business Object for which you want the framework to generate validations.  The  default value is "/model/".</li>
	<li><strong>JSRoot</strong> - If the framework is going to be asked to generate all of the JavaScript statements necessary to load and configure all of the required JS libraries (via the generateInitializationScript() method), this entry specifies where the JavaScript files can be found on your server. The default value is "/js/".</li>
	<li><strong>defaultFormName</strong> - This is the default form name/id to be used when generating client-side validations. It is provided for convenience as it is easily overridable on a case by case basis. The default value is "frmMain".</li>
	<li><strong>DefaultJSLib</strong> - ValidateThis can be installed with support for multiple JavaScript implementations.  This entry specifies which implementation should be used for generating client-side validations.  It is a default in that in can be overridden on a case by case basis in your application code, if desired. The default value is "jQuery", which is the implementation that currently ships with the framework.</li>
	<li><strong>BOValidatorPath</strong> -  This specifies the path to the BOValidator component, which is the facade to the entire framework.  It is possible that advanced users may want to either extend or override that component with their own version, and this entry allows for that. The default value is "BOValidator", and it is rare that one would have to override that value.</li>
</ul>
</p>
<h3>Removal of reliance on Coldspring</h3>
<p>Previous to this release the internal components of the framework were wired together using Coldspring.  To ease integration I chose to do the dependency injection (DI) manually.  You can certainly still use Coldspring to integrate VT into your app if you wish, but it is no longer required.</p>
<h3>Implementation of the ValidationErrorCollection interface in the Result.cfc object</h3>
<p>In order to allow VT to act as a validation plug-in to Model-Glue scaffolding, I implemented the interface for Model-Glue's ValidationErrorCollection into the Result.cfc object.</p>
<h3>Renamed the tables in the demo database</h3>
<p>I did some cleanup that involved renaming the tables in the database used by the demo applications.  So if you download a new version of the framework and demo zip file, you'll need to rerun the SQL setup scripts, or you could just take a look at them and manually rename your tables.</p>
<h3>New QuickStart guide detailing how to use the ValidateThis.cfc service object</h3>
<p>A new QuickStart guide can be found in the root of the zip file that describes how to get up and running using the new ValidateThis.cfc service object.  I will be providing the same information in a blog posting shortly.</p>
<p>As always, if you have any questions or interest in following the progress of VT, I invite you to join the <a href="http://groups.google.com/group/validatethis" target="_blank">ValidateThis! Google Group.</p>
