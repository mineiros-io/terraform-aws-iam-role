# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.5.0]

### Added

- feat: add support for Terraform `v0.15`
- fix: remove ssh agent forwarding in Makefile

### Changed

- feat: upgrade pre-commit hooks to `v0.2.3`
- build: upgrade build-tools hooks to `v0.11.0`

## [0.4.2]

### Added

- feat: feat: add support for Terraform `v0.14.x`

### Changed

- feat: upgrade terratest to `v1.34.0`
- build: update secrets in GitHub Actions pipeline
- build: upgrade build-tools to `v0.9.0`
- build: upgrade pre-commit-hooks to `v0.2.2`

## [0.4.1]

### Added

- feat: Add create_policy argument to force creating inline policy

## [0.4.0]

### Changes

- BREAKING CHANGE: Rename output `policy_attachment` to `policy_attachments` and export all policy attachments.

## [0.3.1]

### Added

- Prepare support for Terraform v0.14.x (needs terraform v0.12.20 or above)

## [0.3.0]

### Added

- Add support for Terraform v0.13.x

### Changed

- Fix invalid characters for names on the fly by replacing them with a single dash.
- Rename name to `role_name` and `name_prefix` to role_prefix.
- BREAKING CHANGE: Use `name` and `name_prefix` as defaults for `role_name*`, `policy_name*` and `instance_profile_name*`
  - to upgrade rename `name` to `role_name` and `name_prefix` to `role_name_prefix`.

## [0.2.0]

### Changed

- Add support for Terraform AWS Provider v3.x
- Update test to test against 3.0 aws provider

## [0.1.0]

### Added

- Add CHANGELOG.md

### Changed

- Align repository structure and style

## [0.0.2]

### Fixed

- Fix an issue in `module_depends_on` argument

## [0.0.1]

### Added

- Add support to create an IAM role
- Add support to create an IAM role inline policy
- Add support to create an IAM role policy attachments for custom and/or managed IAM policies
- Add support to create an instance profile with attached IAM role

<!-- markdown-link-check-disable -->

[unreleased]: https://github.com/mineiros-io/terraform-aws-iam-role/compare/v0.5.0...HEAD
[0.5.0]: https://github.com/mineiros-io/terraform-aws-iam-role/compare/v0.4.2...v0.5.0

<!-- markdown-link-check-disabled -->

[0.4.2]: https://github.com/mineiros-io/terraform-aws-iam-role/compare/v0.4.1...v0.4.2
[0.4.1]: https://github.com/mineiros-io/terraform-aws-iam-role/compare/v0.4.0...v0.4.1
[0.4.0]: https://github.com/mineiros-io/terraform-aws-iam-role/compare/v0.3.1...v0.4.0
[0.3.1]: https://github.com/mineiros-io/terraform-aws-iam-role/compare/v0.3.0...v0.3.1
[0.3.0]: https://github.com/mineiros-io/terraform-aws-iam-role/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/mineiros-io/terraform-aws-iam-role/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/mineiros-io/terraform-aws-iam-role/compare/v0.0.2...v0.1.0
[0.0.2]: https://github.com/mineiros-io/terraform-aws-iam-role/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/mineiros-io/terraform-aws-iam-role/releases/tag/v0.0.1
