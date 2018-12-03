#!/usr/bin/env elixir

{twos, threes} = "input.txt"
                 |> File.stream!
                 |> Stream.map(&String.trim/1)
                 |> Stream.map(&String.graphemes/1)
                 |> Stream.map(fn id ->
                   id
                   |> Enum.reduce(%{}, fn (char, acc) ->
                     Map.put(acc, char, Map.get(acc, char, 0)+1)
                   end)
                   |> Enum.group_by(fn {_letter, count} -> count end, fn {letter, _count} -> letter end)
                   |> Enum.filter(fn {count, _letters} -> count == 2 || count == 3  end)
                   |> Enum.map(fn {count, _letters} -> count end)
                 end)
                 |> Enum.reduce({0, 0}, fn 
                   ([], {twos, threes}) -> {twos, threes}
                   ([2], {twos, threes}) -> {twos+1, threes}
                   ([3], {twos, threes}) -> {twos, threes+1}
                   ([2, 3], {twos, threes}) -> {twos+1, threes+1}
                 end)

IO.inspect(twos * threes)
