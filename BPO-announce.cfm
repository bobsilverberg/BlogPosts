A Base Persistent (ORM) Object for CF9

I've been doing some experimentation with ColdFusion 9's Hibernate (ORM) integration, part of which involved creating a Base Persistent Object.</p>
<h3>What is a Base Persistent Object?</h3>
<p>I'm using the term <em>persistent object</em> to refer to a ColdFusion 9 cfc that has a <em>persistent="true"</em> attribute.  
That is, a component that is used to create objects that will be persisted to a database via Hibernate, using CF9's ORM integration.  
These are variously referred to as persistent objects, ORM objects, entity objects, etc. There are certain behaviours that I want all of my persistent objects to have,
and I have found that the best way to achieve this is to create a base persistent object and then have all of my concrete persistent objects extend that base object.</p>
<h3>Behaviours contained in the Base Persistent Object</h3>
<p>The behaviours that I'm including in my Base Persistent Object allow any object that extends it to:
<ul>
	<li>populate itself from user-submitted data</li>
	<li>save itself</li>
	<li>delete itself</li>
	<li>validate itself</li>
	<li>inject dependencies into itself via Coldspring</li>
</ul>
</p>
<p>As CF9 is still in beta, this object is obviously in flux.  I am planning on releasing the code for the object as open source,
 and have set up a project at <a href="http://basepersistentobject.riaforge.org/" target="_blank">BasePersistentObject.riaforge.org</a> for that purpose.
I hope to have a 0.1 version available shortly, at which point the code will be available for download via the project page.</p>
