defmodule LcsStats.EsMigration do
  @elastic_url "http://127.0.0.1:9200"

  def run do
    {:ok, %HTTPoison.Response{status_code: 200}} = build_lcs_stats_index
    {:ok, %HTTPoison.Response{status_code: 200}} = build_raw_lcs_stats_index
  end

  def build_lcs_stats_index do
    index_name = "lcs_stats"
    Elastix.Index.delete(@elastic_url, index_name)
    Elastix.Index.create(@elastic_url, index_name, %{})
    Elastix.Mapping.put(@elastic_url, index_name, "_default_",
                        %{ properties: %{
                          game_id: %{ type: :integer },
                          time: %{ type: :integer },
                          player_stats: %{ type: :object, dynamic: true },
                          source_document: %{ type: :object, dynamic: false }
                        } })
  end

  def build_raw_lcs_stats_index do
    index_name = "raw_lcs_stats"
    type_name = "stat"
    Elastix.Index.delete(@elastic_url, index_name)
    Elastix.Index.create(@elastic_url, index_name, %{})
    Elastix.Mapping.put(@elastic_url, index_name, type_name,
                        %{ properties: %{
                          created_at: %{ type: :date },
                          original_payload: %{ type: :object, dynamic: false }
                        } })
  end
end
