defmodule GeoIPTest do
  use ExUnit.Case, async: false

  import Mock

  setup do
    Application.put_env(:geoip, :cache, false)

    :ok
  end

  describe "lookup/1 when provider is not specified" do
    setup do
      Application.put_env(:geoip, :provider, nil)

      :ok
    end

    test "throws an error" do
      assert_raise ArgumentError, fn ->
        GeoIP.lookup("github.com")
      end
    end
  end

  describe "lookup/1 when provider is not known" do
    setup do
      Application.put_env(:geoip, :provider, :invalid)

      :ok
    end

    test "throws an error" do
      assert_raise ArgumentError, fn ->
        GeoIP.lookup("github.com")
      end
    end
  end

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
    @freegeoip_test_ip_url "https://freegeoip.net/json/192.30.253.113"
    @freegeoip_test_host_url "https://freegeoip.net/json/github.com"

    def assert_valid_freegeoip_location(location) do
      assert location.ip == "192.30.253.113"
      assert location.city == "San Francisco"
      assert location.region_name == "California"
      assert location.country_code == "US"
      assert location.country_name == "United States"
    end

    setup do
      Application.put_env(:geoip, :provider, :freegeoip)
      Application.put_env(:geoip, :url, "https://freegeoip.net")

      :ok
    end

    test "returns empty result when given localhost" do
      {:ok, %{ip: "127.0.0.1"}} = GeoIP.lookup("localhost")
    end

    test "returns empty result when given localhost ip" do
      {:ok, %{ip: "127.0.0.1"}} = GeoIP.lookup("127.0.0.1")
    end

    test "returns location when given a valid IP address as string" do
      with_mock(HTTPoison, [
        get: fn(@freegeoip_test_ip_url) ->
          {:ok, %HTTPoison.Response{status_code: 200, body: @freegeoip_response_body}}
        end
      ]) do
        {:ok, location} = GeoIP.lookup("192.30.253.113")

        assert_valid_freegeoip_location location
      end
    end

    test "returns location when given a valid IP address as tuple" do
      with_mock(HTTPoison, [
        get: fn(@freegeoip_test_ip_url) ->
          {:ok, %HTTPoison.Response{status_code: 200, body: @freegeoip_response_body}}
        end
      ]) do
        {:ok, location} = GeoIP.lookup({192, 30, 253, 113})

        assert_valid_freegeoip_location location
      end
    end

    test "returns location when given a `conn` struct" do
      with_mock(HTTPoison, [
        get: fn(@freegeoip_test_ip_url) ->
          {:ok, %HTTPoison.Response{status_code: 200, body: @freegeoip_response_body}}
        end
      ]) do
        {:ok, location} = GeoIP.lookup(%{remote_ip: {192, 30, 253, 113}})

        assert_valid_freegeoip_location location
      end
    end

    test "returns location when given a valid host name" do
      with_mock(HTTPoison, [
        get: fn(@freegeoip_test_host_url) ->
          {:ok, %HTTPoison.Response{status_code: 200, body: @freegeoip_response_body}}
        end
      ]) do
        {:ok, location} = GeoIP.lookup("github.com")

        assert_valid_freegeoip_location location
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

  describe "lookup/1 using ipstack" do
    @ipstack_response_body ~s({
      "ip": "192.30.253.113",
      "type": "ipv4",
      "continent_code": "NA",
      "continent_name": "North America",
      "country_code": "US",
      "country_name": "United States",
      "region_code": "CA",
      "region_name": "California",
      "city": "San Francisco",
      "zip": "94107",
      "latitude": 37.7697,
      "longitude": -122.3933,
      "location": {
        "geoname_id": 5391959,
        "capital": "Washington D.C.",
        "languages": [
          {
            "code": "en",
            "name": "English",
            "native": "English"
          }
        ],
        "country_flag": "http://assets.ipstack.com/flags/us.svg",
        "country_flag_emoji": "🇺🇸",
        "country_flag_emoji_unicode": "U+1F1FA U+1F1F8",
        "calling_code": "1",
        "is_eu": false
      },
      "time_zone": {
        "id": "America/Los_Angeles",
        "current_time": "2018-07-10T04:38:57-07:00",
        "gmt_offset": -25200,
        "code": "PDT",
        "is_daylight_saving": true
      },
      "currency": {
        "code": "USD",
        "name": "US Dollar",
        "plural": "US dollars",
        "symbol": "$",
        "symbol_native": "$"
      },
      "connection": {
        "asn": 36459,
        "isp": "GitHub, Inc."
      }
    })

    @ipstack_test_ip_url "https://api.ipstack.com/192.30.253.113?access_key=ipstack-api-key"
    @ipstack_test_host_url "https://api.ipstack.com/github.com?access_key=ipstack-api-key"

    def assert_valid_ipstack_location(location) do
      assert location.ip == "192.30.253.113"
      assert location.city == "San Francisco"
      assert location.region_name == "California"
      assert location.country_code == "US"
      assert location.country_name == "United States"

      assert location.currency.code == "USD"

      assert location.connection.isp == "GitHub, Inc."
    end

    setup do
      Application.put_env(:geoip, :provider, :ipstack)
      Application.put_env(:geoip, :api_key, "ipstack-api-key")

      :ok
    end

    test "returns empty result when given localhost" do
      {:ok, %{ip: "127.0.0.1"}} = GeoIP.lookup("localhost")
    end

    test "returns empty result when given localhost ip" do
      {:ok, %{ip: "127.0.0.1"}} = GeoIP.lookup("127.0.0.1")
    end

    test "returns location when given a valid IP address as string" do
      with_mock(HTTPoison, [
        get: fn(@ipstack_test_ip_url) ->
          {:ok, %HTTPoison.Response{status_code: 200, body: @ipstack_response_body}}
        end
      ]) do
        {:ok, location} = GeoIP.lookup("192.30.253.113")

        assert_valid_ipstack_location location
      end
    end

    test "returns location when given a valid IP address as tuple" do
      with_mock(HTTPoison, [
        get: fn(@ipstack_test_ip_url) ->
          {:ok, %HTTPoison.Response{status_code: 200, body: @ipstack_response_body}}
        end
      ]) do
        {:ok, location} = GeoIP.lookup({192, 30, 253, 113})

        assert_valid_ipstack_location location
      end
    end

    test "returns location when given a `conn` struct" do
      with_mock(HTTPoison, [
        get: fn(@ipstack_test_ip_url) ->
          {:ok, %HTTPoison.Response{status_code: 200, body: @ipstack_response_body}}
        end
      ]) do
        {:ok, location} = GeoIP.lookup(%{remote_ip: {192, 30, 253, 113}})

        assert_valid_ipstack_location location
      end
    end

    test "returns location when given a valid host name" do
      with_mock(HTTPoison, [
        get: fn(@ipstack_test_host_url) ->
          {:ok, %HTTPoison.Response{status_code: 200, body: @ipstack_response_body}}
        end
      ]) do
        {:ok, location} = GeoIP.lookup("github.com")

        assert_valid_ipstack_location location
      end
    end

    test "returns error when given a invalid IP address" do
      with_mock(HTTPoison, [
        get: fn("https://api.ipstack.com/8.8?access_key=ipstack-api-key") ->
          {:ok, %HTTPoison.Response{status_code: 404, body: "404 page not found"}}
        end
      ]) do
        {:error, _} = GeoIP.lookup("8.8")
      end
    end

    test "returns error when given a invalid hostname" do
      with_mock(HTTPoison, [
        get: fn("https://api.ipstack.com/invalidhost?access_key=ipstack-api-key") ->
          {:ok, %HTTPoison.Response{status_code: 404, body: "404 page not found"}}
        end
      ]) do
        {:error, _} = GeoIP.lookup("invalidhost")
      end
    end
  end
end
