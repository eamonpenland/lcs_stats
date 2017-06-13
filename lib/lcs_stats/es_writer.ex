defmodule LcsStats.EsWriter do
  @elastic_url "http://127.0.0.1:9200"
  @index "lcs_stats"
  @raw_type "raw"
  @processed_type "processed"

  def persist_payload(payload) do
    processed_payload = processed_payload(payload)

    Elastix.Document.index(@elastic_url, @index, @raw_type, nil, processed_payload)
  end

  def processed_payload(raw_payload) do
    Poison.decode!(raw_payload)
  end
end
