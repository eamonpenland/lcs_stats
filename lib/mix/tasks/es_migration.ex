defmodule Mix.Tasks.EsMigration do
  use Mix.Task

  @shortdoc "Rebuilds the elasticsearch index and mapping structure. THIS IS DESTRUCTIVE!"
  def run(_) do
    {:ok, _started} = Application.ensure_all_started(:httpoison)
    LcsStats.EsMigration.run
  end
end
