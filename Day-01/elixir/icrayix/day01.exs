[left, right] =
  File.read!("day01.txt")
  |> String.split("\n", trim: true)
  |> Enum.reduce([[], []], fn line, [ll, rl] ->
    [left, right] = String.split(line, "   ")
    [[String.to_integer(left) | ll], [String.to_integer(right) | rl]]
  end)

# part 1
[left, right]
|> Enum.map(&Enum.sort(&1, :asc))
|> Enum.zip()
|> Enum.map(fn {left, right} ->
  abs(left - right)
end)
|> Enum.sum()
|> IO.puts()

# part 2
left
|> Enum.map(fn number ->
  (Enum.filter(right, &(&1 == number)) |> Enum.count()) * number
end)
|> Enum.sum()
|> IO.puts()
