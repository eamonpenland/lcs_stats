require IEx

defmodule LcsStats do
  use Application

  def start(_type, _args) do
    LcsStats.Supervisor.start_link
  end
end
