---
trigger: always_on
---

# MCP Server Usage Rules

## Project-Specific MCPs

This repository has project-specific MCPs configured in `.mcp.json`. Environment variables are set in `.env.local`.

- **context7**: Flutter/Dart docs, GetX API, package docs (pub.dev)
- **github**: Remote only (issues, PRs, releases) - NOT for local git
- **trello**: Trello board operations (cards, lists, labels, checklists)
- **figma**: Figma design access and retrieval

## Global MCPs

- **filesystem**: File operations, directory traversal
- **memory**: Project patterns, user preferences across sessions

## When to Use Each MCP

### Context7 MCP
Flutter framework docs, GetX API reference, Dart syntax, package docs (Dio, geolocator, get_storage), Material Design 3

### GitHub MCP
Create/view issues/PRs on remote, view releases, repo metadata - **NOT** for local git operations

### Trello MCP
- Create/update/delete cards and lists
- Add comments, labels, checklists
- Move cards between lists
- Manage board members and assignments
- Access: https://trello.com/b/z8XwZF3U/aerosense-kanban

### Figma MCP
- Retrieve Figma design frames
- Access design specifications
- Get layout structure and styles
- Access: https://www.figma.com/design/nbEaJycmx0bstnYhVfTJ86/AeroSense

### Filesystem MCP
List directories, search files, read multiple files, get metadata

### Memory MCP
Remember architecture decisions, store common patterns/conventions, retain coding preferences, track shortcuts

## Environment Variables

Project-specific MCPs require these environment variables in `.env.local`:

| Variable | Purpose | Source |
|----------|---------|--------|
| `GITHUB_TOKEN` | GitHub API access | https://github.com/settings/tokens |
| `FIGMA_TOKEN` | Figma design access | Figma → Settings → Personal Access Tokens |
| `TRELLO_API_KEY` | Trello API key | https://trello.com/app-key |
| `TRELLO_TOKEN` | Trello OAuth token | Token link on app-key page |
| `CONTEXT7_API_KEY` | Context7 API (optional) | https://context7.com/dashboard |
