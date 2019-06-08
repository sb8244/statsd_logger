defmodule StatsDLogger.Formatter.Io do
  def handle(:valid, name, value, _opts) do
    ["StatsD metric: ", :blue, name, " ", :green, value]
    |> IO.ANSI.format()
    |> IO.puts()
  end

  def handle(:invalid, msg, _opts) do
    ["StatsD invalid metric: ", :red, msg]
    |> IO.ANSI.format()
    |> IO.puts()
  end
end
