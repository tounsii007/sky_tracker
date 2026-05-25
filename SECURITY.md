# Security Policy

## Reporting a vulnerability

**Please do not file a public GitHub issue for security vulnerabilities.**

To report a security problem privately, use GitHub's built-in mechanism:
**Security → Report a vulnerability** (top of this repo on GitHub).

Alternatively, email the maintainer directly (see `git log --format='%ae'` for
the active address).

A useful report includes:

1. A description of the vulnerability and what an attacker could achieve.
2. Reproduction steps — the shorter, the better.
3. The conditions required (authentication state, device, OS, Flutter version).
4. A suggested mitigation if you have one.

## Threat model — what's in-scope

AirWatch is a mobile + web client that talks to a remote API. The attack
surface we own here:

| Class | In-scope? | Notes |
|---|---|---|
| Hard-coded secrets / API keys in the binary | ✅ Critical | Anything sensitive must come via `--dart-define` at build time, not be committed |
| Insecure WebSocket / HTTP traffic (cleartext, no TLS pinning) | ✅ High | Production builds use `API_CERT_PINS` |
| Misuse of `WebView` or external links (XSS in detail panes) | ✅ High | All user-facing strings go through the localization layer; no raw HTML injection |
| Privilege escalation via custom URL schemes (`airwatch://`) | ✅ Medium | Deep-link handlers must validate path and parameters |
| Information leakage in logs (PII, tokens, flight identifiers) | ✅ Medium | `debugPrint` is for dev; production builds must drop verbose logs |
| Crashes triggered by malformed server responses (parser fuzzing) | ✅ Medium | `freezed` + JSON parsing is the hard edge; bad input should not crash the app |
| Map / camera / sensor permissions abused at runtime | ✅ Medium | Permissions are requested in-flow with explanation, never on app start |
| Vulnerability in `flutter_riverpod`, `dio`, `flutter_map`, etc. | ✅ In-scope | Tracked via Dependabot |
| Issues in the upstream Flutter SDK | ❌ Out-of-scope | Report upstream at https://github.com/flutter/flutter |
| Issues in the third-party flight data sources | ❌ Out-of-scope | Report to the data provider — we just consume them |

## Hardening checklist (developer-facing)

- [ ] No hard-coded API keys or tokens in source — use `--dart-define`
- [ ] HTTPS for all network calls (`Dio` baseUrl starts with `https://`)
- [ ] Certificate pinning enabled for production via `API_CERT_PINS`
- [ ] `kDebugMode` guard around any verbose logging in production paths
- [ ] User input lengths capped before sending to APIs (mitigates DoS)
- [ ] Deep-link handlers validate both the scheme and the path parameters
- [ ] ProGuard / R8 rules in `android/app/build.gradle` keep model classes
      reachable but obfuscate everything else
- [ ] iOS `Info.plist` `NSAppTransportSecurity` does **not** allow arbitrary loads

## Response timeline

| Severity  | Acknowledgement | Fix target |
|-----------|----------------|-----------|
| Critical  | 1 business day  | 7 days    |
| High      | 2 business days | 14 days   |
| Medium    | 3 business days | 30 days   |
| Low       | 5 business days | 90 days   |

## Supported versions

Only the latest commit on the **default branch** and the most recent tagged
release receive security patches. There are no long-term-support branches.

## Coordinated disclosure

After a fix is shipped we will publish a GitHub Security Advisory and credit
the reporter (with their consent). Please allow us the agreed fix window
before any public disclosure or PoC posting.
