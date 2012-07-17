A Git Workflow for Open Source Collaboration - Part I - Introduction

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
<p>I am going to describe this workflow in detail through a series of posts on my blog, this post being the first installment. The series will likely contain the following posts:
<ul>
	<li>Introduction</li>
	<li>Setting Up Your Local Environment</li>
	<li>Developing Code</li>
	<li>Submitting Code to the Project</li>
</ul></p>
<h3>Credit Where Credit is Due</h3>
<p>The overall workflow that I'll be describing is based on one published by <a href="http://nvie.com/about" target="_blank">Vincent Driessen</a> on 
<a href="http://nvie.com/" target="_blank">his blog</a> in a post titled <a href="http://nvie.com/git-model" target="_blank"><em>A successful Git branching model</em></a>.
I read a number of other excellent posts about Git workflows as I was researching this, so if you'd like to educate yourself before going further here are some links:
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
<h3>This Workflow is Based on Vincent Driessen's Workflow</h3>
<p>Even if you choose not to read any of the posts that I've listed above, I'm afraid you're going to have to read through <a href="http://nvie.com/git-model" target="_blank">Vincent Driessen's post</a>
as it forms the basis of this workflow. I don't think it would be fair for me to simply repeat all of the information from Vincent's blog, so the remainder of this
series is going to assume you're familiar with Vincent's workflow.</p>
<h3>This Workflow Uses GitHub</h3>
<p>There is no reason why you have to use <a href="http://github.com/" target="_blank">GitHub</a> for your remotes when implementing a similar workflow but, because I <em>am</em> using GitHub, the instructions 
that I describe will use terms and screen caps from GitHub, and will be based on some of GitHub's features, including the brand spanking 
new <a href="http://github.com/blog/712-pull-requests-2-0" target="_blank">pull request system</a>.</p>
<h3>What's Next?</h3>
<p>Part II in the series will describe how to set up your local environment to participate in the workflow. It will cover topics including:
<ul>
	<li>Forking an existing GitHub repo</li>
	<li>Cloning a repo to your machine</li>
	<li>Setting up a tracking branch</li>
	<li>Adding a remote for the main project repo</li>
</ul></p>
