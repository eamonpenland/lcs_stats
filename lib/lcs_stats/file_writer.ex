require IEx

defmodule LcsStats.FileWriter do
  use GenEvent

  @filename "game2.json"

  def handle_event({ :payload, payload, :frame_count, _frame_count }, _state) do
    File.open(@filename, [:append], fn file ->
      IO.binwrite(file, "#{payload}\n")
    end )
  end
end
