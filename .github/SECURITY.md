# Security Policy

## Supported versions

| Version | Supported |
| ------- | --------- |
| 2.x     | Yes       |
| 1.x     | No        |
| 0.x     | No        |

Only the latest 2.x release receives fixes. 1.x targets iOS 10 and RxSwift 5,
and 0.x targets Swift 4.2; neither builds on a current toolchain.

## Reporting a vulnerability

Please report suspected vulnerabilities privately through GitHub, using
[**Report a vulnerability**](https://github.com/futamura/RxPullToRefresh/security/advisories/new)
under the repository's Security tab. Do not open a public issue for a security
problem.

Please include the affected version, the conditions needed to trigger the
problem, and its impact. This is a spare-time project, so expect an initial
response within about two weeks.

## Scope

This is a UI library: it draws a refresh view and observes scroll position. It
performs no networking, reads no credentials, and writes nothing to disk, so the
plausible surface is small — memory-safety problems in the KVO observation or
animation code are the realistic case.

Issues in the dependencies (RxSwift, RxCocoa) belong with those projects. Issues
in the example app or the test targets are not shipped to users; report those as
ordinary issues.
