reports =
  File.read!("day02.txt")
  |> String.split("\n", trim: true)
  |> Enum.map(fn report -> String.split(report, " ") |> Enum.map(&String.to_integer/1) end)

is_safe = fn report ->
  {deltas, _} =
    Enum.reduce(report, {[], -1}, fn
      level, {[], -1} -> {[], level}
      level, {acc, prev} -> {acc ++ [level - prev], level}
    end)

  Enum.all?(deltas, &(&1 > 0 and &1 < 4)) or Enum.all?(deltas, &(-&1 > 0 and -&1 < 4))
end

# part 1
reports
|> Enum.filter(&is_safe.(&1))
|> Enum.count()
|> IO.puts()

# part 2
reports
|> Enum.filter(fn report ->
  Enum.reduce_while(0..length(report), false, fn i, _ ->
    if List.delete_at(report, i) |> is_safe.(), do: {:halt, true}, else: {:cont, false}
  end)
end)
|> Enum.count()
|> IO.puts()
