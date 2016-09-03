# GeoIP

Elixir library to lookup the geographic location for a given IP address using Freegeoip.net (or optionally your own installation).

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `geoip` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:geoip, "~> 0.1"}]
    end
    ```

  2. Ensure `geoip` is started before your application:

    ```elixir
    def application do
      [applications: [:geoip]]
    end
    ```
