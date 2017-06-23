require IEx

defmodule LcsStats.EsDetailWriter.Enricher do
  def enrich(payload) do
    payload
    |> actual_payload
    |> rebuild
    |> (fn (doc) -> [game_id(payload), doc] end).()
  end

  def rebuild(a_payload) do
    %{
      time: Map.fetch!(a_payload, "t"),
      player_stats: Map.fetch!(a_payload, "playerStats"),
      source_document: a_payload
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
