# Plan for Issue #1: Create FastAPI for sample project

## Task
Create REST API using Python FastAPI framework with the following endpoints:
- `/health` - returns system status (mock value first)
- `/cow` - returns text based on how a cow says, using `cowsay` library with query param

## Tech Stack
- FastAPI for REST API
- UV for package management
- Ruff for linting

## Steps

### 1. Initialize project with UV
- Set up Python project using UV
- Add dependencies: fastapi, uvicorn, cowsay

### 2. Create FastAPI application
- Create main.py with FastAPI app
- Implement `/health` endpoint returning mock health status
- Implement `/cow` endpoint with query parameter using cowsay library

### 3. Lint and format
- Run ruff to ensure code quality

### 4. Create branch and commit
- Create feature branch following git-branch-pr-workflow
- Commit changes using conventional commit

### 5. Create PR
- Create pull request for user review