Getting Code Assistance in Eclipse when Creating ValidateThis XML Files

Although ValidateThis, my validation framework for ColdFusion objects, can accept metadata in a number of formats, my preferred method is via an
XML file. This file defines all of the validation rules for a particular object, and can, obviously, be created using any text editor.
If, like me, you are using Eclipse as your IDE (which includes users of ColdFusion Builder), you can enable code assist thanks to the 
XML Schema Definition (XSD) that I created for ValidateThis. This post will describe how to enable that feature.</p>
<h3>What is an XSD?</h3>
<p>XSD stands for XML Schema Definition. It is the successor to the Document Type Definition (DTD), providing a description of the required structure of
a particular type of XML document. XSDs are themselves written in XML, which makes them both machine- and human-readable. They are therefore an
excellent source of documentation about the type of XML document that they describe, and they can also be used to validate an XML document and to
enable code assist when editing an XML document.</p>
<h3>Enabling Code Assist in Eclipse</h3>
<p>Many modern IDEs support code assist via XSDs when editing an XML file. Certain Eclipse XML plugins provide this feature, and it is enabled
automatically simply by including the path to the XSD in the XML file itself. Here's an example from a ValidateThis rules definition file:
<code><?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<!-- rules defined in here -->
</validateThis></code></p>
<p>The value of the <em>xsi:noNamespaceSchemaLocation</em> attribute is what tells the IDE where to find the XSD. In this example the XSD
is in the same folder as the XML file, which is why the value of the attribute is simply the name of the XSD. You can also point to an XSD
that lives online. In fact, there's an XSD available at <a href="http://www.ValidateThis.org/validateThis.xsd" target="_blank">http://www.ValidateThis.org/validateThis.xsd</a>,
so your xml file could include:
<code><?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="http://www.ValidateThis.org/validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<!-- rules defined in here -->
</validateThis></code></p>
<p>and you should be able to validate your XML file and get code assistance from your XML plugin.</p>
<h3>Validating the XML File</h3>
<p>Once you have a valid link to an XSD in your xsi:noNamespaceSchemaLocation attribute, you should be able to validate your document against the
schema by either right-clicking inside the document, or right-clicking on the file name in the navigator, and choosing <em>Validate</em>. Note that
you will also have inline validation, so if you change some code in your XML document so that it is no longer valid, that code should appear with
a squiggly red line underneath it - an indicator that there is a problem.</p>
<h3>The Aptana XML Editor Does Not Provide Code Assist</h3>
<p>Unfortunately, the Aptana XML Editor, which is the one that comes bundled with ColdFusion Builder, does not provide code assist. This is really
too bad, as, in my opinion, there isn't much point to having an XML plugin that does not provide this feature. You can still get code assist when
using CFBuilder as long as you use a different XML editor.</p>
<p>Right-click on an xml file in the Navigator and choose <em>Open With</em>. You will see an option for
<em>CF Builder XML Editor</em>, which is probably the default for your install. Do not choose that one as you will not get code assist.
If you have CFBuilder installed as a plugin to Eclipse you should also see an option for <em>XML Editor</em>. If you choose that one you
<em>should</em> get code assist. If you have CFBuilder installed in standalone mode, you may not see any other XML editors listed, in which 
case you'll need to install a new XML editor as a plugin in order to get code assist. But don't worry, this is a relatively simple task.</p>
<h3>Installing a New XML Editor into Eclipse</h3>
<p>As mentioned above, CFBuilder <em>is</em> Eclipse, so even though it doesn't come bundled with any other XML editors when installed in 
standalone mode, you can add a new one. The editor that is normally available to folks running CFBuilder as an Eclipse plugin is the one that
is part of the <em>Web Tools Platform (WTP)</em>, so one of the easiest ways of getting a more useful XML editor is to install the WTP XML editor
into your standalone CFBuilder. To do that, follow these steps:
<ol>
	<li>From the <em>Help</em> menu, choose <em>Install New Software...</em></li>
	<li>If you haven't already added the Galileo Update Site to your available sites do so by clicking the <em>Add...</em> button,
		entering "Galileo Update Site" for the <em>Name</em> and "http://download.eclipse.org/releases/galileo" for the <em>Location</em>, 
		and clicking <em>OK</em>. Otherwise, simply select the Galileo Update Site from your list of available sites.</li>
	<li>After a moment you should see a list of available packages. The XML editor is part of the <em>Web, XML, and Java EE Development</em> 
		package. You can place a check mark beside that entire package, to install all of the plugins, or you can expand the package using
		the little triangle, and just place a check mark beside the <em>Eclipse XML Editors and Tools</em> item and click <em>Next</em>.</li>
	<li>You'll see a dialog telling you what is about to be installed. Click <em>Next</em>.</li> 
	<li>You'll see a dialog asking you to accept the licences for the plugins. Choose <em>I accept the terms of the licence agreements</em> 
		and click <em>Finish</em>.</li>
	<li>CFBuilder will download and install the plugins, after which you'll see a dialog suggesting you restart CFBuilder. This is a good idea, so click <em>Yes</em>.</li>
	<li>CFBuilder will restart. You should now see an option for <em>XML Editor</em> in the Open With dialog when pointing to an XML file in the navigator, and choosing
		that option should enable code assist when editing your XML file.</li>
</ol>
</p>
<p>Enabling code assist when editing ValidateThis Rules Definition files should make editing them easier and faster. I also plan on adding some Eclipse
snippets to the VT distribution (an idea I'm stealing from MXUnit), for folks who prefer to work with snippets.</p>