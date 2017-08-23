defmodule LcsStats.FileWriter do
  use GenStage

  @filename "game2.json"

  def start_link() do
    GenStage.start_link(__MODULE__, :ok)
  end

  def init(_) do
    {:consumer, :ok, subscribe_to: [LcsStats.Publisher]}
  end

  def handle_event(frames, state) do
    File.open(@filename, [:append], fn file ->
      IO.binwrite(file, "#{payload}\n")
    end )
    {:noreply, [], state}
  end
end
