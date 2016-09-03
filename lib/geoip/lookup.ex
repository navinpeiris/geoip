defmodule GeoIP.Lookup do
  alias GeoIP.{Config, Location, Error}

  def lookup(nil), do: %Location{}

  def lookup(%{remote_ip: ip}), do: lookup(ip)

  def lookup(ip) when is_tuple(ip), do: ip |> Tuple.to_list |> Enum.join(".") |> lookup

  def lookup(ip) when is_binary(ip), do: ip |> lookup_url |> HTTPoison.get |> parse_response

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
    {:error, %Error{reason: "Error looking up ip: #{inspect(result)}"}}
  end

  defp lookup_url(ip), do: "#{Config.base_url}/json/#{ip}"
end
