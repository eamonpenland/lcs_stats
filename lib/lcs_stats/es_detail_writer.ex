defmodule LcsStats.EsDetailWriter do
  use GenStage

  alias LcsStats.EsDetailWriter.Enricher

  @elastic_url "http://127.0.0.1:9200"
  @index_name "lcs_stats"
  @type_name "lcs_stat"

  def start_link(_) do
    GenStage.start_link(__MODULE__, :ok)
  end

  def init(_) do
    {:consumer, :ok, subscribe_to: [LcsStats.Publisher]}
  end

  def handle_events(frames, _from, state) do
    persist(frames)
    {:noreply, [], state}
  end

  def persist(payloads) when is_list(payloads) do
    Enum.each(payloads, fn(payload) ->
      persist(payload)
    end)
  end
  def persist(payload) do
    LcsStats.EsWriter.parse(payload)
    |> enrich
    |> index
  end

  def parse(raw_payload) do
    Poison.decode!(raw_payload)
  end

  def enrich(payload) do
    Enricher.enrich(payload)
  end

  def index(payload) do
    {:ok, %HTTPoison.Response{status_code: 201} } = Elastix.Document.index_new(@elastic_url, @index_name, @type_name, payload)
  end
end
