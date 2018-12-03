#!/usr/bin/env elixir

ids = "input.txt"
|> File.stream!
|> Stream.map(&String.trim/1)
|> Enum.to_list

ids
|> Enum.with_index
|> Enum.flat_map(fn {first_id, idx} ->
  ids
  |> Enum.slice(idx+1..-1)
  |> Enum.map(fn second_id -> 
    String.myers_difference(first_id, second_id) 
    |> Enum.reduce("", fn
      ({:eq, value}, acc) -> acc <> value
      (_, acc) -> acc
    end)
  end)
end)
|> Enum.map(fn diff -> {diff, String.length(diff)} end)
|> Enum.sort_by(fn {_diff, length} -> length end, &>/2)
|> Enum.take(1)
|> Enum.map(&elem(&1, 0))
|> Enum.each(&IO.puts/1)

