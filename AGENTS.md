# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This project demonstrates the **OpenAgents Control (OAC)** framework — a plan-first, approval-gated agentic development workflow built on top of OpenCode. It includes a minimal FastAPI application as the reference implementation.

## Commands

```bash
# Run the FastAPI application
uvicorn main:app --reload

# Install dependencies (uses uv)
uv sync

# Add a package
uv add <package>

# Lint code
uv run ruff check .
uv run ruff format .
```

No test command is explicitly defined; the CI pipeline auto-detects pytest if present.

## Architecture

### OAC Workflow (Two-Phase Plan → Code)

All development flows through GitHub issues:

1. Comment `/oc` on an issue tagged `oc-ready`
2. `issue-intake.yml` validates the commenter is authorized, then triggers `oc-dispatch.yml` in **plan** mode
3. OpenAgent creates `docs/execution-plan-issue-{N}.md` and opens a PR with `oc-plan` label
4. `pr-guardrails.yml` enforces the PR contains only docs changes and the plan file has `stage: in_review`
5. After the plan PR is merged, `plan-merge-kickoff.yml` auto-triggers `oc-dispatch.yml` in **kickoff** mode
6. OpenCoder reads the plan and opens a code PR with `oc-code` label
7. `pr-guardrails.yml` runs tests on the code PR
8. After merge, the plan file's stage is automatically updated to `done`

### GitHub Workflows

| File | Purpose |
|------|---------|
| `issue-intake.yml` | Entry point — validates `/oc` commands on issues |
| `oc-dispatch.yml` | Reusable orchestration — runs OpenCode agent in plan or kickoff mode |
| `plan-merge-kickoff.yml` | Triggers implementation after a plan PR merges |
| `pr-guardrails.yml` | Enforces plan-only and code PR rules; auto-updates plan stage |

### Agent System (`.opencode/agent/`)

- **OpenAgent** (`core/openagent.md`) — planning and coordination; uses `ContextScout` for discovery and requires approval before any write/edit/bash action
- **OpenCoder** (`core/opencoder.md`) — implementation; incremental execution, one step at a time, stops on test failures
- **Subagents** — ContextScout, ExternalScout, TaskManager, DocWriter, TestEngineer, CoderAgent, BatchExecutor

### Context Files (`.opencode/context/`)

Agents load project standards from these directories before executing:

- `core/` — code quality, documentation, test coverage standards
- `development/` — backend/frontend/fullstack patterns
- `project-intelligence/` — technical domain, business domain, architectural decisions
- `ui/` — UI/animation/design patterns

### Application (`main.py`)

Minimal FastAPI demo with two endpoints:

- `GET /health` — system health check
- `GET /cow?text=...` — cowsay ASCII art output

### Skills (`.claude/skills/`, `.opencode/skills/`)

Pre-loaded skills symlinked from external repos: `git-commit`, `git-branch-pr-workflow`, `conventional-commit`, `fastapi-expert`, `python-expert`, `uv-package-manager`, `find-skills`.

## Key Constraints

- Execution plans live in `docs/execution-plan-issue-{N}.md` and must include `stage: in_review` before merging
- Plan PRs must be docs-only (no source code changes)
- The `oc-dispatch.yml` workflow runs on a **self-hosted runner** tagged `oc-runner` and requires `opencode` CLI to be installed
- Environment variables for OpenCode agents are defined in `.opencode/env.example` (Telegram, Gemini, MiniMax keys)
