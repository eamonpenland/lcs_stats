require IEx

defmodule LcsStats do
  use Application

  def start(_type, _args) do
    LcsStats.start_link
  end

  def start_link do
    Agent.start_link(fn -> Socket.Web.connect!("echo.websocket.org") end, name: __MODULE__)
  end

  def socket do
    Agent.get(__MODULE__, fn socket -> socket end)
  end

  def put(text="test") do
    socket |> Socket.Web.send!({ :text, text})
    # case socket |> Socket.Web.recv! do
    #   {:text, data} ->
    #     IO.puts(data)
    #   {:ping, _} ->
    #     socket |> Socket.Web.send!({:pong, ""})
    # end
    # listen
  end

  def listen do
    case socket |> Socket.Web.recv! do
      {:text, data} ->
        IO.puts(data)
      {:ping, _ } ->
        socket |> Socket.Web.send!({:pong, ""})
    end
    listen
  end
end
