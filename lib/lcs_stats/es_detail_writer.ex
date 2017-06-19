require IEx

defmodule LcsStats.EsDetailWriter do
  use GenEvent

  @elastic_url "http://127.0.0.1:9200"
  @index_name "enriched_lcs_stats"
  @type_name "enriched_stat"

  def handle_event({ :payload, payload }, _state) do
    persist(payload)
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
    IEx.pry
    %{ original_payload: payload }
  end

  def index(payload) do
    {:ok, %HTTPoison.Response{status_code: 201} } = Elastix.Document.index_new(@elastic_url, @index_name, @type_name, enrich(payload))
  end
end
