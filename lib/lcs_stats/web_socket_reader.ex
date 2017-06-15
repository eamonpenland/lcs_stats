require IEx

defmodule LcsStats.WebSocketReader do
  use WebSockex
  require Logger

  @url "ws://livestats.proxy.lolesports.com/stats?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ2IjoiMS4wIiwiamlkIjoiY2M3ZTI2M2QtZjkwMy00OWUyLWE4ZjgtZjAwZjI1N2Y2YWI3IiwiaWF0IjoxNDk3MjAzNzIyMjg1LCJleHAiOjE0OTc4MDg1MjIyODUsIm5iZiI6MTQ5NzIwMzcyMjI4NSwiY2lkIjoiYTkyNjQwZjI2ZGMzZTM1NGI0MDIwMjZhMjA3NWNiZjMiLCJzdWIiOnsiaXAiOiIyMDkuNi41NS43MCIsInVhIjoiTW96aWxsYS81LjAgKE1hY2ludG9zaDsgSW50ZWwgTWFjIE9TIFggMTBfMTJfNSkgQXBwbGVXZWJLaXQvNTM3LjM2IChLSFRNTCwgbGlrZSBHZWNrbykgQ2hyb21lLzU4LjAuMzAyOS4xMTAgU2FmYXJpLzUzNy4zNiJ9LCJyZWYiOlsid2F0Y2guKi5sb2xlc3BvcnRzLmNvbSJdLCJzcnYiOlsibGl2ZXN0YXRzLXYxLjAiXX0.OTwFuh8cRcTemXybQRn3qMu4p0Pza4WCH8s7cJcUN-E"

  def start_link do
    WebSockex.start_link(@url, __MODULE__, :state)
  end

  def echo(client, message) do
    Logger.info("Sending message: #{message}")
    WebSockex.send_frame(client, {:text, message})
  end

  def send_frame(pid, {:text, _msg} = frame) do
    WebSockex.send_frame(pid, frame)
  end

  def handle_frame({:text, msg}, :state) do
    LcsStats.Publisher.publish(msg, @url)
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
