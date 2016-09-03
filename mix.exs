defmodule GeoIP.Mixfile do
  use Mix.Project

  def project do
    [app: :geoip,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger, :httpoison, :cachex],
     mod: {GeoIP, []}]
  end

  defp deps do
    [{:httpoison, "~> 0.9"},
     {:poison, "~> 2.0"},
     {:cachex, "~> 1.2"}]
  end
end
