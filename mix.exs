defmodule GeoIP.Mixfile do
  use Mix.Project

  def project do
    [
      app: :geoip,
      version: "0.2.6",
      name: "GeoIP",
      description:
        "Lookup the geo location for a given IP address, hostname or Plug.Conn instance",
      package: package(),
      source_url: "https://github.com/navinpeiris/geoip",
      homepage_url: "https://github.com/navinpeiris/geoip",
      elixir: "~> 1.5",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [extras: ["README.md"]],
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
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:mock, "~> 0.3.3", only: :test},
      {:excoveralls, "~> 0.13.3", only: :test}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Navin Peiris", "Michael Bianco"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/navinpeiris/geoip"}
    ]
  end
end
