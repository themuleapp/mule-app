# Github Workflow

Really basic Github workflow. A lot speaks for itself, but please, still, read thoroughly.

### Boards and Automation

Boards can have automation in it. Our boards differ slightly to the default, this can be changed at any point.
Issues and merge requests will be automatically added to one of the board columns if they meet certain cirteria.

> To do: When an issue is opened it's automatically added here (can of also be made from a node within the board itself)
> In Progress: When a pull request is newly opened it gets added here
> Testing: When a pull request awaits review, it's moved here
> Done: Merged pull requests are added here, so too are closed issues

Every column in every board can be edited by clicking on the three dots in the top right corner and then `managing automation`.

### Issues and Pull requests

This is a typical github workflow:

1. Start working on one (or more) issue(s) locally
2. Commit changes, and mention the issue(s) worked on
3. Push changes to remote in new branch
4. As soon as you push to a new branch Github will give you the option to make a pull request 
5. When creating the pull request, mention all the issues you're working on using *[keywords*](https://help.github.com/en/github/managing-your-work-on-github/linking-a-pull-request-to-an-issue) and set the project this request belongs by clicking **Projects** on the right of the pull request description
6. This can either be done in the commit messages, or the pull request description
7. Finalize by clicking the arrow next to create issue to create a **Draft** request.

> Mentioning the issues will link them to the pull request. This ensures the project board will always be up to date

8. When the pull request is ready for reviewing/testing, remove the draft property and mention all the people authorized to review your work.

> This will automatically move the pull request to the `Testing` column in the project board

9. After review, merge and close

### Motivation

This might seem like a lot of unessecary work, but as soon as a lot of issues start to pile up, and more people start working on them, 
making sure the project boards are up to date, and having to mention everyone on Slack to test something becomes a realy chore. 

> A simple way of not having to create a million pull requests, is to collect similar issues and put them in the same request.

### Notes on mergin and automation

As you might notice, your issues won't close immeadiatly (and thus also won't be added to the `Done` column).
This is because the linked issues will only be closed when merging with the default branch. In most cases `master`.
As soon as dev is merged with `master` all issues will be closed.
Pull requests, however, should be automatically moved to `Done` when closed.

