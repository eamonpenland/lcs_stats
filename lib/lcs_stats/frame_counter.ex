defmodule LcsStats.FrameCounter do
  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get_and_increment(frame_origination_url) do
    Agent.get_and_update(__MODULE__, fn map ->
      Map.get_and_update(map, frame_origination_url,
                         fn
                           current_count when is_nil(current_count) -> { 0, 1 }
                           current_count -> { current_count, current_count + 1 }
                         end )
    end)
  end
end
