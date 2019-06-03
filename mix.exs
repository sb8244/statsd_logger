defmodule StatsDLogger.MixProject do
  use Mix.Project

  def project do
    [
      app: :statsd_logger,
      version: "1.0.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "StatsDLogger",
      description: "Opens a UDP port and prints out StatsD messages to STDOUT.",
      package: package()
    ]
  end

  def application do
    [
      mod: {StatsDLogger.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    []
  end

  defp package() do
    [
      maintainers: [
        "Steve Bussey"
      ],
      licenses: ["MIT"],
      links: %{github: "https://github.com/sb8244/statsd_logger"},
      files: ~w(lib) ++ ~w(mix.exs README.md)
    ]
  end
end
