---
description: How to create a new release for AeroSense Flutter app
---

# Mobile Release Process Workflow

Steps to create an official AeroSense release. Version numbers below are examples.

## 1. Version Detection & Branch Check

```bash
# Check current branch
git branch --show-current

# If not on release branch, create one
git checkout -b release/1.0.1
```

Version format: `x.y.z+z` where `x.y.z` is semantic version and `+z` is build number.
Example: `version: 1.0.1+2`

## 2. Update Version Files

- `pubspec.yaml`: `version: 1.0.1+2`
- `project-metadata.md`: Update version
- `VERSION` file (if exists): `1.0.1` (no `v` prefix)

## 3. Dependencies & Quality Checks

```bash
flutter pub get
flutter pub outdated
flutter analyze
dart format .
dart fix --apply
flutter test
```

## 4. Build & Test

```bash
# Android
flutter build apk --release              # For testing
flutter build appbundle --release        # For Play Store

# iOS
flutter build ios --release              # Then use Xcode to upload
```

Test APK/AAB on physical device or emulator.

## 5. Analyze Changes

```bash
git log v1.0.0..HEAD --oneline
```

Identify breaking changes, features, bug fixes, improvements.

## 6. Create Release Notes

Create `docs/release-notes/YYYY-MM-DD-RELEASE_NOTE_v1.0.1.md`:

```markdown
# AeroSense Release Note - v1.0.1

**Release Date:** {DATE}
**Previous Release:** v1.0.0 ({DATE})
**Branch Comparison:** `v1.0.0` with `release/1.0.1`

## Added
- New feature 1
- New feature 2

## Changed
- Improvement 1
- Updated package X to v2.0

## Fixed
- Bug fix 1
- Bug fix 2

## Known Issues
- Issue 1 (if any)
```

## 7. Update Changelog

Add to `CHANGELOG.md`:

```markdown
## [1.0.1] - 2025-11-17
### Added
- Location search
### Changed
- Improved onboarding
### Fixed
- Permission crash
```

## 8. Commit & Push

```bash
git add pubspec.yaml project-metadata.md CHANGELOG.md docs/release-notes/
git commit -m "AERO-XXXX: Release v1.0.1"
git push origin release/1.0.1
```

## 9. Tag & GitHub Release

```bash
git tag -a v1.0.1 -m "Release v1.0.1"
git push origin v1.0.1
gh release create v1.0.1 --title "v1.0.1" --notes-file docs/release-notes/YYYY-MM-DD-RELEASE_NOTE_v1.0.1.md
```

## 10. Store Deployment

### Android (Google Play Store)
1. Go to [Play Console](https://play.google.com/console)
2. Create release: Internal → Closed → Open → Production
3. Upload: `build/app/outputs/bundle/release/app-release.aab`
4. Add release notes, submit for review

### iOS (App Store Connect)
1. Build: `flutter build ios --release`
2. Open Xcode: `open ios/Runner.xcworkspace`
3. Product → Archive → Distribute App
4. Or use Transporter app
5. Go to [App Store Connect](https://appstoreconnect.apple.com), create version, submit

## 11. Post-Release

```bash
# Merge to main
git checkout main
git merge release/1.0.1
git push origin main

# Optional: Delete release branch
git branch -d release/1.0.1
git push origin --delete release/1.0.1
```

Test on physical devices, monitor Firebase Crashlytics, review user feedback.

## Quick Commands Reference

```bash
# Prep
flutter pub get && flutter analyze && dart format . && flutter test

# Build
flutter build appbundle --release
flutter build ios --release

# Git
git tag -a v1.0.1 -m "Release" && git push origin v1.0.1
gh release create v1.0.1 --title "v1.0.1" --notes "Release notes"
```
