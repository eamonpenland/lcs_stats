require IEx

defmodule LcsStats.Replay do
  def replay(file_name, line_count) do
    with {:ok, file} <- File.open(file_name, [:read]),
         do:
            read_lines(file, line_count, [])
            |> LcsStats.EsWriter.persist_payloads
  end

  def read_lines(file, line_count, acc) when line_count <= 1 do
    Enum.reverse([IO.read(file, :line) | acc])
  end
  def read_lines(file, line_count, acc) do
    read_lines(file, line_count - 1, [IO.read(file, :line) | acc])
  end
end
