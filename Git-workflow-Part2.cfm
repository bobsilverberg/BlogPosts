A Git Workflow for Open Source Collaboration - Part II - Getting Started

In this installment in my <a href="http://www.silverwareconsulting.com/index.cfm/Git-Workflow">series describing a Git workflow for open source collaboration</a> we'll look at the steps to get your local development
environment ready to participate in the workflow.</p>
<h3>Get Git and a GitHub Account</h3>
<p>In order to make use of this workflow as described you'll need to have Git installed on your machine, you'll need a <a href="http://github.com/" target="_blank">GitHub</a> account,
and you'll need to configure your
machine to talk to GitHub. I wrote a <a href="http://www.silverwareconsulting.com/index.cfm/2009/10/26/Setting-up-a-Mac-to-Work-with-Git-and-GitHub">blog post covering those topics</a>, for folks on OS X,
awhile back.
If you are on another OS there are plenty of resources available.</p>
<h3>Create a Fork</h3>
<p>This post assumes that you're starting from scratch, so the first thing you'll need to do is create a fork of the main project repo on GitHub.</p> 
<p>For the purposes of this post I'll be using the repo for ValidateThis, so go to the main GitHub repo for ValidateThis, which is located at
<a href="http://github.com/ValidateThis/ValidateThis" target="_blank">http://github.com/ValidateThis/ValidateThis</a>. Click the 
fork button which you'll see near the upper right-hand corner of the screen:<br />
<img src="/images/github-fork-button.jpg" /><br />
You'll see a message similar to this, telling you that GitHub is creating a fork of the repo for you:<br /><br />
<img src="/images/github-forking.jpg" /><br /><br />
Once the fork has been created you'll be taken to the repo page for your fork of the ValidateThis repo.</p>
<h3>Why Fork?</h3>
<p>When you create a fork you create a copy of the entire Git repo that you own. 
This allows you to push changes to your fork without having to worry about getting write access to the main project repo.
A similar workflow to this could be devised without using forks, if all of the contributors were to be given write access to the main repo. 
At this stage in the life of the ValidateThis project I prefer to receive contributions in the form of pull requests which
I can vet and examine, and possibly change, before they are merged into the main repo, which is why we have chosen to use forks.</p>
<h3>Clone the Fork to Your Machine</h3>
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
<p>This tells you that your local repo has one branch, called <em>master</em>, and the asterisk tells you that the <em>master</em> branch is the current branch. 
But wait a minute, if you read the <a href="http://nvie.com/git-model" target="_blank">post by Vincent Driessen</a> 
(like you were supposed to), you'd know that any changes that you make while developing should be committed to the <em>develop</em> branch, not the
<em>master</em> branch, so where is the develop branch?</p>
<h3>Create a Develop Tracking Branch</h3>
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
<h3>Add a Remote for the Main Project Repo</h3>
<p>The main repo is not your fork, it's the repo that you originally forked, the one located at http://github.com/ValidateThis/ValidateThis.
In order to be able to pull changes from this repo you need to add it as a remote, which you can do by issuing this command: <code>git remote add upstream git://github.com/ValidateThis/ValidateThis.git</code></p>
<p>The word <em>upstream</em> in that command is the name that you are giving to this remote, and the url at the end is the <em>read-only</em> url that you'll find on the main repo page. 
This command will add a remote named <em>upstream</em>, pointing at the main project repo, so you now have two remotes added to your repo: <em>origin</em>, which is your fork on GitHub, and
<em>upstream</em>, which is the main project repo on GitHub - the one you forked. You can see this by issuing the command: <code>git remote -v</code></p>
<p>Which should result in something like:<code>upstream  git@github.com:ValidateThis/ValidateThis.git (fetch)
upstream  git@github.com:ValidateThis/ValidateThis.git (push)
origin    git://github.com/bobsilverberg/ValidateThis.git (fetch)
origin    git://github.com/bobsilverberg/ValidateThis.git (push)</code></p>
<h3>What's Next?</h3>
<p>Part III in the series will describe the workflow for developing code to be contributed back to the project (e.g., bug fixes, new features, etc.). 
It will cover topics including:
<ul>
	<li>Creating a topic branch</li>
	<li>Keeping your topic branch up to date</li>
	<li>Squashing commits</li>
	<li>Merging your changes back into the <em>develop</em> branch</li>
</ul></p>
