defmodule StatsDLogger do
  @moduledoc false

  use GenServer
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(port: port) do
    {:ok, _port} = :gen_udp.open(port, active: true)

    {:ok, {}}
  end

  def handle_info({:udp, _port, _from, _from_port, msg}, state) do
    msg
    |> to_string()
    |> String.split(":", parts: 2)
    |> case do
      [name, value] ->
        ["StatsD metric: ", :blue, name, " ", :green, value]
        |> IO.ANSI.format()
        |> IO.puts()

      _ ->
        ["StatsD invalid metric: ", :red, msg]
        |> IO.ANSI.format()
        |> IO.puts()
    end

    {:noreply, state}
  end
end
