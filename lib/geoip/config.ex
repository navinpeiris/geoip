defmodule GeoIP.Config do
  def base_url, do: config[:url]

  defp config, do: Application.get_env(:geoip, GeoIP)
end
