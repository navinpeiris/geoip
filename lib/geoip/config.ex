defmodule GeoIP.Config do
  def provider!, do: get!(:provider)

  def url!, do: get!(:url)

  def api_key!, do: get!(:api_key)

  def api_key, do: get(:api_key)

  def use_https, do: get(:use_https)

  def cache_enabled?, do: get(:cache)

  def cache_ttl_secs, do: get(:cache_ttl_secs)

  def test_results, do: get(:test_results) || %{}

  def default_test_result, do: get(:default_test_result)
  
  def extra_params, do: if(get(:extra_params), do: "&" <> URI.encode_query(get(:extra_params)), else: "")

  defp get!(key) do
    get(key) || raise(ArgumentError, "Missing configuration parameter `:#{key}`")
  end

  defp get(key), do: Application.get_env(:geoip, key)
end
