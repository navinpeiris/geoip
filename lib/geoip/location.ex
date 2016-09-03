defmodule GeoIP.Location do
  defstruct [:ip, :country_code, :country_name, :region_code, :region_name, :city, :zip_code, :time_zone, :latitude, :longitude, :metro_code]
  #
#   {
# "ip": "124.43.73.64",
# "country_code": "LK",
# "country_name": "Sri Lanka",
# "region_code": "1",
# "region_name": "Western Province",
# "city": "Colombo",
# "zip_code": "00800",
# "time_zone": "Asia/Colombo",
# "latitude": 6.9177,
# "longitude": 79.8742,
# "metro_code": 0
# }
end
