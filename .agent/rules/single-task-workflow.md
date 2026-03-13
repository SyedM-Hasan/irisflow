---
trigger: always_on
---

# Single Task Workflow

Follow this workflow when implementing a task:

## 1. Requirements Gathering
- Read the relevant Jira/Trello card description and all comments
- Check parent ticket/card descriptions and comments for context
- If requirements are unclear or ambiguous, **ask the user for clarification**
- If a Figma frame link is provided, use the Figma MCP to retrieve frame data

## 2. Branch Setup
- Create a feature branch following git guidelines
- Format: `type/AERO-TICKET_NUMBER-hyphenated-description`
- Never work on `main` or `dev` branches
- If already in the correct branch, skip this step

## 3. Planning Phase
- Analyze the codebase and design a solution
- Create a step-by-step implementation plan
- Write the plan to a file in `./docs/` folder
- **Wait for user approval before implementing**
- If user requests changes, update the plan accordingly

## 4. Implementation Phase
After explicit user approval:
- Ensure you're on the correct branch
- Commit the plan file
- Move the Jira/Trello card to "In Progress" status
- Create a todo list in your context tracking all implementation steps
- Implement step-by-step following the plan

## 5. Testing
- Write unit tests for business logic
- Write widget tests for UI components
- Write integration tests for end-to-end flows
- Ensure all tests pass

## 6. Verification
- Compare implementation against the original plan
- Verify all steps are completed
- Confirm the implementation meets requirements

## 7. Finalization
- Remove the plan file from `./docs/` folder
- Commit all changes following git guidelines
- Push to remote repository
- Move the Jira/Trello card to "In Review" status
- Summarize changes to the user
