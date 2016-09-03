# GeoIP

[![Build Status](https://travis-ci.org/navinpeiris/geoip.svg?branch=master)](https://travis-ci.org/navinpeiris/geoip)
[![Hex version](https://img.shields.io/hexpm/v/geoip.svg "Hex version")](https://hex.pm/packages/geoip)
[![Hex downloads](https://img.shields.io/hexpm/dt/geoip.svg "Hex downloads")](https://hex.pm/packages/geoip)
[![Deps Status](https://beta.hexfaktor.org/badge/all/github/navinpeiris/geoip.svg)](https://beta.hexfaktor.org/github/navinpeiris/geoip)
[![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org)

Elixir library to lookup the geographic location for a given IP address (or hostname, or `Plug.Conn`).

By default, the data is retrieved from [freegeoip.net](https://freegeoip.net), but you are can optionally use [your own freegeoip installation](https://github.com/fiorix/freegeoip) which is highly recommended for production environments.

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

2. Ensure `geoip` is started before your application:

  ```elixir
  def application do
    [applications: [:geoip]]
  end
  ```

## Usage

You can pass in an IP address (as a string or a struct), hostname or a `Plug.Conn` struct to be looked up.

```elixir
GeoIP.lookup("google.com")
#=> {:ok, %GeoIP.Location{city: "Mountain View", country_code: "US", country_name: "United States", ip: "172.217.4.78", latitude: 37.4192, longitude: -122.0574, metro_code: 807, region_code: "CA", region_name: "California", time_zone: "America/Los_Angeles", zip_code: "94043"}}

# Other examples:
GeoIP.lookup("8.8.8.8")
GeoIP.lookup({8, 8, 8, 8})
GeoIP.lookup(conn)
```

This returns `{:ok, response}` if the lookup is successful, `{:error, %GeoIP.Error{reason: reason}}` otherwise.

## Configuration

You can change the freegeoip server that is used by specifying the value of the `url` option:

```elixir
config :geoip, url: "https://geoip.example.com"
```

By default, the location results returned by the freegeoip server is cached for an hour. We can disable the cache by:

```elixir
config :geoip, cache: false
```

Or to change the time limit of cached results:

```elixir
config :geoip, cache_ttl_secs: 1800 # 30 mins
```

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
