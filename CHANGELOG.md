# v0.2.6

- [#14](https://github.com/navinpeiris/geoip/pull/14) :extra_params config option

# v0.2.5

- Use [jason](https://github.com/michalmuskala/jason) instead of [poison](https://github.com/devinus/poison).

# v0.2.4

- [#13](https://github.com/navinpeiris/geoip/pull/13) Compatibility with Poison v4.0

# v0.2.3

- Fixes issue where the `test` provider wasn't returning configured results for localhost.

# v0.2.2

- Adds a `test` provider for returning lookup data in test environments.

# v0.2.0

- Provides integrations with [ipstack.com](http://ipstack.com) and [ipinfo.io](http://ipinfo.io).

### Breaking Changes

- We don't default to using `freegeoip.net` as we used to as that service has now been deprecated. Instead the provider must be explicity provided. Please see the [README](https://github.com/navinpeiris/geoip/blob/master/README.md) for more details.

- The `GeoIP.lookup` function no longer returns a `GeoIP.Location` struct. Instead, it returns the parses response returned by the configured provider, with they keys converted to atoms. This was so ease the integration with multiple providers and so that we don't have to release a new version of this library every time a providers response format changes.

# v0.1.4

- [#9](https://github.com/navinpeiris/geoip/pull/9) Update Cachex to version 3.0
