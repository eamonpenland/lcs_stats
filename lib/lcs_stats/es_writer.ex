require IEx

defmodule LcsStats.EsWriter do
  @elastic_url "http://127.0.0.1:9200"
  @index_name "enriched_lcs_stats"
  @type_name "enriched_stat"

  def build_index do
    Elastix.Index.delete(@elastic_url, @index_name)
    Elastix.Index.create(@elastic_url, @index_name, %{})
    Elastix.Mapping.put(@elastic_url, @index_name, @type_name,
                        %{ properties: %{
                          created_at: %{ type: :date },
                          original_payload: %{ type: :object, dynamic: false }

                        } })
  end

  def persist_payloads(payloads) do
    parse(payloads)
    |> Enum.each(fn(payload) ->
         persist_payload(payload)
       end)
  end

  def parse(raw_payloads) do
    Enum.into(raw_payloads, [], fn(raw_payload) -> Poison.decode!(raw_payload) end)
  end

  def persist_payload(payload) do
    {:ok, %HTTPoison.Response{status_code: 201} } = Elastix.Document.index_new(@elastic_url, @index_name, @type_name, enriched_payload(payload))
  end

  def enriched_payload(payload) do
    %{ created_at: (DateTime.utc_now() |> DateTime.to_unix(:milliseconds)), original_payload: payload}
  end
end
