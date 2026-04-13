# AGENTS.md

## OpenAgentControl (OAC) Procedure

Use Github issue as command center

### 1. Persist plan and provide Pull Request for user review

Change approval step to Pull Request let developers to review the plan. Steps to create Pull Request are,

1. create branch using `git-branch-pr-workflow` skill
2. Generate a full plan and save to `./plans` with github Issue number as reference
3. Add the plan in git, then commit and push to remote
4. Create PR based on the commit

### 2 Execute the plan

1. Pick up the plan related to the issue using Issue number as file reference
2. Create `feat`, `bugfix`, `refactor` or `security` where are appropriate
3. Add the plan in git, then commit and push to remote
4. Create PR based on the commit
