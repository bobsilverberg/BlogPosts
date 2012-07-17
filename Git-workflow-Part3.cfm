A Git Workflow for Open Source Collaboration - Part III - Developing Code

In this installment in my <a href="http://www.silverwareconsulting.com/index.cfm/Git-Workflow">series describing a Git workflow for open source collaboration</a> 
we'll look at the workflow for developing code to be contributed back to the project (e.g., bug fixes, new features, etc.).</p>
<h3>Add a Feature</h3>
<p>After reading parts I and II your local repo is all <a href="http://www.silverwareconsulting.com/index.cfm/2010/9/15/A-Git-Workflow-for-Open-Source-Collaboration--Part-II--Getting-Started">set up and ready to go</a>. 
Let's say you want to add a feature to the project. The first step is to create a <em>topic</em> branch for your changes.
A topic branch is not a special type of branch from a technical perspective, it's just a regular Git branch, but I'm going to use that term to refer to a branch that you create
for one specific purpose. It might be to fix a bug or to add a feature. This brings us to our first rule:</p>
<p><strong>Rule #1 - All Changes Should Be Made in a Topic Branch</strong></p>
<p>That's right. Never make changes directly in the <em>develop</em> branch, and never, ever, touch the <em>master</em> branch. 
If you want to add a feature you need to create a new topic branch for your feature. Let's call it <em>newFeature</em> and create it 
by issuing the command from within the <em>develop</em> branch: <code>git checkout -b newFeature</code></p>
<p>You'll recall from the previous post that the <em>-b</em> option tells Git to create a new branch.
Make some code changes and commit often. Don't worry about creating too many commits as you're going to squash them down before merging them back into the <em>develop</em> branch. 
One thing you want to keep on top of, though, is keeping your code up to date with the code in the main repo. If changes happen to code in the main repo you want to get those changes into your topic branch
as soon as possible, to minimize the chances of merge conflicts later. This brings us to the second rule:</p>
<p><strong>Rule #2 - Keep Your Topic Branch Up To Date via <em>git pull --rebase</em></strong></p>
<p>You'll keep your topic branch up to date by pulling any changes from the main repo's <em>develop</em> branch into your topic branch using the following command, 
which you would issue from within your topic branch: <code>git pull --rebase upstream develop</code></p>
<p>This brings your topic branch up to date and avoids adding merge commits via the <em>--rebase</em> option.
It may generate merge conflicts, which you can address at this time. Continue making code changes, committing changes to your branch, and keeping your branch up-to-date until your feature is finished.</p> 
<h3>Merge Your Changes Back into the Develop Branch</h3>
<p>When your feature is complete, you need to merge the changes back into the <em>develop</em> branch so you can push them to your fork, but first, if you've created a lot of
little commits, you may want to squash them into one commit.</p>
<p><strong>Rule #3 (Optional) - Squash Meaningless Commits in Your Topic Branch via <em>git rebase -i</em></strong></p>
<p>You can do this using <em>git rebase</em> in interactive mode, which is explained below. Note that this is really only necessary if your feature is quite small and does in fact contain a lot of
meaningless commits. If you built your feature up in logical pieces and your commits represent actual functionality then you won't want to squash them, so calling this a <em>rule</em> is a bit of an overstatement, 
which is why it is optional.</p>
<p>Note also that you can continually squash small commits during development of your feature so that you can commit often yet still end up with a smaller number of meaningful commits.
You would do this using the <em>HEAD~n</em> syntax for specifying which commits to include in the rebase. 
More information on that option can be found in <a href="http://www.silverwareconsulting.com/index.cfm/2010/6/6/Using-Git-Rebase-to-Squash-Commits" target="_blank">a blog post that I wrote about git rebase</a> awhile ago.</p> 
<p>To keep things (relatively) simple we'll assume you want to squash all of the commits in your topic branch before merging it back into your <em>develop</em> branch.
To do this, from within your <em>newFeature</em> branch, issue the following command: <code>git rebase -i develop</code></p>
<p>This tells Git that you want to rebase all of the commits that exist in the current <em>newFeature</em> branch and do not exist in the <em>develop</em> branch.
A git-rebase-todo file will open in the the text editor that Git wants to use (I have mine  
<a href="http://www.silverwareconsulting.com/index.cfm/2010/6/3/Using-TextMate-as-the-Default-Editor-for-Git-on-OS-X" target="_blank">configured to use TextMate</a>), 
with some rebasing instructions. The file will look something like this:</p>
<img src="/images/git-rebase-1.jpg" />
<p>This is quite convenient as git actually provides you with some instructions. In this example we want to combine the second and third commit with the first, so we'll edit the file to look like this:</p>
<img src="/images/git-rebase-2.jpg" />
<p>Note that you can just use the letter "s" in place of the whole word "squash" when editing the file.
When you save and close the file, git will pop open another file in the editor to edit your commit message:</p>
<img src="/images/git-rebase-3.jpg" />
<p>From here you can choose to accept the three individual commit messages that were picked up from the three commits, or you can remove them (or comment them out) 
and provide our own commit message(s). When you save and close this file you'll be back at the command line with a message similar to this:<code>[detached HEAD 55510e4] added a cool new feature
 1 files changed, 2 insertions(+), 0 deletions(-)
Successfully rebased and updated refs/heads/newFeature.</code></p>
<p>You are now ready to merge your changes back into the <em>develop</em> branch.</p>
<p><strong>Rule #4 - Merge Your Topic Branch Into Develop via <em>git merge --no-ff</em></strong></p>
<p>Switch back to the <em>develop</em> branch and issue the command: <code>git merge newBranch --no-ff</code></p>
<p>The <em>--no-ff</em> option will force a merge commit to be created, which provides an indicator that the changes came from a branch and also provides a point from which things can be rolled back.
At this point you'll need to address any merge conflicts that come up, but there shouldn't be any as you've dealt with any while you were keeping your topic branch up to date with <em>git pull --rebase</em>.
You should make sure your <em>develop</em> branch is still up to date with the main repo by issuing one final <em>git pull --rebase upstream develop</em> command  
and then push your changes to your GitHub fork: <code>git push origin develop</code></p>
<h3>What's Next?</h3>
<p>Part IV in the series will describe submitting your changes to the project as a contribution, using GitHub's pull request system.</p>
