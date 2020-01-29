Tips:
1) #1 Tip! After cloning or creating a repository in Visual Studio, 
  immediately go to the menu option "View" > "Team Explorer". If not
  already on the "Home" page of the "Team Explorer" tab, click the
  "Home" icon. In the "Project" section click on the "Settings" option.
  In the "Git" section click on the "Repository Settings" link. In the 
  "Ignore & Attributes Files" section, click the "Add" link to the right
  of "Ignore File". To the right of "/.gitignore", click the "Edit" link.
  Within the .gitignore file, make sure the entry ".vs/" is not commented
  out (does not have a # sign at the beginning of the line). You might
  also want to add the following entries, although they should not be
  needed:
    slnx.sqlite
    VSWorkspaceState.json
  Save the ".gitignore" file. On the "Team Explorer" tab, click the "Home"
  icon. Click on the "Changes" option. Enter a required "commit message"
  of "add visual studio file exclusions" Click on "Commit Staged" or
  "Commit All" button (whichever one is displayed). Click the "Sync" link
  to prepare an Outgoing Commit (seems weird?).
  In the "Outgoing Commits(1) section, click the "Push" link to push the
  changes to github.com. Wait for confirmation. End of #1 Tip.


Outstanding questions:
1) Difference between fork and branch


Glossary: 
- Abandoned: 
- Active: 
- Actions: 
- Assigned: 
- Attributes File (.gitattributes): 
- Base Branch: e.g.; "master", "Ver2.0 Features"
- Blame: 
- Branch: 
- Checkout branch: 
- Checkout pull request: 
- Changes: 
- Clone: 
- Colaborator: 
- Comment: 
- Completed:
- Commit: 
- Connect: 
- Contributor: 
- Drop: 
- Fetch: 
- Force: 
- Fork: 
- .gitattributes (Attributes File): 
- .gitignore (Ignore File): Example entry: ".vs\" ignores visual studio temp files
- gists: 
- Git: 
- GitHub: 
- Head: 
- Head Branch: e.g.; "2020-01-29-Bug Fix", "2020-01-29-Feature-1" 
- Ignore File (.gitignore): 
- Issues: 
- Keep: 
- Local: 
- Manage Connections:
- master: 
- Merge: 
- Merge Commits: Add all commits from the head branch to the base branch with a merge commit.
- origin: 
- Portable: 
- Projects: 
- Prune: 
- Pull: 
- Pull Request:
- Pulse:
- Push: 
- Rebase: 
- Rebase Merging: Add all commits from the head branch onto the base branch individually. vs Squash Merging
- Refresh: 
- Remote: 
- remotes: 
- Settings: 
- Squash: 
- Squash Merging: Combine all commits from the head branch into a single commit in the base branch. vs Rebase Merging
- Split 
- Stage: 
- Staged: 
- Stale: 
- Stash: 
- Stashed: 
- Sync: 
- Tags: 
- Unify: 
- Unset: 
- Work Item: Same as an Issue?



Helpful guides:
https://www.azuredevopslabs.com/labs/devopsserver/github/  
https://www.azuredevopslabs.com/labs/devopsserver/git/

Perform the github-slideshow tutorial, with the following steps:
1) Create github.com account billybobbobrownjr
2) While on github.com, clone github-slideshow to my billybobbobrownjr github account 
3) Install VS-2019 or VS-Code
4) Within VS-2019, clone my github.com copy of github-slideshow to my local machine into c:\users\bcotton\source\repos\billybobbobrownjr\github-slideshow
5) Within VS-2019, create a branch from master called my-slide
6) Within VS-2019, "push" the my-slide branch declaration to my github.com copy of github-slideshow
7) Within VS-2019, add a new file (slide) called 0000-01-02-billybobbobrownjr.md to the local my-slide branch.
8) Within VS-2019, commit the change to the local github-slideshow repos. 
   I believe this is the equivalent of "add new file to version control database at the my-slide branch" and is the
   file's first history entry in the local github-slideshow repos. This file is still not in the local master branch
   of the github-slideshow repos and also is not yet on github.com.  
9) Within VS-2019, create pull request (This creates the pull request locally and on the server) to ask if new file can be merged from local my-slide branch to local (and server!) master branch  
10) On github.com, merge pull request (note:I also did a lot of stuff in VS-2019: Edited a file, commited the file, pushed, pulled, resolved conflicts, committed, merged; and not necessarily in that order. It was very messy)  
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

