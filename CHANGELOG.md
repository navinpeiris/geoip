# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

- Bumped httpoison and cachex to eliminate deprecation warnings
- Dropped support for Elxir < 1.5

## v0.2.6 - 2019-10-04

- [#14](https://github.com/navinpeiris/geoip/pull/14) :extra_params config option

## v0.2.5 - 2019-08-13

- Use [jason](https://github.com/michalmuskala/jason) instead of [poison](https://github.com/devinus/poison).

## v0.2.4 - 2019-08-13

- [#13](https://github.com/navinpeiris/geoip/pull/13) Compatibility with Poison v4.0

## v0.2.3 - 2018-09-05

- Fixes issue where the `test` provider wasn't returning configured results for localhost.

## v0.2.2 - 2018-09-05

- Adds a `test` provider for returning lookup data in test environments.

## v0.2.0 - 2018-07-10

- Provides integrations with [ipstack.com](http://ipstack.com) and [ipinfo.io](http://ipinfo.io).

### Breaking Changes

- We don't default to using `freegeoip.net` as we used to as that service has now been deprecated. Instead the provider must be explicity provided. Please see the [README](https://github.com/navinpeiris/geoip/blob/master/README.md) for more details.

- The `GeoIP.lookup` function no longer returns a `GeoIP.Location` struct. Instead, it returns the parses response returned by the configured provider, with they keys converted to atoms. This was so ease the integration with multiple providers and so that we don't have to release a new version of this library every time a providers response format changes.

## v0.1.4 - 2018-05-29

- [#9](https://github.com/navinpeiris/geoip/pull/9) Update Cachex to version 3.0
