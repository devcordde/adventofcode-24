defmodule Guard do
  def path_length(obstacles, pos) do
    walk(obstacles, pos, 0, MapSet.new()) |> MapSet.new(fn {pos, _} -> pos end) |> MapSet.size()
  end

  def looping_obstacles(obstacles, pos) do
    walk(obstacles, pos, 0, MapSet.new())
    |> MapSet.new(fn {pos, _} -> pos end)
    |> Task.async_stream(fn obstacle ->
      Map.put(obstacles, obstacle, "#") |> walk(pos, 0, MapSet.new()) == :loop
    end)
    |> Enum.count(&elem(&1, 1))
  end

  defp walk(obstacles, pos, direction, visited) do
    if {pos, direction} in visited do
      :loop
    else
      visited = MapSet.put(visited, {pos, direction})

      case Map.get(obstacles, next(pos, direction)) do
        nil -> visited
        "." -> walk(obstacles, next(pos, direction), direction, visited)
        "#" -> walk(obstacles, pos, rem(direction + 90, 360), visited)
      end
    end
  end

  defp next({x, y}, 0), do: {x, y - 1}
  defp next({x, y}, 90), do: {x + 1, y}
  defp next({x, y}, 180), do: {x, y + 1}
  defp next({x, y}, 270), do: {x - 1, y}
end

map =
  for {line, y} <- File.read!("day06.txt") |> String.split("\n") |> Enum.with_index(),
      {cell, x} <- line |> String.split("", trim: true) |> Enum.with_index(),
      into: Map.new(),
      do: {{x, y}, cell}

[{pos, _}] = Enum.filter(map, fn {_, cell} -> cell == "^" end)
obstacles = Map.replace(map, pos, ".")

# part 1
Guard.path_length(obstacles, pos) |> IO.puts()

# part 2
Guard.looping_obstacles(obstacles, pos) |> IO.puts()
