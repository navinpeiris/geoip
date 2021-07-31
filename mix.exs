defmodule GeoIP.Mixfile do
  use Mix.Project

  @source_url "https://github.com/navinpeiris/geoip"
  @version "0.2.7"

  def project do
    [
      app: :geoip,
      version: @version,
      name: "GeoIP",
      elixir: "~> 1.3",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package(),
      test_coverage: [tool: ExCoveralls]
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {GeoIP, []},
      env: [use_https: true, cache: true, cache_ttl_secs: 3600]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.1"},
      {:cachex, "~> 3.3"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:mock, "~> 0.3.3", only: :test},
      {:excoveralls, "~> 0.14.2", only: :test}
    ]
  end

  defp package do
    [
      description:
        "Lookup the geo location for a given IP address, hostname or Plug.Conn instance",
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Navin Peiris", "Michael Bianco"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url
      }
    ]
  end

  defp docs do
    [
      extras: [
        "CHANGELOG.md": [],
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      assets: "assets",
      logo: "assets/icon.png",
      source_url: @source_url,
      homepage_url: @source_url,
      formatters: ["html"]
    ]
  end
end
