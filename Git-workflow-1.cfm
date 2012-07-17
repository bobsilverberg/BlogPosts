A Git Workflow for Open Source Collaboration

As some of you may know, I'm the lead developer on an open source project called <a href="http://www.validatethis.org" target="_blank">ValidateThis</a>.
I changed the version control software that I'm using for the project from Subversion to Git almost a year ago, and I've been very happy with Git ever since.
There was a bit of a learning curve to Git, particularly as I'd never really used the command line much, and it's pretty much required with Git, but that
was actually one of the reasons for the switch - to give me the impetus to really learn how to work with Git.</p>
<p>I am lucky enough to have several contributors to the project, and they made me aware recently that the fact that the source is housed in a Git 
repository is interfering with their ability to make contributions. They all have plenty of experience working with Subversion, but Git is quite new to most of
them. Simply learning the syntax of Git is no problem, but what many people find difficult, me included, is figuring out how to change their workflow, as 
working with Git can be quite different from working with Subversion. So I decided to do some research and come up with a proposal for a workflow for
all of the contributors. We're going to give it a try and see how well it goes. If changes need to be made, we'll make them. 
My hope is that the workflow we devise is one that can be used by other open source projects as well, if they choose to do so.</p>
<p>The remainder of this post will be devoted to describing the workflow in as much detail as possible, but I'd like to start with some credit. The overall
workflow is based on one published by <a href="http://nvie.com/about" target="_blank">Vincent Driessen</a> on 
<a href="http://nvie.com/" target="_blank">his blog</a> in a post titled <a href="http://nvie.com/git-model" target="_blank"><em>A successful Git branching model</em></a>.
I read a number of excellent posts about Git workflows as I was researching this, and if you'd like to educate yourself before going further here are some links:
<ul>
	<li><a href="http://reinh.com/blog/2009/03/02/a-git-workflow-for-agile-teams.html" target="_blank"><em>A Git Workflow for Agile Teams</em></a> by <a href="http://reinh.com/" target="_blank">Rein Henrichs</a></li>
	<li><a href="http://yehudakatz.com/2010/05/13/common-git-workflows/" target="_blank"><em>My Common Git Workflow</em></a> by <a href="http://yehudakatz.com/" target="_blank">Yehuda Katz</a></li>
	<li><a href="http://osteele.com/archives/2008/05/my-git-workflow" target="_blank"><em>My Git Workflow</em></a> by <a href="http://osteele.com/" target="_blank">Oliver Steele</a></li>
	<li><a href="http://tomayko.com/writings/the-thing-about-git" target="_blank"><em>The Thing About Git</em></a> by <a href="http://tomayko.com/about" target="_blank">Ryan Tomayko</a></li>
	<li><a href="http://brandonkonkle.com/blog/2010/apr/28/our-git-workflow/" target="_blank"><em>Our Git Workflow</em></a> by <a href="http://brandonkonkle.com/about/" target="_blank">Brandon Konkle</a></a></li>
</ul></p>
<p>Each of those posts addresses different issues, some of them having to do with collaboration, some having to do with how you work locally, and a lot of talk about rebasing.
Some of the posts are a bit lengthy, but I do encourage you to read through them if you want to get a good idea of some of the issues that people have thought 
about when trying to come up with a Git workflow.</p>
<h3>It's based on Vincent Driessen's workflow</h3>
<p>Even if you choose not to read any of the posts that I've listed above, I'm afraid you're going to have to read through <a href="http://nvie.com/git-model" target="_blank">Vincent Driessen's post</a>
as it forms the basis of this workflow. I don't think it would be fair for me to simply repeat all of the information from Vincent's blog, so the remainder of this
post is going to assume you're familiar with Vincent's workflow.</p>
<h3>It uses GitHub</h3>
<p>There is no reason why you have to use <a href="http://github.com/" target="_blank">GitHub</a> for your remotes when implementing a similar workflow but, because I <em>am</em> using GitHub, the instructions 
below will use terms and screen caps from GitHub, and will be based on some of GitHub's features, including the brand spanking 
new <a href="http://github.com/blog/712-pull-requests-2-0" target="_blank">pull request system</a>.</p>
<h3>Getting started</h3>
<p>In order to make use of this workflow you'll need to have Git installed on your machine, you'll need a GitHub account, and you'll need to configure your
machine to talk to GitHub. I wrote a <a href="http://www.silverwareconsulting.com/index.cfm/2009/10/26/Setting-up-a-Mac-to-Work-with-Git-and-GitHub">blog post covering those topics</a>, for folks on OS X, awhile back.
If you are on another OS there are plenty of resources available.</p>
<p>This post assumes that you're starting from scratch, so the first thing you'll need to do is create a fork of the main project repo on GitHub.</p> 
<h3>Create a fork</h3>
<p>
For the purposes of this post I'll be using the repo for ValidateThis, so go to the main GitHub repo for ValidateThis, which is located at
<a href="http://github.com/ValidateThis/ValidateThis" target="_blank">http://github.com/ValidateThis/ValidateThis</a>. Click the 
fork button which you'll see near the upper right-hand corner of the screen:<br />
<img src="/images/github-fork-button.jpg" /><br />
You'll see a message similar to this, telling you that GitHub is creating a fork of the repo for you:<br /><br />
<img src="/images/github-forking.jpg" /><br /><br />
Once the fork has been created you'll be taken to the repo page for your fork of the ValidateThis repo.
</p>
<h3>Clone the fork to your machine</h3>
<p>You're going to do all of your work on your local machine, so you need a copy of the Git repo on your machine. You can accomplish this via the <em>git clone</em> command,
and GitHub makes this very simple by providing you with a button that copies the location required for the clone command to your clipboard. Locate this button, which will look something like this:
<br /><br />
<img src="/images/github-clone-link.jpg" /><br /><br />
Click on the wee clipboard button to copy the url of the repository to your clipboard.
Pop open a terminal window and change to the folder into which you wish to place the Git repo, then enter the command: <em>git clone </em> and paste the contents of
the clipboard. Your command should look like: <code>git clone git@github.com:bobsilverberg/ValidateThis.git</code></p>
<p>After issuing the command you should see a message similar to:<code>Cloning into ValidateThis...
remote: Counting objects: 2457, done.
remote: Compressing objects: 100% (579/579), done.
remote: Total 2457 (delta 1848), reused 2457 (delta 1848)
Receiving objects: 100% (2457/2457), 2.25 MiB | 571 KiB/s, done.
Resolving deltas: 100% (1848/1848), done.</code></p>
<p>You now have a clone of your own fork of the ValidateThis repo on your machine, located in a folder called <em>ValidateThis</em> 
which is inside the folder from which you issued that command. This is where you will make all of your local changes.
Switch to that folder now by issuing the command: <code>cd ValidateThis</code></p>
<p>Take a look at the branches in the repo by issuing the command: <code>git branch</code></p>
<p>You should see something like:<code>* master</code></p>
<p>This tells you that your local repo has one branch, called <em>master</em>, and the asterisk tells you that the <em>master</em> branch is the current branch. But wait a minute, if you read the <a href="http://nvie.com/git-model" target="_blank">post by Vincent Driessen</a> 
(like you were supposed to), you'd know that any changes that you make while developing should be committed to the <em>develop</em> branch, not the
<em>master</em> branch, so where is the develop branch?</p>
<h3>Create a develop tracking branch</h3>
<p>Try issuing the command: <code>git branch -a</code></p> 
<p>The <em>-a</em> option tells git to list all local and all remote tracking branches. You should see something like:<code>* master
  remotes/origin/HEAD -> origin/master
  remotes/origin/develop
  remotes/origin/master</code></p>
<p>This tells you that, in addition to your local <em>master</em> branch, your repo knows about two remote tracking branches: <em>origin/develop</em> and <em>origin/master</em>.
<em>origin</em> is the name for the remote that was automatically added for the local repo when you issued the <em>git clone</em> command. 
<em>origin</em> is <em>your fork</em> of the ValidateThis repo. That is the remote to which you will push all of your code changes, therefore you need to set up
a local tracking branch in your local repo to correspond to the <em>develop</em> branch on the <em>origin</em> remote. You can do so by issuing the following
command: <code>git checkout -b develop origin/develop</code></p>
<p>The <em>-b</em> option tells Git that you want to create a new branch. After issuing that command you should see the following messages:<code>Branch develop set up to track remote branch develop from origin.
Switched to a new branch 'develop'</code></p>
<p>You now have a local branch called develop to which you can commit changes. 
There's still one piece of the puzzle missing: you need to be able to pull changes from the main ValidateThis repo to keep your repo in sync with the project.</p>
<h3>Add a remote for the main project repo</h3>
<p>The main repo is not your fork, it's the repo that you originally forked, the one located at http://github.com/ValidateThis/ValidateThis.
In order to be able to pull changes from this repo you need to add it as a remote, which you can do by issuing this command: <code>git remote add upstream git://github.com/ValidateThis/ValidateThis.git</code></p>
<p>The word <em>upstream</em> in that command is the name that you are giving to this remote, and the url at the end is the <em>read-only</em> url that you'll find on the main repo page. 
This command will add a remote named <em>upstream</em>, pointing at the main project repo, so you now have two remotes added to your repo: <em>origin</em>, which is your fork on GitHub, and
<em>upstream</em>, which is the main project repo on GitHub - the one you forked. You can see this by issuing the command: <code>git remote -v</code></p>
<p>Which should result in something like:<code>upstream  git@github.com:ValidateThis/ValidateThis.git (fetch)
upstream  git@github.com:ValidateThis/ValidateThis.git (push)
origin    git://github.com/bobsilverberg/ValidateThis.git (fetch)
origin    git://github.com/bobsilverberg/ValidateThis.git (push)</code></p>
<h3>Add a feature</h3>
<p>OK, so now your local repo is all set up and ready to go. Let's say you want to add a feature to the project. The first step is to create a <em>topic</em> branch for your changes.
A topic branch is not a special type of branch from a technical perspective, it's just a regular Git branch, but I'm going to use that term to refer to a branch that you create
for one specific purpose. It might be to fix a bug or to add a feature. This brings us to our first rule:</p>
<p><strong>Rule #1 - All Changes Should Be Made in a Topic Branch</strong></p>
<p>That's right. Never make changes directly in the <em>develop</em> branch, and never, ever, touch the <em>master</em> branch. 
If you want to add a feature you need to create a new topic branch for your feature. Let's call it <em>newFeature</em> and create it by issuing the command: <code>git checkout -b newFeature</code></p>
<p>Make some code changes and commit often. Don't worry about creating too many commits as you're going to squash them down before merging them back into the <em>develop</em> branch. 
One thing you want to keep on top of, though, is keeping your code up to date with the code in the main repo. If changes happen to code in the main repo you want to get those changes into your topic branch
as soon as possible, to minimize the chances of merge conflicts later. This brings us to the second rule:</p>
<p><strong>Rule #2 - Keep Your Topic Branch Up To Date via <em>git pull --rebase</em></strong></p>
<p>You'll keep your topic branch up to date by pulling any changes from the main repo's <em>develop</em> branch into your topic branch using the following command, 
which you would issue from within your topic branch: <code>git pull --rebase upstream develop</code></p>
<p>This brings your topic branch up to date and avoids adding merge commits via the <em>--rebase</em> option.<sup>1</sup>
<p>This may generate merge conflicts, which you can address at this time. Continue making code changes, committing changes to your branch, and keeping your branch up-to-date until your feature is finished.</p> 
<h3>Merge your changes back into the develop branch</h3>
<p>When your feature is complete, you need to merge the changes back into the <em>develop</em> branch so you can push them to your fork, but first, if you've created a lot of
little commits, you may want to squash them into one commit.</p>
<p><strong>Rule #3 (Optional) - Squash Meaningless Commits in Your Topic Branch via <em>git rebase -i</em></strong></p>
<p>You can do this using <em>git rebase</em> in interactive mode, which is explained below. Note that this is really only necessary if your feature is quite small and does in fact contain a lot of
meaningless commits. If you built your feature up in logical pieces and your commits represent actual functionality then you won't want to squash them, so calling this a <em>rule</em> is a bit of an overstatement, 
which is why it is optional.</p>
<p>Note also that you can continually squash small commits during development of your feature so that you can commit often yet still end up with a smaller number of meaningful commits.
You would do this using the <em>HEAD~n</em> syntax for specifying which commits to include in the rebase. More information on that option can be found in <a href="http://www.silverwareconsulting.com/index.cfm/2010/6/6/Using-Git-Rebase-to-Squash-Commits" target="_blank">a blog post that I wrote about git rebase</a> awhile ago.</p> 
<p>To keep things (relatively) simple we'll assume you want to squash all of the commits in your topic branch before merging it back into your <em>develop</em> branch.
To do this, from within your <em>newFeature</em> branch, issue the following command: <code>git rebase -i develop</code></p>
<p>This will open a git-rebase-todo file the the text editor that Git wants to use (I have mine  
<a href="http://www.silverwareconsulting.com/index.cfm/2010/6/3/Using-TextMate-as-the-Default-Editor-for-Git-on-OS-X" target="_blank">configured to use TextMate</a>), 
with some rebasing instructions. The file will look something like this:</p>
<img src="/images/git-rebase-1.jpg" />
<p>This is quite convenient as git actually provides you with some instructions. In this example we want to combine the second and third commit with the first, so we'll edit the file to look like this:</p>
<img src="/images/git-rebase-2.jpg" />
<p>When we save and close the file, git will pop open another file in the editor to edit our commit message:</p>
<img src="/images/git-rebase-3.jpg" />
<p>From here we can either choose to accept the three individual commit messages that were picked up from our three commits, or we can remove them (or comment them out) 
and provide our own commit message. When we save and close this file we'll be back at the command line with a message similar to this:<code>[detached HEAD 55510e4] added a cool new feature
 1 files changed, 2 insertions(+), 0 deletions(-)
Successfully rebased and updated refs/heads/newFeature.</code></p>
<p>We are now ready to merge our changes back into the <em>develop</em> branch.</p>
<p><strong>Rule #4 - Merge Your Topic Branch Into Develop via <em>git merge --no-ff</em></strong></p>
<p>Switch back to the <em>develop</em> branch and issue the command: <code>git merge newBranch --no-ff</code></p>
<p>The <em>--no-ff</em> option will force a merge commit to be created, which provides an indicator that the changes came from a branch and also provides a point from which things can be rolled back.
At this point you'll need to address any merge conflicts that come up, but there shouldn't be any as you've dealt with any while you were keeping your topic branch up to date with <em>git pull --rebase</em>.
You should make sure your <em>develop</em> branch is still up to date with the main repo by issuing one final <em>git pull --rebase upstream develop</em> command  
and then push your changes to your GitHub fork: <code>git push origin develop</code></p>
<p>You are now ready to inform the project owner(s) that there are changes available via a <em>pull request</em>.</p>
<h3>Create a GitHub pull request</h3>
<p>Go to the main page for your GitHub repo (the fork that you created and to which you just pushed), and click the <em>pull request</em> button, which looks like this:<br />
<img src="/images/github-pull-request-button.jpg" /><br />
You'll see a screen similar to this:<br />
<img src="/images/github-pr-1.jpg" /><br />
This contains a bunch of information about the pull request you are about to create. The first thing to notice is the section near the top of the screen that shows you the <em>to</em> and the <em>from</em>
of the pull request:<br />
<img src="/images/github-pr-2-to-from.jpg" /><br />
Because I was already in my <em>develop</em> branch when I clicked the pull request button, the <em>from</em> is properly populated with the develop branch, however the <em>to</em> defaults to the <em>master</em> branch, so
we need to change that. Click the button labelled "Change Commits" and you should see the following added to the screen:<br />
<img src="/images/github-pr-3-changecommits.jpg" /><br />
You need to replace the word <em>master</em> in the left-hand text box (the one that follows the @ sign) with the word <em>develop</em>, and then click the "Update Commit Range" button. 
This should populate the pull request with only those commits that differ between your <em>develop</em> branch and the <em>develop</em> branch in the main repo. 
After this you should provide a descriptive title and description in the text boxes under the "Preview Discussion" tab:<br />
<img src="/images/github-pr3-desc.jpg" /><br />
and then click the "Send pull request" button.</p>
<p>This will automatically add an issue to the main project repo so that the project owner(s) can be informed. It is then up to them to review your request and apply it to the <em>develop</em> branch in the main repo as they see fit.
As discussed in <a href="http://nvie.com/git-model" target="_blank">Vincent Driessen's post</a>, all work is housed in this <em>develop</em> branch, and the master branch is only used for actual releases, so
it is up to the project owner(s) to merge changes from <em>develop</em> into <em>master</em> when the time comes.</p>
<p>The fine folks at GitHub just introduced this new pull request system which allows contributors and owners to have a discussion about the pull request before changes are applied.
If the owner doesn't like the submission suggestions can be made for changes, and you can change your code, push the changes to your fork, and issue another pull request.</p>
<h3>What's next?</h3>
<p>We plan to make use of this workflow on the ValidateThis project, and it may very well be that we have to make some changes to it. If that happens I'll update this post to reflect those changes.
It is my hope that other projects using Git for collaboration, who don't already have an established workflow, may benefit from this information.</p>
<br /><hr /><br />
<p><sup>1</sup>From what I understand, this approach is somewhat controversial.
When you do a <em>git pull --rebase</em> you're asking git to do a rebase rather than a merge, which has the potential for losing history and creating big problems down the road.
The problem with doing a <em>git pull</em> without the <em>--rebase</em> option is that it seems to create a merge commit every time you do it (and changes are found). These extra merge commits seem
unnecessary to me, as they don't represent actual changes that you've made, they just represent you brining your branch up to date with the main repo.
That's why I don't want them and why I think using <em>git pull --rebase</em> is the way to go. One thing you do have to be careful about, however, is that you must push your changes
to your remote after you merge a branch back into develop (which is discussed towards the end of this post). Otherwise you do risk running into rebase-related issues.
I'm keen to hear feedback from others who disagree with this approach, and anyone who has a better approach as the requirement to rebase does bother me, but I'm
just not sure how else to address the merge commit issue.</p>
