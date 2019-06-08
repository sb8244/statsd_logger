# StatsDLogger

StatsDLogger prints (to stdout) any StatsD metrics sent to it. It is a simple UDP server which
looks for messages separated by a single `:`.

This is meant for development purposes and doesn't serve any production value.

## Installation

This package can be installed by adding `statsd_logger` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:statsd_logger, "~> 1.0.0"}
  ]
end
```

## Usage

StatsDLogger will automatically start when a port is configured for it:

```elixir
config :statsd_logger, port: 8126
```

You can manually start StatsDLogger in your supervision tree as well:

```elixir
StatsDLogger.start_link(port: 8126)
```

You will see STDOUT printed messages. This is done to allow the message to be
seen separate of your other logs in development.

### Test Usage

It's possible to use StatsDLogger for tests. You can do so by using the `:send` formatter. This will deliver
messages to the current process. See this sample for an example of how to use it:

```elixir
test "valid / invalid messages are handled" do
  StatsDLogger.start_link(port: 8130, formatter: :send)

  send_event("a:1")
  send_event("a:2|c")
  send_event("invalid")
  Process.sleep(50)
  assert_received {:statsd_recv, "a", "1"}
  assert_received {:statsd_recv, "a", "2|c"}
  assert_received {:statsd_recv_invalid, "invalid"}
end
```
