---
trigger: glob
globs: .agent/rules/*.md
---

# Agent Rule Standards

**IMPORTANT NOTE:** AI agents may have difficulties accessing/writing in the rule files, because they are in the .agent/rules directory. In that case the AI agent should use the terminal to access/write the rule files.

- All AI Agent rules must reside in the `.agent/rules` directory and should use `.md` extension.
- All AI Agent rules must follow a specific trigger syntax in their frontmatter.

## Trigger Types

### 1. Always On
Applied for every interaction.
```yaml
---
trigger: always_on
---
```

### 2. Manual
Triggers only when explicitly requested.
```yaml
---
trigger: manual
---
```

### 3. AI Model Decision
Triggers based on the AI's understanding of the task.
```yaml
---
trigger: model_decision
description: A short description about this rule that helps the AI to decide on whether to use this rule in a situation (Maximum 250 characters)
---
```

### 4. Glob Pattern
Triggers when working with files matching a specific pattern.
```yaml
---
trigger: glob
globs: Glob pattern (e.g., *.js, src/**/*.ts) for the files this rule applies to (Maximum 250 characters)
---
```

## Formatting
After the trigger syntax, each rule should have a clear **Rule Title** (H1) and detailed instructions in markdown format.