defmodule GeoIP.Config do
  def base_url, do: get(:url)
  def cache_enabled?, do: get(:cache)
  def cache_ttl_secs, do: get(:cache_ttl_secs)

  defp get(key), do: Application.get_env(:geoip, key)
end
