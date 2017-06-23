require IEx

defmodule LcsStats.EsDetailWriter.Enricher do
  def enrich(payload) do
    payload
    |> actual_payload
    |> rebuild
  end

  def rebuild(actual_payload) do
    %{
      time: Map.fetch!(actual_payload, "t"),
      player_stats: Map.fetch!(actual_payload, "playerStats"),
      source_document: actual_payload
    }
  end

  def game_id(payload) do
    {game_id, _value} = breakdown_game_id(payload)
    game_id
  end

  def actual_payload(payload) do
    {_game_id, actual_payload} = breakdown_game_id(payload)
    actual_payload
  end

  def breakdown_game_id(payload) do
    [breakdown | _tail] = Map.to_list(payload)
    breakdown
  end
end
