What's New in ValidateThis 0.98 - Part II - New Validation Types

In addition to a bunch of neat new features, version 0.98 of <a href="http://www.validatethis.org/" target="_blank">ValidateThis</a> also included 
a number of new validation types.
One of the most important aspects of the framework, to me anyway, is the fact that it is incredibly extensible and allows you to easily create your own
validation types, which is precisely what a number of folks including <a href="http://adamdrew.me/blog/" target="_blank">Adam Drew</a>, 
<a href="http://blog.mxunit.org/" target="_blank">Marc Esher</a> and <a href="http://chris.m0nk3y.net/" target="_blank">Chris Blackwell</a> did.
They were also kind enough to contribute those validation types to the framework so we can all benefit from them. In this post I'll describe each of the types that were added for version 0.98.</p>
<p>Each validation type accepts certain parameters, all of which have been documented in the <a href="http://www.validatethis.org/docs/wiki/Validation_Types_Supported_By_ValidateThis.cfm" target="_blank">ValidateThis Online Documentation</a>, so I won't clutter up this post with that information.
You can click on the name of each type in this post and be taken directly to its description in the docs if you wish. I'll just concentrate on describing what the validation type
tests and suggestions for ways in which it might be useful.</p>
<h3>New Validation Types</h3>
<p><strong><a href="http://www.validatethis.org/docs/wiki/Validation_Types_Supported_By_ValidateThis.cfm#CollectionSize" target="_blank">CollectionSize</a></strong></p>
<p>The <em>CollectionSize</em> type ensures that the contents of a property is of a specific size. On the server this can be a list, struct or array. A client version is still being developed.
You can validate whether a collection is of a particular size and/or whether it is at least or at most a particular number of items. For example, a customer could have between 1 and 3 addresses.</p>
<p><strong><a href="http://www.validatethis.org/docs/wiki/Validation_Types_Supported_By_ValidateThis.cfm#DateRange" target="_blank">DateRange</a></strong></p>
<p>The <em>DateRange</em> type ensures that the contents of a property is a valid date that falls between two dates. Note that you can use the new <em>expression</em>
parameter type to make the <em>from</em> and <em>to</em> dates dynamic (e.g., set one to <em>now()</em>).</p>
<a href="http://www.validatethis.org/docs/wiki/Validation_Types_Supported_By_ValidateThis.cfm#DoesNotContainOtherProperties" target="_blank"><p><strong>DoesNotContainOtherProperties</strong></p></a> 
<p>The <em>DoesNotContainOtherProperties</em> type ensures that the contents of a property does not contain values found in other properties. This can be used, for example, to ensure that a <em>password</em> property does not include the user's first or last names.</p>
<a href="http://www.validatethis.org/docs/wiki/Validation_Types_Supported_By_ValidateThis.cfm#False" target="_blank"><p><strong>False</strong></p></a> 
<p>The <em>False</em> type ensures that the contents of a property is a value that can be interpreted as <em>false</em>. This includes the values <em>false</em>,<em>no</em> and <em>0</em>.</p>
<a href="http://www.validatethis.org/docs/wiki/Validation_Types_Supported_By_ValidateThis.cfm#FutureDate" target="_blank"><p><strong>FutureDate</strong></p></a> 
<p>The <em>FutureDate</em> type ensures that the contents of a property is a valid date that falls after a particular date. 
By default it compares the contents of the property to the current date, but you can pass in an optional <em>after</em> parameter to validate whether the contents of the property falls after a specific date.</p>
<a href="http://www.validatethis.org/docs/wiki/Validation_Types_Supported_By_ValidateThis.cfm#InList" target="_blank"><p><strong>InList</strong></p></a> 
<p>The <em>InList</em> type ensures that the contents of a property is one of the values specified in a list. You can pass in the delimiter for the list as an optional parameter.</p>
<a href="http://www.validatethis.org/docs/wiki/Validation_Types_Supported_By_ValidateThis.cfm#IsValidObject" target="_blank"><p><strong>IsValidObject</strong></p></a> 
<p>The <em>IsValidObject</em> type is used to validate properties which contain other objects. For example, say you have a <em>User</em> object which has an <em>address</em> 
property which contains an <em>Address</em> object. If you have validation rules defined for the <em>Address</em> object then you can add a rule to the <em>address</em> 
property of your <em>User</em> object of type <em>IsValidObject</em> and when you ask ValidateThis to perform server-side validations on your <em>User</em> object it will 
also automatically validate the composed <em>Address</em> object and return all of the failures for both objects to you in the Result.</p>
<a href="http://www.validatethis.org/docs/wiki/Validation_Types_Supported_By_ValidateThis.cfm#NoHTML" target="_blank"><p><strong>NoHTML</strong></p></a> 
<p>The <em>NoHTML</em> type ensures that the contents of a property does not contain HTML.</p>
<a href="http://www.validatethis.org/docs/wiki/Validation_Types_Supported_By_ValidateThis.cfm#NotInList" target="_blank"><p><strong>NotInList</strong></p></a> 
<p>The <em>NotInList</em> type ensures that the contents of a property is not one of the values specified in a list. You can pass in the delimiter for the list as an optional parameter.</p>
<p>The <em>PastDate</em> type ensures that the contents of a property is a valid date that falls before a particular date. 
By default it compares the contents of the property to the current date, but you can pass in an optional <em>before</em> parameter to validate whether the contents of the property falls before a specific date.</p>
<a href="http://www.validatethis.org/docs/wiki/Validation_Types_Supported_By_ValidateThis.cfm#True" target="_blank"><p><strong>True</strong></p></a> 
<p>The <em>True</em> type ensures that the contents of a property is a value that can be interpreted as <em>true</em>. This includes the values <em>true</em>,<em>yes</em> and any number other than <em>0</em>.</p>
<a href="http://www.validatethis.org/docs/wiki/Validation_Types_Supported_By_ValidateThis.cfm#URL" target="_blank"><p><strong>URL</strong></p></a> 
<p>The <em>URL</em> type ensures that the contents of a property is a valid (properly formed) URL.</p>
<a href="http://www.validatethis.org/docs/wiki/Validation_Types_Supported_By_ValidateThis.cfm#Expression" target="_blank"><p><strong>Expression</strong></p></a> 
<p>The <em>Expression</em> type ensures that a cfml expression evaluates to true. This allows you to define any arbitrary cfml expression and have it evaluated in the context of the object being validated.</p>
<h3>Creating Your Own Validation Types</h3>
<p>If you're interested in creating your own validation types, please check out the <a href="http://www.validatethis.org/docs/wiki/Creating_New_Validation_Types.cfm" target="_blank">Creating New Validation Types</a> page in the online documentation.</p>
<p>As always, the latest code is available from <a href="http://validatethis.riaforge.org/" target="_blank">the ValidateThis RIAForge site</a>, and if you have any questions about the framework, or suggestions for enhancements, please send them to the <a href="http://groups.google.com/group/validatethis" target="_blank">ValidateThis Google Group</a>.</p>
