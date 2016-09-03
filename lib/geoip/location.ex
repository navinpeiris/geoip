defmodule GeoIP.Location do
  defstruct [:ip, :country_code, :country_name, :region_code, :region_name, :city, :zip_code, :time_zone, :latitude, :longitude, :metro_code]
end
