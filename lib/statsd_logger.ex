defmodule StatsDLogger do
  @moduledoc false

  use GenServer
  require Logger

  def start_link(opts) do
    opts = Keyword.merge([send_to: self()], opts)
    GenServer.start_link(__MODULE__, opts)
  end

  @formatter_mapping %{
    io: StatsDLogger.Formatter.Io,
    send: StatsDLogger.Formatter.Send
  }

  def init(opts) do
    port = Keyword.fetch!(opts, :port)
    formatter_name = Keyword.get(opts, :formatter, :io)
    formatter = Map.fetch!(@formatter_mapping, formatter_name)

    {:ok, _port} = :gen_udp.open(port, active: true)

    {:ok, {formatter, opts}}
  end

  def handle_info({:udp, _port, _from, _from_port, msg}, state = {formatter, opts}) do
    msg
    |> to_string()
    |> String.split(":", parts: 2)
    |> case do
      [name, value] ->
        formatter.handle(:valid, name, value, opts)

      _ ->
        formatter.handle(:invalid, msg, opts)
    end

    {:noreply, state}
  end
end
