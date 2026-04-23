---
stage: in_review
issue: 9
author: pradit-ra
created: 2026-04-23
---

# Execution Plan: Todo App REST API

## Problem Statement

The user wants a new RESTful API service for a todo application. The service should provide endpoints to manage todo items (create, read, update, delete) with data persisted in SQLite.

## Goals

1. Implement REST API endpoints for todo management:
   - `GET /todos` - Retrieve all todo items
   - `POST /todos` - Create a new todo item
   - `PUT /todos/{id}` - Mark a todo as completed
   - `DELETE /todos/{id}` - Delete a todo item

2. Persist data in SQLite database

3. Follow existing project conventions (FastAPI, async patterns)

## Non-Goals

- User authentication/authorization
- Web UI or frontend
- Advanced features (categories, tags, due dates)
- Deployment/infrastructure automation

## Implementation Steps

### 1. Database Setup
- Configure SQLite database connection using async SQLAlchemy
- Create Todo model with fields: id, title, completed, created_at

### 2. Schemas (Pydantic V2)
- `TodoCreate` - schema for POST request body (title required)
- `TodoUpdate` - schema for PUT request (completed boolean)
- `TodoResponse` - schema for API responses

### 3. CRUD Operations
- `create_todo(db, title)` - Insert new todo
- `get_todos(db)` - List all todos
- `get_todo_by_id(db, id)` - Get single todo
- `update_todo(db, id, completed)` - Update completion status
- `delete_todo(db, id)` - Remove todo

### 4. API Endpoints
- `GET /todos` - Returns list of todos
- `POST /todos` - Creates new todo, returns 201
- `PUT /todos/{id}` - Updates completed status, returns 404 if not found
- `DELETE /todos/{id}` - Deletes todo, returns 404 if not found

### 5. Database Initialization
- Create tables on startup if not exist
- Use aiosqlite for async SQLite operations

## Validation Steps

1. Run `uvicorn main:app --reload` and verify server starts
2. Test endpoints with curl/httpx:
   - `POST /todos` with JSON body `{"title": "test"}`
   - `GET /todos` returns array
   - `PUT /todos/1` with `{"completed": true}`
   - `DELETE /todos/1` returns 204
3. Verify data persists after restart
4. Run lint: `uv run ruff check .`

## Risks

- **SQLite concurrency**: Default SQLite has write locking issues. Use aiosqlite with WAL mode or note limitation.
- **No input validation**: Title could be empty string - add min_length validation
- **No error handling**: Return proper HTTP 404 for missing todo on update/delete

## Rollback Notes

- Revert changes to `main.py` to remove todo router
- Delete created database file (`todos.db`) if exists
- Remove added dependencies from `pyproject.toml` if only used for this feature