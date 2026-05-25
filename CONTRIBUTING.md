# Contributing to AirWatch (sky_tracker)

Thanks for taking the time to contribute! This document describes how to propose changes to the project.

## Code of Conduct

Be respectful. Disagreements happen — keep them about the code, not the people.

## Getting Started

1. Fork the repo and clone your fork.
2. Install Flutter 3.41.5+ (`flutter --version`).
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app to make sure your environment is set up:
   ```bash
   flutter run -d chrome
   ```

## Branch Naming

- `feat/<short-description>` — new features
- `fix/<short-description>` — bug fixes
- `refactor/<short-description>` — code restructuring without behavior change
- `docs/<short-description>` — documentation only
- `chore/<short-description>` — tooling, CI, dependencies

## Commit Messages

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <short summary>

<optional body explaining what and why>
```

Allowed types: `feat`, `fix`, `refactor`, `docs`, `chore`, `test`, `style`, `perf`, `build`, `ci`.

Examples:
- `feat(radar): add aircraft heading indicator`
- `fix(search): handle empty autocomplete response`
- `refactor(flight_detail): extract gate/terminal widget`

## Coding Standards

- **Lints**: code must pass `flutter analyze` without warnings.
- **Formatting**: run `dart format .` before committing.
- **Imports**: prefer `package:` imports over relative imports across feature boundaries.
- **State**: use Riverpod providers; avoid `StatefulWidget` unless local state is genuinely required.
- **Models**: use `freezed` for immutable data classes.
- **Async**: never leave a `Future` unawaited (lint enforces this); use `unawaited()` explicitly if intentional.
- **Localization**: never hardcode user-facing strings — add them to ARB files in `lib/core/l10n/`.

## Testing

Every PR should add or update tests for the change. We have three test tiers:

```bash
flutter test test/unit/          # pure logic, no widgets
flutter test test/widget/        # widget rendering and interaction
flutter test integration_test/   # end-to-end flows
```

CI runs analyze + unit tests automatically. Widget and integration tests should be runnable locally.

## Pull Request Checklist

Before opening a PR:

- [ ] `flutter analyze` passes with no warnings
- [ ] `dart format .` applied
- [ ] Tests added for new code
- [ ] All tests pass locally
- [ ] CHANGELOG.md updated under the `## [Unreleased]` heading
- [ ] No `print()` calls left in production code (use `debugPrint`)
- [ ] No `// TODO` without an associated issue link

## PR Review

PRs require approval from at least one CODEOWNER. CI must be green. Squash-merge is the default; preserve a clean commit history on the PR itself so the squashed message reads well.

## Reporting Bugs

Use the GitHub issue templates under `.github/ISSUE_TEMPLATE/`. Include:
- Device + OS version
- Flutter version (`flutter --version`)
- Steps to reproduce
- Expected vs actual behavior
- Logs from `flutter logs` if applicable

## Security Issues

Do **not** open public issues for security vulnerabilities. See [SECURITY.md](SECURITY.md) for the private disclosure process.

## License

By contributing, you agree that your contributions will be licensed under the project's proprietary license. See [LICENSE](LICENSE).
