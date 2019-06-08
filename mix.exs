defmodule StatsDLogger.MixProject do
  use Mix.Project

  @version "1.1.0"

  def project do
    [
      app: :statsd_logger,
      version: @version,
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "StatsDLogger",
      description: "Opens a UDP port and prints out StatsD messages to STDOUT.",
      package: package(),
      docs: docs()
    ]
  end

  def application do
    [
      mod: {StatsDLogger.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
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

  defp docs() do
    [
      source_ref: "v#{@version}",
      main: "readme",
      extras: [
        "README.md",
      ]
    ]
  end
end
