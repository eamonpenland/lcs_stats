require Logger

defmodule LcsStats.EsWriter do
  use GenStage

  @elastic_url "http://127.0.0.1:9200"
  @index_name "raw_lcs_stats"
  @type_name "stat"

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
    for payload <- payloads, do: persist(payload)
  end
  def persist(payload) do
    LcsStats.EsWriter.parse(payload)
    |> index
  end

  def parse(raw_payload) do
    Poison.decode!(raw_payload)
  end

  def index(payload) do
    Elastix.Document.index_new(@elastic_url, @index_name, @type_name, enriched_payload(payload))
    |> handle_index_result
  end

  # I'm rule of 3-ing handle_index_result/1 method here and in es_detail_writer.ex
  def handle_index_result({:ok, %HTTPoison.Response{status_code: 201}}) do
    {:ok, 201}
  end

  def handle_index_result({:error, %HTTPoison.Error{id: nil, reason: :econnrefused}}) do
    Logger.error "Error connecting to elasticsearch. Is elasticsearch running and accessible?"
    {:ok, 503}
  end

  def enriched_payload(payload) do
    %{ created_at: (DateTime.utc_now() |> DateTime.to_unix(:milliseconds)), original_payload: payload}
  end
end
