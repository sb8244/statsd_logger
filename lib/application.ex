defmodule StatsDLogger.Application do
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    children =
      case get_port() do
        port when is_number(port) ->
          [
            {StatsDLogger, [port: port]}
          ]

        _ ->
          Logger.debug("#{__MODULE__} not starting due to missing port config")
          []
      end

    opts = [strategy: :one_for_one, name: StatsDLogger.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp get_port() do
    Application.get_env(:statsd_logger, :port)
  end
end
