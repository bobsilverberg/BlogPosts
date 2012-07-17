Creating Eclipse (and CFBuilder) Keyboard Shortcuts for Subclipse

Here's another quick tip to keep your hands on the keyboard and off of the mouse. I currently use both Subversion and Git for version control of my code, but I
definitely use Subversion more. One thing that I found myself using the mouse for time and again was to commit changes to my SVN repo using the Subclipse Eclipse plug-in.
One of the worst things about that workflow is the number of steps it takes. You have to right-click, then select <em>Team</em>, and then select <em>Commit</em> from the menu. I'm not sure why
I continued to do that for so long, but I finally got around to Googling "Subversion Keyboard Shortcuts" and came across 
<a href="http://kedeligdata.blogspot.com/2009/11/binding-keyboard-shortcuts-to-subclipse.html" target="_blank">a blog post</a> by <a href="http://www.blogger.com/profile/16033062769034871096" target="_blank">Mads Dar&oslash; Kristensen</a>, with a video no less, that shows exactly how to set these up.
The steps are as simple as this:
<ol>
	<li>Open the Eclipse Preferences menu (command+, on a Mac).</li>
	<li>Choose <em>General</em> -> <em>Keys</em>.</li>
	<li>In the box where it says <em>type filter text</em>, type <strong>SVN</strong>.</li>
	<li>Choose the <em>Commit</em> command from the list of commands.</li>
	<li>Place your cursor in the box labelled <em>Binding</em> and type the key combination you wish to use. I use control+option+C.</li>
	<li>Click the <em>Apply</em> button.</li>
</ol>
</p>
<p>Now, when you're done editing a file and you want to commit it to your SVN repo, just type the key combination and the Subclipse Commit dialog box will appear. 
If you want to commit all files in a project or a folder, rather than just the current file, then highlight the project or folder (which seems to require some mouse-work, unfortunately), and then type your combo.
I've also assigned control+option+R to <em>Revert</em> and control+option+S to <em>Synchonize with Repository</em>. I'm finding that these shortcuts are saving me a lot of time, and allowing me to keep my hands on the keyboard, where they belong.
</p>