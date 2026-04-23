#!/bin/bash
set -euo pipefail
prompt_file="opencode-prompt.md"
MODE="${1:-plan}" # default to "plan" mode if not specified
cat <<-'EOF' > "$prompt_file"
You are running inside GitHub Actions for OpenAgentsControl.

The repository already contains project-specific OAC context in `.opencode/`.
Use the checked-out workspace directly and keep the work visible in Git history and pull requests.
Follow the plan-first workflow and stop if required information is still missing.
EOF

if [ "$MODE" = "plan" ]; then
cat <<-'EOF' >> "$prompt_file"
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
EOF
else
cat <<-'EOF' >> "$prompt_file"
Task mode: kickoff

Goal:
- Read the merged execution plan related to the issue number and implement the code changes it describes.
- Keep the implementation aligned with the approved plan.
- Run the appropriate project tests and validation commands.
- Create or update a branch for the code change PR.
- Open a pull request labeled `oc-code`.

Output expectations:
- Keep the code PR focused on implementation only.
- Reference the merged plan PR and the source issue in the PR body.
- After code PR merges to main: Update the plan file (docs/execution-plan-issue-${ISSUE_NUMBER}.md) to set stage: "done" using a commit to main.
EOF
fi

{
printf 'Plan file: %s\n' "$PLAN_FILE"
printf '\nRepository: %s\n' "$REPOSITORY"
printf 'Correlation key: %s\n' "$CORRELATION_KEY"
printf 'Issue number: %s\n' "$ISSUE_NUMBER"
printf 'Issue URL: %s\n' "$ISSUE_URL"
printf 'Issue title: %s\n' "$ISSUE_TITLE"
printf 'Commenter: %s\n' "$COMMENTER"
printf 'Comment body:\n%s\n' "$COMMENT_BODY"
printf 'Issue discussion thread:\n%s\n' "$ISSUE_COMMENTS"
printf 'Plan PR number: %s\n' "$PR_NUMBER"
printf 'Plan PR URL: %s\n' "$PR_URL"
printf 'Plan PR title: %s\n' "$PR_TITLE"
printf 'Plan PR body:\n%s\n' "$PR_BODY"
} >> "$prompt_file"

echo "prompt_file=$prompt_file"
