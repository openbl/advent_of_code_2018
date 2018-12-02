#!/usr/bin/env elixir

"input.txt"
|> File.stream!
|> Stream.cycle
|> Stream.map(&String.trim/1)
|> Stream.map(&String.to_integer/1)
|> Stream.scan(0, &(&1 + &2))
|> Enum.flat_map_reduce([], fn (x, acc) ->
  if Enum.member?(acc, x), do: {:halt, [x]}, else: {[x], [x | acc]}
end)
|> elem(1)
|> hd
|> IO.inspect

