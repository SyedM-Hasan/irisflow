---
trigger: model_decision
description: Ruleset that MUST be followed when executing ANY git command
---

# Git Guidelines

## Sacred Rule:
- NEVER run a `git` command without user's explicit approval.

## Project Slug:
- PROJECTSLUG is a shortened name for the project to be used as an abbreviation for several things, example: JIRA tickets.
- PROJECTSLUG for this project is: **AERO**
- Can be found in the `./project-metadata.md` file.

## Branch Naming:
- Format: type/PROJECTSLUG-TICKET_NUMBER-hyphenated-short-description
- Example: `feature/AERO-123-add-location-search`, `bugfix/AERO-234-fix-permission-crash`
- Exception: Release branches should be named like this: `release/1.2.3`, no description or ticket number, just the version number.
- Use imperative, hyphenated style for description.
- Never assume ticket number. If missing, omit it.
- Note: If the project uses Trello, then Card Number should be used in place of Ticket number.

## Commit Messages:
- ALWAYS use single line commit message
- Format: PROJECTSLUG-TICKET_NUMBER: message
- Example: `AERO-123: Add location permission handling`
- Extract ticket number from branch name
- If ticket is not identifiable, omit prefix and write message only.
## Example .gitignore Entries

If any of the above are missing from `.gitignore`, add them. Never commit sensitive build artifacts.

## Release Workflow

For release branches and tagging, follow the mobile release workflow in `.agent/workflows/mobile-release.md`.
