Tips:
1 a) Immediately after cloning or creating a repository in Visual 
     Studio, go to the menu option "View" > "Team Explorer" (Note: If 
     you have already created a branch other than "master", then make 
     sure you are pointing to the "master" branch before continuing). 
1 b) If not already on the "Home" page of the "Team Explorer" tab, 
     click on the "Home" icon. 
1 c) In the "Project" section click on the "Settings" option. 
1 d) In the "Git" section click on the "Repository Settings" link. 
1 e) In the "Ignore & Attributes Files" section, click on the "Add" 
     link to the right of "Ignore File". 
1 f) To the right of "/.gitignore", click on the "Edit" link. 
1 g) Within the .gitignore file, make sure the entry ".vs/" is not 
     commented out (does not have a # sign at the beginning of the 
     line). 
1 h) You might also want to add the following entries, although they 
     should not be needed with the ".vs/" entry: 
    slnx.sqlite  
    VSWorkspaceState.json  
1 i) Save the ".gitignore" file. 
1 j) On the "Team Explorer" tab, click on the "Home" icon. 
1 k) Click on the "Changes" option. 
1 l) Enter a required "commit message" of "add visual studio file 
     exclusions" 
1 m) Click on the "Commit Staged" or "Commit All" button (whichever 
     one is displayed). 
1 n) Click the "Sync" link to prepare an Outgoing Commit (seems weird?). 
1 o) In the "Outgoing Commits(1)" section, click on the "Push" link to 
     push the changes to github.com. Wait for the confirmation. 
1 p) Verify the change on github.com. 
  
Glossary: 
 (see also https://help.github.com/en/github/getting-started-with-github/github-glossary)  
- Abandoned: 
- Active: 
- Actions: GitHub Actions enables you to create custom software development life cycle (SDLC) workflows directly in your GitHub repository. Actions are individual tasks that you can combine to create jobs and customize your workflow. You can create your own actions, and use and customize actions shared by the GitHub community.  
- Assigned: 
- Attributes File (.gitattributes): 
- Base Branch: e.g.; "master", "Ver2.0 Features"  
- Blame: The "blame" feature in Git describes the last modification to each line of a file, which generally displays the revision, author and time. This is helpful, for example, in tracking down when a feature was added, or which commit led to a particular bug.  
- Branch: A branch is a parallel version of a repository. It is contained within the repository, but does not affect the primary or master branch allowing you to work freely without disrupting the "live" version. When you've made the changes you want to make, you can merge your branch back into the master branch to publish your changes. For more information, see "About branches."  
- Building Actions: 
- Checkout branch: 
- Checkout pull request: 
- Changes: 
- CD: Continuous Deployment  
- CI: Continuous Integration  
- Clone: A clone is a copy of a repository that lives on your computer instead of on a website's server somewhere, or the act of making that copy. With your clone you can edit the files in your preferred editor and use Git to keep track of your changes without having to be online. It is, however, connected to the remote version so that changes can be synced between the two. You can push your local changes to the remote to keep them synced when you're online.  
- Colaborator: A collaborator is a person with read and write access to a repository who has been invited to contribute by the repository owner.  
- Comment: 
- Completed: 
- Commit: A commit, or "revision", is an individual change to a file (or set of files). It's like when you save a file, except with Git, every time you save it creates a unique ID (a.k.a. the "SHA" or "hash") that allows you to keep track of what changes were made when and by who. Commits usually contain a commit message which is a brief description of what changes were made.  
- Connect: 
- Containers on GitHub-hosted machines: 
- Contributor: A contributor is someone who has contributed to a project by having a pull request merged but does not have collaborator access.  
- Diff: A diff is the difference in changes between two commits, or saved changes. The diff will visually describe what was added or removed from a file since its last commit.  
- Docker Container Image: 
- Drop: 
- Fetch: Fetching refers to getting the latest changes from an online repository without merging them in. Once these changes are fetched you can compare them to your local branches (the code residing on your local machine).  
- Force: 
- Fork: A fork is a personal copy of another user's repository that lives on your account. Forks allow you to freely make changes to a project without affecting the original. Forks remain attached to the original, allowing you to submit a pull request to the original's author to update with your changes. You can also keep your fork up to date by pulling in updates from the original.  
- .gitattributes (Attributes File): 
- .gitignore (Ignore File): Example entry: ".vs\" ignores visual studio temp files 
- gists: 
- Git: Git is an open source program for tracking changes in text files, and is the core technology that GitHub, the social and user interface, is built on top of. 
- GitHub: github.com 
- Head Branch: The branch furthest away from master. e.g.; "2020-01-29-Bug Fix", "2020-01-29-Feature-1" 
- Ignore File (.gitignore): 
- Issues: Issues are suggested improvements, tasks or questions related to the repository. Issues can be created by anyone (for public repositories), and are moderated by repository collaborators. Each issue contains its own discussion forum, can be labeled and assigned to a user.  
- Keep: 
- Local branch: the code residing on your local machine.  
- Manage Connections: 
- master: The primary branch on the original repository. The main place that other changes are merged into. Also referred to as the "upstream". The branch/fork you are working on is then called the "downstream". 
- Merge: Merging takes the changes from one branch (in the same repository or from a fork), and applies them into another. This often happens as a pull request (which can be thought of as a request to merge), or via the command line. A merge can be done automatically via a pull request via the GitHub web interface if there are no conflicting changes, or can always be done via the command line. For more information, see "Merging a pull request."  
- Merge Commits: Add all commits from the head branch to the base branch with a merge commit. 
- Merge Conflicts: 
- Non-Fast-Forward Errors: 
- origin: "remotes/origin" usually refers to the branches (master and others) on github.com. In Git, "origin" is a shorthand name for the remote repository that a project was originally cloned from. More precisely, it is used instead of that original repository's URL (because "origin" is shorter than the full URL of the respository) 
- Portable: 
- Projects: 
- Prune: The git prune command is an internal housekeeping utility that deletes lost or "orphaned" Git objects. Unreachable objects are those that are inaccessible by any refs. Any commit that cannot be accessed through a branch or tag is considered unreachable or not present. 
- Pull: Pull refers to when you are fetching in changes and merging them. For instance, if someone has edited the remote file you're both working on, you'll want to pull in those changes to your local copy so that it's up to date.  
- Pull Request: Pull requests let you tell others about changes you've pushed to a branch in a repository on GitHub. Once a pull request is opened, you can discuss and review the potential changes with collaborators and add follow-up commits before your changes are merged into the base branch. Pull requests are proposed changes to a repository submitted by a user and accepted or rejected by a repository's collaborators. Like issues, pull requests each have their own discussion forum. For more information, see "About pull requests."  
- Pulse: 
- Push: Pushing refers to sending your committed changes to a remote repository, such as a repository hosted on GitHub. For instance, if you change something locally, you'd want to then push those changes so that others may access them. 
- Rebase: In Git, the rebase command integrates changes from one branch into another. It is an alternative to the better known "merge" command. Most visibly, rebase differs from merge by rewriting the commit history in order to produce a straight, linear succession of commits. 
- Rebase Merging: Add all commits from the head branch onto the base branch individually. vs Squash Merging 
- Refresh: 
- Remote (Repositories): This is the version of something that is hosted on a server, most likely GitHub. It can be connected to local clones so that changes can be synced.  
- remotes: 
- Repository: A repository is the most basic element of GitHub. They're easiest to imagine as a project's folder. A repository contains all of the project files (including documentation), and stores each file's revision history. Repositories can have multiple collaborators and can be either public or private.  
- Runners: 
- Settings: 
- Squash Merging: Combine all commits from the head branch into a single commit in the base branch. vs Rebase Merging 
- Split: 
- Stage: 
- Staged: 
- Stale: 
- Stash: Git stash temporarily shelves (or stashes) changes you've made to your working copy so you can work on something else, and then come back and re-apply them later on. Use git stash when you want to record the current state of the working directory and the index, but want to go back to a clean working directory. The command saves your local modifications away and reverts the working directory to match the HEAD commit. 
- Stashed: 
- Sync: 
- Tags: 
- Topic Branch: 
- Unify: 
- Unset: Remove the line matching the key from config file. Example: "git config --unset diff.renames", deletes "renames=true" in the "[diff]" section of .git/config file. See also https://git-scm.com/docs/git-config/2.1.4 
- Workflow: 
- Work Item: Same as an Issue? 
  
Helpful guides and documents: 
https://www.azuredevopslabs.com/labs/devopsserver/github/  
https://www.azuredevopslabs.com/labs/devopsserver/git/ 
https://help.github.com/en/github/using-git 
 
Perform the github-slideshow tutorial, with the following steps: 
1) Create a github.com account with [make up a github username] 
2) While on github.com, clone github-slideshow to your github account 
3) Install VS-2019 or VS-Code 
4) Within VS-2019, clone your github.com copy of github-slideshow to your local machine into 
   c:\users\[pc/mac/whatever username]\source\repos\[github username]\github-slideshow  
5) Within VS-2019, create a branch from master called my-slide 
6) Within VS-2019, "push" the my-slide branch declaration to your github.com copy of 
   github-slideshow 
7) Within VS-2019, add a new file called "0000-01-02-[github username].md" to your local 
  my-slide branch. 
8) Within VS-2019, commit the change to the local github-slideshow repos. 
   This is the equivalent of "add a new file to version control database at the my-slide branch",  
   and this is the file's first history entry in the local github-slideshow repos. This file is 
   still not in your local master branch of the github-slideshow repos and certainly is not yet 
   on ithub.com.  
9) Within VS-2019, create a pull request. This creates the pull request locally (and on the 
   server!) to ask if the new file can be merged from your local "my-slide" branch to your 
   local (and server!) master branch 
10) On github.com, merge the pull request (note: I also did a lot of stuff in VS-2019: 
    Edited a file, commited the file, pushed, pulled, resolved conflicts, committed, 
    merged; and not necessarily in that order. It was very messy)  
11) On github.com, confirm merge  
12) On github.com, delete my-slide branch 
    
Let's recap the git commands:  
2) Clone on server  
4) Clone on local  
5) Branch on local  
6) Push branch to server  
8) Commit new file to local 
9) Pull request to merge-to-master on local (and server!) 
10) Merge pull request on server 
11) Confirm merge on server 
12) Delete branch my-slide on server 
 
Another way to look at it: 
1) Create a branch from the repository.  
2) Create, edit, rename, move, or delete files.  
3) Send a pull request from your branch with your proposed changes to kick off a discussion.  
4) Make changes on your branch as needed. Your pull request will update automatically.  
5) Merge the pull request once the branch is ready to be merged.  
6) Tidy up your branches using the delete button in the pull request or on the branches page.  

