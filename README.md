<p align="center"><img src="logo/verticalversion.png" alt="geoip" height="200px"></p>

# GeoIP

[![Build Status](https://travis-ci.org/navinpeiris/geoip.svg?branch=master)](https://travis-ci.org/navinpeiris/geoip)
[![Hex version](https://img.shields.io/hexpm/v/geoip.svg "Hex version")](https://hex.pm/packages/geoip)
[![Hex downloads](https://img.shields.io/hexpm/dt/geoip.svg "Hex downloads")](https://hex.pm/packages/geoip)
[![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org)

Elixir library to lookup the geographic location for a given IP address, hostname, or `Plug.Conn`.

The returned results are cached for an hour by default so that we don't hit the service unnecessarily, but this is configurable can be disabled using the config options (see below).

## Installation

1. Add `geoip` to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [{:geoip, "~> 0.1"}]
  end
  ```

2. Update your mix dependencies
  ```
  mix deps.get
  ```

3. Add `geoip` to your applications list if you're using Elixir version 1.3 or lower

  ```elixir
  def application do
    [applications: [:geoip]]
  end
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

[ipstack](ipstack.com) provides a free tier although it requires you to sign up and get an api key first.

NOTE: The free tier does not allow https access so you _must_ specify `use_https: false` below.

```elixir
config :geoip, provider: :ipstack, api_key: "your-api-key", use_https: true
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


## Determining your `remote_ip` when behind a proxy

If your application is running behind a proxy, we recommend using [ajvondrak/remote_ip](https://github.com/ajvondrak/remote_ip) or something similar to override the `remote_ip` field of `Plug.Conn`. Due to the various different ways of determining the applications remote ip depending on your deployment environment, we leave this up to you to configure as appropriate.

## GeoIP logo

Special thanks to [@batarian71](https://github.com/batarian71) for designing and providing this project with an awesome logo

## License

The MIT License

Copyright (c) 2016-present Navin Peiris

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
