defmodule StatsDLogger.Formatter.Send do
  def handle(:valid, name, value, opts) do
    pid = Keyword.fetch!(opts, :send_to)
    send(pid, {:statsd_recv, name, value})
  end

  def handle(:invalid, msg, opts) do
    pid = Keyword.fetch!(opts, :send_to)
    send(pid, {:statsd_recv_invalid, to_string(msg)})
  end
end
