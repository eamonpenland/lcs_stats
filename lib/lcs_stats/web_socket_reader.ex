require IEx

defmodule LcsStats.WebSocketReader do
  use WebSockex
  require Logger

  def start_link(url) do
    WebSockex.start_link(url, __MODULE__, :state)
  end

  def echo(client, message) do
    Logger.info("Sending message: #{message}")
    WebSockex.send_frame(client, {:text, message})
  end

  def send_frame(pid, {:text, _msg} = frame) do
    WebSockex.send_frame(pid, frame)
  end

  def handle_frame({:text, msg}, :state) do
    LcsStats.Publisher.publish(msg)
    {:ok, :state}
  end

  def handle_disconnect(%{reason: {:local, reason}}, state) do
    Logger.info("Local close with reason: #{inspect reason}")
    {:ok, state}
  end
  def handle_disconnect(disconnect_map, state) do
    Logger.info("Other disconnect: #{inspect disconnect_map}")
    super(disconnect_map, state)
  end
end
