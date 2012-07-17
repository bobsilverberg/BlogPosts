A Git Workflow for Open Source Collaboration - Part IV - Submitting Contributions

In this installment in my <a href="http://www.silverwareconsulting.com/index.cfm/Git-Workflow">series describing a Git workflow for open source collaboration</a> 
we'll look at the final step in the workflow, submitting your contribution to the project owner(s).</p>
<h3>Create a GitHub Pull Request</h3>
<p>Your <em>develop</em> branch in your fork now contains the code you want to contribute, 
so you now need to send a <a href="http://github.com/blog/712-pull-requests-2-0" target="_blank">pull request</a> to the project owner(s) 
asking them to accept your contribution.
Go to the main page for your GitHub repo (the fork that you created and to which you just pushed), and click the <em>pull request</em> button, which looks like this:<br />
<img src="/images/github-pull-request-button.jpg" /><br />
You'll see a screen similar to this:<br />
<img src="/images/github-pr-1.jpg" /><br />
This contains a bunch of information about the pull request you are about to create. The first thing to notice is the section near the top of the screen that shows you the <em>into</em> and the <em>from</em>
of the pull request:<br />
<img src="/images/github-pr-2-to-from.jpg" /><br />
This is how it should look. You are requesting a pull from your <em>develop</em> branch into ValidateThis' <em>develop</em> branch. 
If the into and from are not correct you can click the button labelled "Change Commits" and you should see the following added to the screen:<br />
<img src="/images/github-pr-3-changecommits.jpg" /><br />
You can change both the target repository and the branch within the target repository from this screen. 
When they are accurate click the "Update Commit Range" button. 
This should populate the pull request with only those commits that differ between your <em>develop</em> branch and the <em>develop</em> branch in the main repo. 
After this you should provide a descriptive title and description in the text boxes under the "Preview Discussion" tab:<br />
<img src="/images/github-pr3-desc.jpg" /><br />
and then click the "Send pull request" button.</p>
<p>This will automatically add an issue to the main project repo so that the project owner(s) can be informed. It is then up to them to review your request and apply it to the <em>develop</em> branch in the main repo as they see fit.
As discussed in <a href="http://nvie.com/git-model" target="_blank">Vincent Driessen's post</a>, all work is housed in this <em>develop</em> branch, and the master branch is only used for actual releases, so
it is up to the project owner(s) to merge changes from <em>develop</em> into <em>master</em> when the time comes.</p>
<p>The fine folks at GitHub just introduced this new pull request system which allows contributors and owners to have a discussion about the pull request before changes are applied.
It also has a nifty feature that will show you a diff of all of the changes that are included in the pull request, which I find tremendously useful.
If the owner doesn't like the submission suggestions can be made for changes, and you can change your code, push the changes to your fork, and issue another pull request.</p>
<h3>What's next?</h3>
<p>That's the end of this series, but undoubtedly not the final word on this workflow. We plan to make use of it on the ValidateThis project, and any changes that we deem necessary
will turn into updates to these posts.
It is my hope that other projects using Git for collaboration, who don't already have an established workflow, may benefit from this information.</p>
