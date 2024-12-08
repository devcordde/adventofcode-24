lines =
  File.read!("day08.txt")
  |> String.split("\n", trim: true)

max = length(lines)

find_antinodes = fn antinodes_by_antenna_pairs ->
  for x <- 0..(max - 1),
      y <- 0..(max - 1),
      frequency = Enum.at(lines, y) |> String.at(x),
      frequency != "." do
    {frequency, {x + 1, y + 1}}
  end
  |> Enum.group_by(&elem(&1, 0), fn {_, loc} -> loc end)
  |> Enum.flat_map(fn {_, locs} ->
    for i <- 0..(length(locs) - 2),
        j <- (i + 1)..(length(locs) - 1) do
      [Enum.at(locs, i), Enum.at(locs, j)]
    end
    |> Enum.flat_map(fn [a1, a2] ->
      antinodes_by_antenna_pairs.(a1, a2)
      |> Enum.filter(fn {x, y} -> x > 0 and x <= max and y > 0 and y <= max end)
    end)
  end)
  |> Enum.uniq()
end

# part 1
find_antinodes.(fn {x1, y1}, {x2, y2} ->
  dx = x1 - x2
  dy = y1 - y2

  [{x1 + dx, y1 + dy}, {x2 - dx, y2 - dy}]
end)
|> length()
|> IO.puts()

# part 2
find_antinodes.(fn {x1, y1}, {x2, y2} ->
  dx = x1 - x2
  dy = y1 - y2

  Enum.reduce(0..max, [], fn i, antinodes ->
    antinodes ++ [{x1 + i * dx, y1 + i * dy}, {x2 - i * dx, y2 - i * dy}]
  end)
end)
|> length()
|> IO.puts()
