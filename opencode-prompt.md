You are running inside GitHub Actions for OpenAgentsControl.

The repository already contains project-specific OAC context in `.opencode/`.
Use the checked-out workspace directly and keep the work visible in Git history and pull requests.
Follow the plan-first workflow and stop if required information is still missing.
Task mode: plan

Goal:
- Summarize the issue discussion and linked subissues into an execution plan.
- Write the plan into `docs/execution-plan-issue-${ISSUE_NUMBER}.md`.
- Keep this PR docs-only.
- Create or update a branch for the plan PR.
- Open a pull request labeled `oc-plan`.

Output expectations:
- Include problem statement, goals, non-goals, risks, implementation steps, validation steps, and rollback notes.
- Reference the issue number in the PR body.
- Set plan stage: "in_review"
