require Cachex.Spec

defmodule GeoIP do
  @moduledoc """
  Elixir library to lookup the geo location for an IP address or hostname using freegeoip.net

  ## Examples

      iex> GeoIP.lookup("google.com")
      {:ok,
       %{
        city: "San Francisco",
        country_code: "US",
        country_name: "United States",
        ip: "192.30.253.113",
        latitude: 37.7697,
        longitude: -122.3933,
        metro_code: 807,
        region_code: "CA",
        region_name: "California",
        time_zone: "America/Los_Angeles",
        zip_code: "94107"
        }
      }

  """

  use Application
  alias GeoIP.Config

  def start(_type, _args) do
    children = [
      {
        Cachex,
        name: :geoip_lookup_cache,
        expiration: Cachex.Spec.expiration(default: :timer.seconds(Config.cache_ttl_secs()))
      }
    ]

    opts = [strategy: :one_for_one, name: GeoIP.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Lookup the location for the given IP address/hostname.

  Args:
    * `host` - The IP/hostname or Plug.Conn instance to use for the lookup. The IP can be either a string or a tuple.

  This function returns `{:ok, response}` if the lookup is successful, `{:error, %GeoIP.Error{reason: reason}}` otherwise.

  ## Examples

      {:ok, location} = GeoIP.lookup({8, 8, 8, 8})
      {:ok, location} = GeoIP.lookup("8.8.8.8")
      {:ok, location} = GeoIP.lookup("google.com")
      {:ok, location} = GeoIP.lookup(conn)         # A `Plug.Conn` instance

  """
  def lookup(host), do: GeoIP.Lookup.lookup(host)
end
