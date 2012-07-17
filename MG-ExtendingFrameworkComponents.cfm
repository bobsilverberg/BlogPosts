Customizing Model-Glue by Overriding Framework Components

One of the cool features of <a href="http://www.model-glue.com/blog/" target="_blank">Model-Glue version 3</a> is the ability to replace many of the components that make up the framework with your own version.
This allows you to change the default behaviour of the framework (which can be useful) without having to alter any of the framework's internal code (which is a bad idea).
Let's look at a situation in which we might want to customize Model-Glue and how we would do it.</p>
<h3>Customizing Generated Code</h3>
<p>Scaffolding is a feature of the framework that allows Model-Glue to generate working CRUD code for an object when you're using an ORM. Model-Glue 3.1 supports
<a href="http://www.transfer-orm.com/" target="_blank">Transfer</a> and <a href="http://trac.reactorframework.com/" target="_blank">Reactor</a>,
and Model-Glue 3.2 (coming soon)
will also support ColdFusion 9's built-in ORM features. When you ask Model-Glue to do scaffolding for an object it will create event handlers and view templates for the operations that you request, which can include
List, View, Edit, Commit and Delete. The code that is generated is based on cfcs that, by default, are found in ModelGlue/gesture/modules/scaffold/beans.
The cfcs are called View.cfc, List.cfc, etc.</p>
<p>If we want to change the way the view template is generated for the List action, we can simply edit the file ModelGlue/gesture/modules/scaffold/beans/List.cfc, changing the code to
reflect how we want our List view template to be generated.</p>
<p>But wait, didn't we discuss earlier that changing files within the framework itself is a Bad Thing&copy;?
No problem. Model-Glue allows you to override its own internal components by pointing to a component that belongs to your own application, which lives outside of
Model-Glue's code base.<more/><h3>How Model-Glue's Components are Defined</h3>
<p>All of the components that can be overridden can be found in Model-Glue's own Coldspring config file, which can be found in
<em>ModelGlue/gesture/configuration/ModelGlueConfiguration.xml</em>. Let's take a look at a snippet from that file to see how we'd change the behaviour of our List scaffold:
<code><bean id="modelglue.scaffoldManager" 
	class="ModelGlue.gesture.modules.scaffold.ScaffoldManager">
	<constructor-arg name="modelGlueConfiguration">
		<ref bean="modelglue.modelGlueConfiguration" />
	</constructor-arg>
	<constructor-arg name="scaffoldBeanRegistry">
		<map>
			<entry key="Commit"><ref bean="modelglue.scaffoldType.Commit" /></entry>
			<entry key="Delete"><ref bean="modelglue.scaffoldType.Delete" /></entry>
			<entry key="Edit"><ref bean="modelglue.scaffoldType.Edit" /></entry>
			<entry key="List"><ref bean="modelglue.scaffoldType.List" /></entry>
			<entry key="View"><ref bean="modelglue.scaffoldType.View" /></entry>
		</map>
	</constructor-arg>
	<property name="modelGlue">
		<ref bean="modelglue.ModelGlue" />
	</property>
</bean>

<bean id="modelglue.scaffoldType.List"
	class="coldspring.beans.factory.config.MapFactoryBean">
	<property name="SourceMap">
		<map>
			<entry key="class">
				<value>ModelGlue.gesture.modules.scaffold.beans.List</value>
			</entry>
			<event key="hasXMLGeneration"><value>true</value></event>
			<event key="hasViewGeneration"><value>true</value></event>
			<entry key="prefix"><value>List.</value></entry>
			<entry key="suffix"><value>.cfm</value></entry>
		</map>
	</property>
</bean></code></p>
<p>The first Coldspring bean definition we see, for a bean called <em>modelglue.scaffoldManager</em> controls all of the scaffolding behaviour for the framework.
Looking at that bean definition we can see that a number of other beans are registered as scaffold beans by putting them into the <em>scaffoldBeanRegistry</em> map.
So we don't actually have to replace that bean (the <em>modelglue.scaffoldManager</em> bean), we just have to replace the bean for the List action, which we can see
points to a bean definition with an id of <em>modelglue.scaffoldType.List</em>. That bean definition is the second one in the code snippet above. So, how do we tell Model-Glue
that when it creates a List scaffold we want it to use our own List.cfc component, rather than the default ModelGlue/gesture/modules/scaffold/beans/List.cfc?  We have to <em>override</em>
the bean definition for <em>modelglue.scaffoldType.List</em>.
</p>
<h3>Overriding Model-Glue's Bean Definitions</h3>
<p>We can override the bean definition for <em>modelglue.scaffoldType.List</em> by simply copying the code from <em>ModelGlueConfiguration.xml</em> into our
application's own local Coldspring.xml file. After doing that, our local Coldspring.xml file will contain the following code (in addition to all of the other beans in there already):
<code><bean id="modelglue.scaffoldType.List" 
	class="coldspring.beans.factory.config.MapFactoryBean">
	<property name="SourceMap">
		<map>
			<entry key="class">
				<value>ModelGlue.gesture.modules.scaffold.beans.List</value>
			</entry>
			<event key="hasXMLGeneration"><value>true</value></event>
			<event key="hasViewGeneration"><value>true</value></event>
			<entry key="prefix"><value>List.</value></entry>
			<entry key="suffix"><value>.cfm</value></entry>
		</map>
	</property>
</bean></code></p>
<h3>What Have We Accomplished?</h3>
<p>All we've done at this point is to tell Model-Glue (or more accurately Coldspring) that when it needs to find the bean definition for <em>modelglue.scaffoldType.List</em> it should
use the definition in our local Coldspring.xml file, rather than the one in <em>ModelGlueConfiguration.xml</em>. But the bean definition is still the same, so
we've overridden the bean definition but we haven't changed the behaviour.</p>
<h3>Changing Behaviour</h3>
<p>How do we tell Model-Glue to use our version of List.cfc rather than ModelGlue/gesture/modules/scaffold/beans/List.cfc?
We just change the value of the <em>class</em> key in our local <em>modelglue.scaffoldType.List</em> bean definition. The new version will look something like this:
<code><bean id="modelglue.scaffoldType.List" 
	class="coldspring.beans.factory.config.MapFactoryBean">
	<property name="SourceMap">
		<map>
			<entry key="class"><value>myApp.scaffold.beans.List</value></entry>
			<event key="hasXMLGeneration"><value>true</value></event>
			<event key="hasViewGeneration"><value>true</value></event>
			<entry key="prefix"><value>List.</value></entry>
			<entry key="suffix"><value>.cfm</value></entry>
		</map>
	</property>
</bean></code></p>
<p>Where my custom version of List.cfc lives in <em>/myApp/scaffold/beans/</em>, which is a folder in my application. It's as simple as that.
Now, when I ask Model-Glue to scaffold an object, the event handler and view template for the List action will
be generated based on code in my <em>myApp.scaffold.beans.List.cfc</em> component, rather than the default <em>ModelGlue.gesture.modules.scaffold.beans.List.cfc</em> component.</p>
<p>We can further customize the List behaviour by changing other keys in the <em>modelglue.scaffoldType.List</em> bean definition. 
For example, the default filename that will be generated for a List action for a Product object would be <em>List.Product.cfm</em>. 
This is because the <em>prefix</em> is defined as "List." and the <em>suffix</em> is defined as ".cfm". If we want to generate a file called
<em>dspProductList.cfm</em>, we could further change our bean definition like so:
<code><bean id="modelglue.scaffoldType.List" 
	class="coldspring.beans.factory.config.MapFactoryBean">
	<property name="SourceMap">
		<map>
			<entry key="class"><value>myApp.scaffold.beans.List</value></entry>
			<event key="hasXMLGeneration"><value>true</value></event>
			<event key="hasViewGeneration"><value>true</value></event>
			<entry key="prefix"><value>dsp</value></entry>
			<entry key="suffix"><value>List.cfm</value></entry>
		</map>
	</property>
</bean></code></p>
<p>You can use this technique to override any of the bean definitions in the ModelGlueConfiguration.xml file. For example, if you want to support SES urls you can override
Model-Glue's default UrlManager by placing a bean definition for <em>modelglue.UrlManager</em> into your local Coldspring config. You can also override the default ValidationService
that Model-Glue uses for Generic Database Messages (GDMs) by placing a bean definition for <em>modelglue.ValidationService</em> into your local Coldspring config. You could use that,
for example, to enable the use of <a href="http://www.validatethis.org" target="_blank">ValidateThis</a> to provide validations for GDMs. I am doing that in conjunction with
the new CF9 ORM Adapter in an application right now, and I plan to write a more detailed post about it in the near future.</p>
