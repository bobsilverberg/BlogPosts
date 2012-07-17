ValidateThis 0.91 - Now with Groovy and ColdFusion on Wheels Support

I've just released version 0.91 of ValidateThis, my validation framework for ColdFusion objects. Here's a summary of the enhancements, followed by the details for each one.
<ul>
	<li>VT can now be used to validate Groovy objects.</li>
	<li>VT can now be used to validate ColdFusion on Wheels objects.</li>
	<li>getVersion() is now available.</li>
	<li>VT source code is now being housed at GitHub.</li>
</ul>
</p>
<p>The latest version can be downloaded from <a href="http://validatethis.riaforge.org/" target="_blank">the ValidateThis RIAForge site</a>.  Details of the enhancements follow:<more/>
<h3>Groovy Object Support</h3>
<p>Thanks to a suggestion, and some hard work, by TJ Downes I've been able to add support for Groovy objects to
VT. I don't have any experience working with Groovy, but, again at TJ's suggestion, I grabbed a copy of 
<a href="http://www.barneyb.com/barneyblog/" target="_blank">Barney Boisvert</a>'s
<a href="http://www.barneyb.com/barneyblog/projects/cfgroovy2/" target="_blank">CFGroovy</a> project and was able to get up and running pretty quickly.
VT now has the ability to identify a Groovy object, check whether a property exists and get the value for a property. With those tricks up its sleeve it's
able to do all of its server-side validation magic. You simply take a Groovy object and pass it into VT's validate method and it should work
just like it does with CFCs.</p>
<p>If anyone out there is using Groovy objects with CF and would like to take VT for a spin it would be much appreciated. I don't really have the knowledge or experience to 
push the boundaries on this one. If you are able to try you can count on my help and support, so just ask.</p>
<h3>ColdFusion on Wheels Object Support</h3>
<p>Again thanks to a suggestion, and possibly even more hard work, by <a href="http://www.henke.ws/" target="_blank">Mike Henke</a>
 I've been able to add support for <a href="http://cfwheels.org/" target="_blank">ColdFusion on Wheels</a> objects to
VT. The issue with Wheels objects is that they do not expose getters for their properties, whereas VT expected to be able to call a getter to determine the 
current value of a property. I was able to combine my changes to support Groovy with changes to support Wheels objects so that now VT will
also be able to automatically identify a Wheels object and will know how to get at its properties.</p>
<p>Mike has been working on a plugin for Wheels that will make working with VT a piece of cake. I think the plugin is almost ready to be released,
and if you're interested in taking a look at it right now, you can grab a copy from Mike's <a href="http://github.com/mhenke/validateThisCFWheels" target="_blank">GitHiub project</a>.</p>
<p>I'll post more info on the plugin and how to use it when it is released.</p>
<h3>getVersion()</h3>
<p>This is probably more meaningful to me than anyone else, but I've added a getVersion() method to VT that will allow you to know which version you're running.
You can call this on the ValidateThis.cfc facade object as well as on any business object that has VT injected into it.</p>
<h3>VT Source Code on GitHub</h3>
<p>It's actually been there for quite awhile, but I finally weaned myself off SVN for this project and have made the 
<a href="http://github.com/bobsilverberg/ValidateThis" target="_blank">ValidateThis GitHiub project</a> the official location for the bleeding edge code.
If anyone is interested in contributing to the project, just grab a GitHub account and create yourself a fork of my repo.</p>
<h3>On the Horizon</h3>
<p>I hope to produce some documentation for working with VT with other frameworks, such as Model-Glue, ColdBox and ColdFusion on Wheels, as well as how to integrate VT
into ColdFusion 9 ORM objects. Also, <a href="http://www.aliaspooryorik.com/" target="_blank">John Whish</a> has been working on a ValidateThis/ColdBox 3/CF9 ORM sample application,
which I hope to find time to contribute to. It should be made available in the near future.</p>
<p>Once again, the latest code is available from <a href="http://validatethis.riaforge.org/" target="_blank">the ValidateThis RIAForge site</a>, and if you have any questions about the framework, or suggestions for enhancements, please send them to the <a href="http://groups.google.com/group/validatethis" target="_blank">ValidateThis Google Group</a>.</p>
