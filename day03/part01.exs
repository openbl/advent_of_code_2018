#!/usr/bin/env elixir

IO.stream(:stdio, :line)
|> Stream.map(&String.trim/1)
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
|> Enum.filter(fn {_position, ids} -> Enum.count(ids) >= 2 end)
|> Enum.count
|> IO.puts

