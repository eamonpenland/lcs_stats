defmodule LcsStats.EsDetailWriter.Enricher do
  def enrich(payload) do
    payload
    |> actual_payload
    |> rebuild(payload)
  end

  defp rebuild(actual_payload, original_payload) do
    %{ 
      game_id: game_id(original_payload),
      time: Map.get(actual_payload, "t"),
      player_stats: Map.get(actual_payload, "playerStats"),
      source_document: actual_payload
    }
  end

  defp game_id(payload) do
    {game_id, _value} = breakdown_game_id(payload)
    game_id
  end

  defp actual_payload(payload) do
    {_game_id, actual_payload} = breakdown_game_id(payload)
    actual_payload
  end

  defp breakdown_game_id(payload) do
    [breakdown | _tail] = Map.to_list(payload)
    breakdown
  end
end
