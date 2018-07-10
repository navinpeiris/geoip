defmodule GeoIPTest do
  use ExUnit.Case, async: false

  import Mock

  alias GeoIP.Location

  describe "lookup/1 using freegeoip" do
    @freegeoip_response_body ~s({
                                  "ip": "192.30.253.113",
                                  "country_code": "US",
                                  "country_name": "United States",
                                  "region_code": "CA",
                                  "region_name": "California",
                                  "city": "San Francisco",
                                  "zip_code": "94107",
                                  "time_zone": "America/Los_Angeles",
                                  "latitude": 37.7697,
                                  "longitude": -122.3933,
                                  "metro_code": 807
                                  })

    test "returns empty result when given localhost" do
      {:ok, %Location{ip: "127.0.0.1"}} = GeoIP.lookup("localhost")
    end

    test "returns empty result when given localhost ip" do
      {:ok, %Location{ip: "127.0.0.1"}} = GeoIP.lookup("127.0.0.1")
    end

    test "returns location when given a valid IP address as string" do
      with_mock(HTTPoison, [
        get: fn("https://freegeoip.net/json/192.30.253.113") ->
          {:ok, %HTTPoison.Response{status_code: 200, body: @freegeoip_response_body}}
        end
      ]) do
        {:ok, location} = GeoIP.lookup("192.30.253.113")

        assert location.ip == "192.30.253.113"
        assert location.city == "San Francisco"
        assert location.region_name == "California"
        assert location.country_code == "US"
        assert location.country_name == "United States"
      end
    end

    test "returns location when given a valid IP address as tuple" do
      with_mock(HTTPoison, [
        get: fn("https://freegeoip.net/json/192.30.253.113") ->
          {:ok, %HTTPoison.Response{status_code: 200, body: @freegeoip_response_body}}
        end
      ]) do
        {:ok, location} = GeoIP.lookup({192, 30, 253, 113})

        assert location.ip == "192.30.253.113"
        assert location.city == "San Francisco"
        assert location.region_name == "California"
        assert location.country_code == "US"
        assert location.country_name == "United States"
      end
    end

    test "returns location when given a `conn` struct" do
      with_mock(HTTPoison, [
        get: fn("https://freegeoip.net/json/192.30.253.113") ->
          {:ok, %HTTPoison.Response{status_code: 200, body: @freegeoip_response_body}}
        end
      ]) do
        {:ok, location} = GeoIP.lookup(%{remote_ip: {192, 30, 253, 113}})

        assert location.ip == "192.30.253.113"
        assert location.city == "San Francisco"
        assert location.region_name == "California"
        assert location.country_code == "US"
        assert location.country_name == "United States"
      end
    end

    test "returns location when given a valid host name" do
      with_mock(HTTPoison, [
        get: fn("https://freegeoip.net/json/github.com") ->
          {:ok, %HTTPoison.Response{status_code: 200, body: @freegeoip_response_body}}
        end
      ]) do
        {:ok, location} = GeoIP.lookup("github.com")

        assert location.country_code == "US"
        assert location.country_name == "United States"
      end
    end

    test "returns error when given a invalid IP address" do
      with_mock(HTTPoison, [
        get: fn("https://freegeoip.net/json/8.8") ->
          {:ok, %HTTPoison.Response{status_code: 404, body: "404 page not found"}}
        end
      ]) do
        {:error, _} = GeoIP.lookup("8.8")
      end
    end

    test "returns error when given a invalid hostname" do
      with_mock(HTTPoison, [
        get: fn("https://freegeoip.net/json/invalidhost") ->
          {:ok, %HTTPoison.Response{status_code: 404, body: "404 page not found"}}
        end
      ]) do
        {:error, _} = GeoIP.lookup("invalidhost")
      end
    end
  end
end
