defmodule GeoIP.Lookup do
  alias GeoIP.{Config, Error}

  def lookup(nil), do: %{}

  def lookup(%{remote_ip: host}), do: lookup(host)

  def lookup(host) when is_tuple(host), do: host |> Tuple.to_list() |> Enum.join(".") |> lookup

  def lookup("localhost"), do: lookup("127.0.0.1")

  def lookup("127.0.0.1" = ip), do: {:ok, %{ip: ip}}

  def lookup(host) when is_binary(host) do
    case get_from_cache(host) do
      {:ok, location} when not is_nil(location) ->
        {:ok, location}

      _ ->
        host
        |> lookup_url
        |> HTTPoison.get()
        |> parse_response
        |> put_in_cache(host)
    end
  end

  defp get_from_cache(host) do
    if Config.cache_enabled?(), do: Cachex.get(:geoip_lookup_cache, host)
  end

  defp put_in_cache({:ok, location} = result, host) do
    if Config.cache_enabled?(), do: Cachex.put(:geoip_lookup_cache, host, location)

    result
  end

  defp put_in_cache(result, _), do: result

  defp parse_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    {:ok, Poison.Parser.parse!(body, keys: :atoms)}
  end

  defp parse_response({:ok, %HTTPoison.Response{status_code: _, body: body}}) do
    {:error, %Error{reason: body}}
  end

  defp parse_response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, %Error{reason: reason}}
  end

  defp parse_response(result) do
    {:error, %Error{reason: "Error looking up host: #{inspect(result)}"}}
  end

  defp lookup_url(host), do: lookup_url(Config.provider!(), host)

  defp lookup_url(:freegeoip, host), do: "#{Config.url!()}/json/#{host}"

  defp lookup_url(:ipstack, host),
    do: "#{http_protocol()}://api.ipstack.com/#{host}?access_key=#{Config.api_key!()}"

  defp lookup_url(:ipinfo, host),
    do: "#{http_protocol()}://ipinfo.io/#{host}/json?token=#{Config.api_key()}"

  defp lookup_url(provider, _host) do
    raise ArgumentError,
          "Unknown provider: '#{inspect(provider)}'. Please check your geoip configuration."
  end

  defp http_protocol do
    if Config.use_https() do
      "https"
    else
      "http"
    end
  end
end
