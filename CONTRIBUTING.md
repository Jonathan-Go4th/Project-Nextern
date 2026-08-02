# Contributing to Nextern

Thank you for your interest in contributing to Nextern.

Nextern is a Flutter application that provides learning-program and internship
workflows for learners, together with programme-management tools for
administrators.

## Before contributing

Please:

1. Search existing issues before opening a new one.
2. Keep each contribution focused on one feature, fix, or documentation change.
3. Avoid committing generated files, build outputs, APK files, signing keys, or secrets.
4. Follow the existing Flutter and Dart coding style.
5. Add or update tests when behaviour changes.

## Development setup

Install a stable Flutter SDK compatible with the Dart requirement in
`pubspec.yaml`, then run:

```bash
git clone https://github.com/Jonathan-Go4th/Project-Nextern.git
cd Project-Nextern
flutter doctor
flutter pub get
flutter analyze
flutter test
flutter run
```

## Branch naming

Use descriptive branch names such as:

```text
feature/program-search
fix/enrolment-validation
docs/setup-guide
```

## Commit messages

Use clear commit messages. Recommended prefixes include:

```text
feat:
fix:
docs:
test:
refactor:
chore:
```

Examples:

```text
feat: add programme category filtering
fix: prevent duplicate enrolment submissions
docs: clarify Android setup instructions
```

## Pull requests

A pull request should include:

- A clear summary of the change
- The reason for the change
- Testing performed
- Screenshots for visible interface changes
- Any known limitations

Before submitting, run:

```bash
flutter analyze
flutter test
```

## Code style

Format Dart code before committing:

```bash
dart format .
```

Do not include unrelated formatting or generated-file changes in a focused
pull request.

## Licence

By contributing, you agree that your contribution may be distributed under
the MIT License used by this repository.