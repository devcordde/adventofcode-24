input = File.read!("day03.txt")

partOne = fn input ->
  Regex.scan(~r/mul\(([0-9]*),([0-9]*)\)/, input, capture: :all_but_first)
  |> Enum.map(fn numbers ->
    numbers
    |> Enum.map(&String.to_integer/1)
    |> Enum.product()
  end)
  |> Enum.sum()
end

partOne.(input)
|> IO.puts()

markers =
  [
    :keep
    | Regex.scan(~r/do\(\)|don't\(\)/, input, capture: :first)
      |> Enum.map(fn
        ["do()"] -> :keep
        ["don't()"] -> :drop
      end)
  ]

input
|> String.split(["do()", "don't()"])
|> Enum.zip(markers)
|> Enum.map(fn
  {part, :keep} -> partOne.(part)
  {_, :drop} -> 0
end)
|> Enum.sum()
|> IO.puts()
