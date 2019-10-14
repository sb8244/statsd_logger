defmodule IntegrationTest do
  use ExUnit.Case, async: false

  @port 8130

  def send_event(msg) do
    {:ok, port} = :gen_udp.open(0)
    :gen_udp.send(port, 'localhost', @port, msg)
    :ok = :gen_udp.close(port)
  end

  describe "starting" do
    test "an already in used port will log an error" do
      assert {:ok, _pid} = StatsDLogger.start_link(port: @port)
      assert StatsDLogger.start_link(port: @port) == :ignore
    end
  end

  describe "io formatter" do
    # Visual test due to how STDIO capture works for global processes
    test "valid / invalid messages are handled" do
      StatsDLogger.start_link(port: @port)

      send_event("a:1")
      send_event("a:2")
      send_event("invalid")
      Process.sleep(50)
    end

    test "io is a valid formatter option" do
      StatsDLogger.start_link(port: @port, formatter: :io)

      send_event("a:1")
      send_event("a:2")
      send_event("invalid")
      Process.sleep(50)
    end
  end

  describe "send formatter" do
    test "valid / invalid messages are handled" do
      StatsDLogger.start_link(port: @port, formatter: :send)

      send_event("a:1")
      send_event("a:2|c")
      send_event("invalid")

      assert_receive {:statsd_recv, "a", "1"}
      assert_receive {:statsd_recv, "a", "2|c"}
      assert_receive {:statsd_recv_invalid, "invalid"}
    end
  end
end
