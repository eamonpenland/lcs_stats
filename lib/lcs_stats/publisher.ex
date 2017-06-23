require IEx

defmodule LcsStats.Publisher do

  def start_link do
    {:ok, pid} = GenEvent.start_link([name: __MODULE__])
    # GenEvent.add_handler(__MODULE__, LcsStats.FileWriter, [])
    GenEvent.add_handler(__MODULE__, LcsStats.EsWriter, [])
    GenEvent.add_handler(__MODULE__, LcsStats.EsDetailWriter, [])
    {:ok, pid}
  end

  def publish(frame, source) do
    GenEvent.notify(__MODULE__, { :payload, frame })
  end
end
