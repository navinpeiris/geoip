defmodule GeoIP.Lookup do
  alias GeoIP.{Config, Location, Error}

  def lookup(nil), do: %Location{}

  def lookup(%{remote_ip: host}), do: lookup(host)

  def lookup(host) when is_tuple(host), do: host |> Tuple.to_list |> Enum.join(".") |> lookup

  def lookup("localhost"), do: lookup("127.0.0.1")

  def lookup("127.0.0.1" = ip), do: {:ok, %Location{ip: ip}}

  def lookup(host) when is_binary(host) do
    case get_from_cache(host) do
      {:ok, location} -> {:ok, location}
      _ -> host |> lookup_url |> HTTPoison.get |> parse_response |> put_in_cache(host)
    end
  end

  defp get_from_cache(host) do
    if Config.cache_enabled?, do: Cachex.get(:geoip_lookup_cache, host)
  end

  defp put_in_cache({:ok, location} = result, host) do
    if Config.cache_enabled?, do: Cachex.set(:geoip_lookup_cache, host, location)
    result
  end
  defp put_in_cache(result, _), do: result

  defp parse_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    {:ok, Poison.decode!(body, as: %Location{})}
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

  defp lookup_url(host), do: "#{Config.base_url}/json/#{host}"
end
