<p align="center"><img src="assets/verticalversion.png" alt="geoip" height="200px"></p>

# GeoIP

[![Build Status](https://travis-ci.org/navinpeiris/geoip.svg?branch=master)](https://travis-ci.org/navinpeiris/geoip)
[![Module Version](https://img.shields.io/hexpm/v/geoip.svg)](https://hex.pm/packages/geoip)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/geoip/)
[![Total Download](https://img.shields.io/hexpm/dt/geoip.svg)](https://hex.pm/packages/geoip)
[![License](https://img.shields.io/hexpm/l/geoip.svg)](https://github.com/navinpeiris/geoip/blob/master/LICENSE.md)
[![Last Updated](https://img.shields.io/github/last-commit/navinpeiris/geoip.svg)](https://github.com/navinpeiris/geoip/commits/master)

Elixir library to lookup the geographic location for a given IP address, hostname, or `Plug.Conn`.

The returned results are cached for an hour by default so that we don't hit the service unnecessarily, but this is configurable can be disabled using the config options (see below).

## Installation

Add `:geoip` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:geoip, "~> 0.2"}
  ]
end
```

Update your mix dependencies:

```elixir
mix deps.get
```

## Configuration

### Provider

The provider must be explicitly specified along with any required attributes as per examples below.

#### freegeoip

The free host that was available at `freegeoip.net` and the corresponding source repository at
[fiorix/freegeoip](https://github.com/fiorix/freegeoip) was deprecated in the middle of 2018, but
it still allows you to launch your own instance if you wish.

```elixir
config :geoip, provider: :freegeoip, url: "https://geoip.example.com"
```

#### ipstack

[ipstack](https://ipstack.com) provides a free tier although it requires you to sign up and get an api key first.

NOTE: The free tier does not allow https access so you _must_ specify `use_https: false` below.

```elixir
config :geoip, provider: :ipstack, api_key: "your-api-key"
```

#### ipinfo

[ipinfo](https://ipinfo.io) does not unfortunately support lookup by hostname (only ip address), therefore the above examples where a hostname is used will return an error.

```elixir
config :geoip, provider: :ipinfo, api_key: "your-api-key"
```

#### IP2Location.io

[IP2Location.io](https://ip2location.io) does not support lookup by hostname (only ip address), therefore the above examples where a hostname is used will return an error.

NOTE: Translation for certain columns is available for Plus and Security plan. You can visit the Parameters section in [https://www.ip2location.io/ip2location-documentation](https://www.ip2location.io/ip2location-documentation) for more information

```elixir
config :geoip, provider: :ip2locationio, api_key: "your-api-key"
```

#### test

Provides an easy way to provide mock lookup data in test environments.

The `test_results` param is a map of host to lookup results that should be returned. If the ip/host looked up is not found in this map, then the results provided by the `default_test_result` param is provided.

```elixir
config :geoip,
  provider: :test,
  test_results: %{ # optional
   "host.1" => %{
     ip: "123.123.123.123",
     # ......
   },
   "host.2" => %{
     ip: "1.1.1.1",
     # ......
   },
  },
  default_test_result: %{ # optional
   ip: "192.168.3.3",
   # ......
  }
```

### Caching

By default, the location results returned by the freegeoip server is cached for an hour. We can disable the cache by:

```elixir
config :geoip, cache: false
```

Or to change the time limit of cached results:

```elixir
config :geoip, cache_ttl_secs: 1800 # 30 mins
```

### Extra parameters

You can add extra query parameters to geoip service requests via `:extra_params` config option:

```elixir
config :geoip, extra_params: [language: "RU"]
```

## Usage

You can pass in an IP address (as a string or a struct), hostname or a `Plug.Conn` struct to be looked up.

```elixir
GeoIP.lookup("google.com")
#=> {:ok, %{city: "Mountain View", country_code: "US", country_name: "United States", ip: "172.217.4.78", latitude: 37.4192, longitude: -122.0574, metro_code: 807, region_code: "CA", region_name: "California", time_zone: "America/Los_Angeles", zip_code: "94043"}}

# Other examples:
GeoIP.lookup("8.8.8.8")
GeoIP.lookup({8, 8, 8, 8})
GeoIP.lookup(conn)
```

This returns `{:ok, response}` if the lookup is successful, `{:error, %GeoIP.Error{reason: reason}}` otherwise.

## Testing

Please see the `test` provider above.

## Determining your `remote_ip` when behind a proxy

If your application is running behind a proxy, we recommend using [ajvondrak/remote_ip](https://github.com/ajvondrak/remote_ip) or something similar to override the `remote_ip` field of `Plug.Conn`. Due to the various different ways of determining the applications remote ip depending on your deployment environment, we leave this up to you to configure as appropriate.

## GeoIP logo

Special thanks to [@batarian71](https://github.com/batarian71) for designing and providing this project with an awesome logo

## Related Packages

* https://github.com/elixir-geolix/geolix If you want to use the [MaxMind files directly](https://github.com/navinpeiris/geoip/issues/1)
* https://github.com/knrz/geocoder
* https://github.com/amotion-city/lib_lat_lon

## Copyright and License

Copyright (c) 2016 Navin Peiris

This work is free. You can redistribute it and/or modify it under the
terms of the MIT License. See the [LICENSE.md](./LICENSE.md) file for more details.
