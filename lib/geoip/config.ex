defmodule GeoIP.Config do
  def provider!, do: get(:provider) || raise(ArgumentError, "Missing configuration parameter `:provider`")

  def url!, do: get(:url) || raise(ArgumentError, "Missing configuration parameter `:url`")

  def cache_enabled?, do: get(:cache)
  def cache_ttl_secs, do: get(:cache_ttl_secs)

  defp get(key), do: Application.get_env(:geoip, key)
end
