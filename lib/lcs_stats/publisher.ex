defmodule LcsStats.Publisher do
  use GenStage

  def start_link(_) do
    GenStage.start_link(__MODULE__, :ok, [name: LcsStats.Publisher])
  end

  def publish(frame) do
    GenStage.call(__MODULE__, {:publish, frame})
  end

  def init(_) do
    {:producer, :ok}
  end

  def handle_call({:publish, frame}, _from, state) do
    {:reply, :ok, [frame], state}
  end

  def handle_demand(_demand, state) do
    {:noreply, [], state} # We don't care about the demand
  end

end
