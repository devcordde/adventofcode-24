defmodule Warehouse do
  def make_moves(map, moves) do
    Enum.reduce(moves, map, fn move, map ->
      {pos, _} = Enum.find(map, &(elem(&1, 1) == "@"))
      {map, _} = move(map, pos, move)
      map
    end)
  end

  defp move(map, pos, move) do
    new_pos =
      case move do
        ">" -> {elem(pos, 0) + 1, elem(pos, 1)}
        "<" -> {elem(pos, 0) - 1, elem(pos, 1)}
        "^" -> {elem(pos, 0), elem(pos, 1) - 1}
        "v" -> {elem(pos, 0), elem(pos, 1) + 1}
      end

    cell = Map.get(map, pos)
    new_cell = Map.get(map, new_pos)

    case new_cell do
      nil ->
        {Map.delete(map, pos) |> Map.put(new_pos, cell), true}

      "#" ->
        {map, false}

      "O" ->
        case move(map, new_pos, move) do
          {map, false} -> {map, false}
          {map, true} -> {Map.delete(map, pos) |> Map.put(new_pos, cell), true}
        end

      _ ->
        if move == "^" or move == "v" do
          with {map1, moved1} <- move(map, new_pos, move),
               new_pos2 =
                 {elem(new_pos, 0) + if(new_cell == "[", do: 1, else: -1), elem(new_pos, 1)},
               {map2, moved2} <- move(map1, new_pos2, move),
               true <- moved1 and moved2 do
            {Map.delete(map2, pos) |> Map.put(new_pos, cell), true}
          else
            _ -> {map, false}
          end
        else
          case move(map, new_pos, move) do
            {map, false} -> {map, false}
            {map, true} -> {Map.delete(map, pos) |> Map.put(new_pos, cell), true}
          end
        end
    end
  end
end

[mapInput, moves] = File.read!("day15.txt") |> String.split("\n\n")
moves = String.replace(moves, "\n", "") |> String.split("", trim: true)

# part 1
map =
  for {line, y} <- String.split(mapInput, "\n") |> Enum.with_index(),
      {cell, x} <- String.split(line, "", trim: true) |> Enum.with_index(),
      cell != ".",
      into: Map.new(),
      do: {{x, y}, cell}

Warehouse.make_moves(map, moves)
|> Map.filter(&(elem(&1, 1) == "O"))
|> Enum.map(fn {{x, y}, _} -> x + y * 100 end)
|> Enum.sum()
|> IO.puts()

# part 2
map =
  for {line, y} <- String.split(mapInput, "\n") |> Enum.with_index(),
      {cell, x} <-
        line
        |> String.replace("#", "##")
        |> String.replace("O", "[]")
        |> String.replace(".", "..")
        |> String.replace("@", "@.")
        |> String.split("", trim: true)
        |> Enum.with_index(),
      cell != ".",
      into: Map.new(),
      do: {{x, y}, cell}

Warehouse.make_moves(map, moves)
|> Map.filter(&(elem(&1, 1) == "["))
|> Enum.map(fn {{x, y}, _} -> x + y * 100 end)
|> Enum.sum()
|> IO.puts()
