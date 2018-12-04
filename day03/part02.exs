#!/usr/bin/env elixir

IO.stream(:stdio, :line)
|> Enum.map(&String.trim/1)
|> Enum.to_list
|> Enum.map(fn line -> Regex.named_captures(~r/^#(?<id>\d+) @ (?<x_start>\d+),(?<y_start>\d+): (?<x_width>\d+)x(?<y_width>\d+)$/, line) end)
|> Enum.map(&Map.to_list/1)
|> Enum.map(fn claim ->
  claim
  |> Enum.map(fn {k, v} -> {String.to_atom(k), String.to_integer(v)} end)
  |> Map.new
end)
|> Enum.reduce(%{}, fn (claim, acc) ->
  claim.x_start..claim.x_start+claim.x_width-1
  |> Enum.reduce(acc, fn (x, xacc) ->
    claim.y_start..claim.y_start+claim.y_width-1
    |> Enum.reduce(xacc, fn (y, yacc) -> Map.put(yacc, {x, y}, [ claim.id | Map.get(yacc, {x, y}, []) ]) end)
  end)
end)
|> Enum.reduce(%{overlaps: MapSet.new(), uniques: MapSet.new()}, fn
  ({_position, ids}, counts) when length(ids) == 1 ->
    Map.put(counts, :uniques, MapSet.put(Map.get(counts, :uniques), hd(ids)))
  ({_position, ids}, counts) when length(ids) > 1 ->
    Map.put(counts, :overlaps, Enum.reduce(ids, Map.get(counts, :overlaps), &(MapSet.put(&2, &1))))
end)
|> Map.values
|> Enum.reduce(&(MapSet.difference(&1, &2)))
|> Enum.each(&IO.puts/1)

