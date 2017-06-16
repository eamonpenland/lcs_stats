require IEx

defmodule LcsStats.EsWriter do
  use GenEvent

  @elastic_url "http://127.0.0.1:9200"
  @index_name "enriched_lcs_stats"
  @type_name "enriched_stat"

  def handle_event({ :payload, payload }, _state) do
    persist(payload)
  end

  def build_index do
    Elastix.Index.delete(@elastic_url, @index_name)
    Elastix.Index.create(@elastic_url, @index_name, %{})
    Elastix.Mapping.put(@elastic_url, @index_name, @type_name,
                        %{ properties: %{
                          created_at: %{ type: :date },
                          original_payload: %{ type: :object, dynamic: false }

                        } })
  end

  def persist(payloads) when is_list(payloads) do
    Enum.each(payloads, fn(payload) ->
      persist(payload)
    end)
  end
  def persist(payload) do
    LcsStats.EsWriter.parse(payload)
    |> index
  end

  def parse(raw_payload) do
    Poison.decode!(raw_payload)
  end

  def index(payload) do
    {:ok, %HTTPoison.Response{status_code: 201} } = Elastix.Document.index_new(@elastic_url, @index_name, @type_name, enriched_payload(payload))
  end

  def enriched_payload(payload) do
    %{ created_at: (DateTime.utc_now() |> DateTime.to_unix(:milliseconds)), original_payload: payload}
  end
end
