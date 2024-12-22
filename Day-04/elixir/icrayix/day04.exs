grid =
  for {line, y} <- File.read!("day04.txt") |> String.split("\n") |> Enum.with_index(),
      {cell, x} <- line |> String.split("", trim: true) |> Enum.with_index(),
      into: Map.new(),
      do: {{x, y}, cell}

# part 1
directions = [
  {1, 0},
  {-1, 0},
  {0, 1},
  {0, -1},
  {1, 1},
  {-1, 1},
  {1, -1},
  {-1, -1}
]

grid
|> Enum.reduce(0, fn {{x, y}, cell}, count ->
  Enum.reduce(directions, 0, fn {dx, dy}, count ->
    with "X" <- cell,
         "M" <- Map.get(grid, {x + dx, y + dy}),
         "A" <- Map.get(grid, {x + 2 * dx, y + 2 * dy}),
         "S" <- Map.get(grid, {x + 3 * dx, y + 3 * dy}) do
      count + 1
    else
      _ -> count
    end
  end) + count
end)
|> IO.puts()

# part 2
grid
|> Enum.count(fn {{x, y}, cell} ->
  cell == "A" and
    [Map.get(grid, {x - 1, y - 1}), Map.get(grid, {x + 1, y + 1})] in [["M", "S"], ["S", "M"]] and
    [Map.get(grid, {x + 1, y - 1}), Map.get(grid, {x - 1, y + 1})] in [["M", "S"], ["S", "M"]]
end)
|> IO.puts()
