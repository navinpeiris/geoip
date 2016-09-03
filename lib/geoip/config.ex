defmodule GeoIP.Config do
  def base_url, do: config[:url]
  def cache_enabled?, do: config[:cache]
  def cache_ttl_secs, do: config[:cache_ttl_secs]

  defp config, do: Application.get_env(:geoip, GeoIP)
end
