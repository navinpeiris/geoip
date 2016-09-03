defmodule GeoIPTest do
  use ExUnit.Case

  alias GeoIP.Location

  describe "lookup/1" do
    test "returns empty result when given localhost" do
      {:ok, %Location{ip: "127.0.0.1"}} = GeoIP.lookup("localhost")
    end

    test "returns empty result when given localhost ip" do
      {:ok, %Location{ip: "127.0.0.1"}} = GeoIP.lookup("127.0.0.1")
    end

    test "returns location when given a valid IP address as string" do
      {:ok, location} = GeoIP.lookup("8.8.8.8")

      assert location.ip == "8.8.8.8"
      assert location.city == "Mountain View"
      assert location.region_name == "California"
      assert location.country_code == "US"
      assert location.country_name == "United States"
    end

    test "returns location when given a valid IP address as tuple" do
      {:ok, location} = GeoIP.lookup({8, 8, 8, 8})

      assert location.ip == "8.8.8.8"
      assert location.city == "Mountain View"
      assert location.region_name == "California"
      assert location.country_code == "US"
      assert location.country_name == "United States"
    end

    test "returns error when given a invalid IP address" do
      {:error, _} = GeoIP.lookup("8.8")
    end

    test "returns location when given a valid host name" do
      {:ok, location} = GeoIP.lookup("google.com")

      assert location.country_code == "US"
      assert location.country_name == "United States"
    end

    test "returns error when given a invalid hostname" do
      {:error, _} = GeoIP.lookup("invalidhost")
    end

    test "returns location when given a `conn` struct" do
      {:ok, location} = GeoIP.lookup(%{remote_ip: {8, 8, 8, 8}})

      assert location.ip == "8.8.8.8"
      assert location.city == "Mountain View"
      assert location.region_name == "California"
      assert location.country_code == "US"
      assert location.country_name == "United States"
    end
  end
end
