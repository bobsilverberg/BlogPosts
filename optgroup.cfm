What the heck is an optgroup?

Although I've been developing web applications with ColdFusion for about a decade, I only discovered the existence of this html tag a few days ago, and it's way cool.</p>
<p>I've been reading up on creating accessible forms, and <a href="http://www.websemantics.co.uk/tutorials/accessible_forms/" target="_blank">this article</a> made the following suggestion:</p>
<blockquote><p>Complex selects, with more than 11 options, should be coded with option groups and labels.</p></blockquote>
<p>And contained the following example:
<label for="favcity">Which is your favourite city?
	<select id="favcity" name="favcity"> 
	<optgroup label="Europe"> 
		<option value="1">Amsterdam</option> 
		<option value="3">Interlaken</option> 
		<option value="4">Moscow</option> 
		<option value="5">Dresden</option> 
	</optgroup> 
	<optgroup label="North America"> 
		<option value="2">New York</option> 
		<option value="6">Salt Lake City</option> 
		<option value="7">Montreal</option> 
		<option value="13">Toronto</option> 
	</optgroup> 
	<optgroup label="South America"> 
		<option value="8">Buenos Aires</option> 
		<option value="9">Asuncion</option> 
	</optgroup> 
	<optgroup label="Asia"> 
		<option value="10">Hong Kong</option> 
		<option value="11">Tokyo</option> 
		<option value="12">New Dehli</option> 
	</optgroup> 
	</select> 
</label> 
<more/>
Pretty cool, eh?  Here's the code:
<code>
<label for="favcity">Which is your favourite city?
	<select id="favcity" name="favcity"> 
	<optgroup label="Europe"> 
		<option value="1">Amsterdam</option> 
		<option value="3">Interlaken</option> 
		<option value="4">Moscow</option> 
		<option value="5">Dresden</option> 
	</optgroup> 
	<optgroup label="North America"> 
		<option value="2">New York</option> 
		<option value="6">Salt Lake City</option> 
		<option value="7">Montreal</option> 
		<option value="13">Toronto</option> 
	</optgroup> 
	<optgroup label="South America"> 
		<option value="8">Buenos Aires</option> 
		<option value="9">Asuncion</option> 
	</optgroup> 
	<optgroup label="Asia"> 
		<option value="10">Hong Kong</option> 
		<option value="11">Tokyo</option> 
		<option value="12">New Dehli</option> 
	</optgroup> 
	</select> 
</label> 
</code>
</p>
<p>I also decided to try out the <a href="http://cfuniform.riaforge.org/" target="_blank">cfUniForms Library</a> by <a href="http://www.quackfuzed.com/" target="_blank">Matt Quackenbush</a> to help me create more accessible forms and found it to be an extraordinarily well written and useful tool, with one exception, no optgroup support.  So I spoke to Matt and decided to add that support myself.  I also mentioned a couple of other enhancements that I'd like to see and he implemented them pretty much immediately.  He'll be releasing a new version of the library with all of the new enhancements pretty much as soon as I finish writing this post ;-)</p>
<p>So, if you're interested in creating accessible forms and aren't already using a custom tag library to both reduce the amount of code you have to write <strong>and</strong> to encapsulate your field rendering logic, you may want to check out cfUniForm.  And if you're not already using option groups, maybe you'll give them a try as well.</p>
