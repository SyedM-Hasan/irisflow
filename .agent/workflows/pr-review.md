---
description: Instruction for Local PR Review
---

## Instruction for Local PR Review

When the user requests a **local PR review** by comparing two branches:

1. **Run a complete diff**
   Compare the source branch against the target branch and analyze the actual code changes, not just commit messages.

2. **Identify what the changes represent**
   Determine whether each change is a feature addition, bug fix, refactor, cleanup, or a potential breaking change. Note missing tests, incomplete docs, or inconsistencies.

3. **Assess code quality and impact**
   Evaluate correctness, readability, maintainability, architectural alignment, performance implications, and security considerations. Check whether tests adequately cover the changes.

4. **Flutter-Specific Review Items**

   In addition to general code quality, check for:

   - **GetX Patterns**: Are controllers used correctly? Is there proper separation between controllers and widgets?
   - **Widget Rebuilds**: Are `Obx()` widgets properly scoped to avoid unnecessary rebuilds?
   - **Memory Leaks**: Are streams closed in `onClose()`? Are timers cancelled? Are controllers properly disposed?
   - **State Management**: Is state properly managed with reactive variables? Is there a single source of truth?
   - **Platform Code**: Are platform channels implemented correctly? Are there proper iOS/Android fallbacks?
   - **Permission Handling**: Are runtime permissions properly requested and handled? Is there graceful degradation when denied?
   - **Performance**: Are `const` constructors used where possible? Are long lists using `ListView.builder`?
   - **Theming**: Are colors and styles using theme tokens, or are there hardcoded values?
   - **Error Handling**: Are errors caught and displayed to users? Is there proper logging with `debugPrint()`?
   - **Dependencies**: Are new dependencies from `pub.dev` properly vetted? Is `pubspec.yaml` updated correctly?

5. **Test Coverage**
   - Are there unit tests for controllers and business logic?
   - Are there widget tests for custom widgets?
   - Are there integration tests for critical user flows?
   - Do tests actually test the right behavior?

6. **Provide a senior-level review summary**
   Offer direct, actionable feedback: call out risks, highlight strengths, suggest improvements, and indicate whether the changes are ready to merge or need revisions.

7. **Aim for practical, high-value feedback**
   The goal is to emulate a real PR review from an experienced engineer—clear, specific, and focused on what matters.

## Flutter Code Review Checklist

### Architecture & Design
- [ ] Follows GetX patterns (controllers, bindings, routes)
- [ ] Proper separation of concerns (UI vs business logic)
- [ ] No hardcoded values (strings, colors, dimensions)
- [ ] Proper dependency injection using bindings

### State Management
- [ ] Uses reactive variables (`Rx<T>`, `.obs`)
- [ ] `Obx()` properly scoped for fine-grained updates
- [ ] Controllers don't create widgets (widgets should use controllers)
- [ ] No mixing of `setState()` and GetX

### Performance
- [ ] Uses `const` constructors where possible
- [ ] Uses `ListView.builder` for long lists
- [ ] No unnecessary rebuilds (proper `Obx()` scoping)
- [ ] Resources disposed in `onClose()`

### Platform Integration
- [ ] Permissions properly requested and handled
- [ ] Platform-specific code properly conditionally imported
- [ ] Proper fallbacks when platform features unavailable

### Code Quality
- [ ] Follows Dart style guide (naming, formatting)
- [ ] No unused imports (`dart analyze` clean)
- [ ] Proper error handling with user-friendly messages
- [ ] Appropriate use of `debugPrint()` for logging

### Testing
- [ ] Unit tests for business logic
- [ ] Widget tests for custom widgets
- [ ] Integration tests for critical flows
- [ ] Tests actually verify correct behavior

### Documentation
- [ ] Public APIs have doc comments
- [ ] Complex logic is explained
- [ ] Non-obvious code is commented
