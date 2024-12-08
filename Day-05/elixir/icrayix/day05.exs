[rules, updates] = File.read!("day05.txt") |> String.split("\n\n")
rules = rules |> String.split("\n") |> Enum.map(&String.split(&1, "|"))
updates = updates |> String.split("\n", trim: true) |> Enum.map(&String.split(&1, ","))

rules_for_update = fn update ->
  rules
  |> Enum.filter(fn rule ->
    Enum.member?(update, Enum.at(rule, 0)) and Enum.member?(update, Enum.at(rule, 1))
  end)
end

is_ordered = fn update ->
  rules_for_update.(update)
  |> Enum.all?(fn rule ->
    first = Enum.find_index(update, &(&1 == Enum.at(rule, 0)))
    second = Enum.find_index(update, &(&1 == Enum.at(rule, 1)))
    first < second
  end)
end

updates
|> Enum.map(fn update ->
  if is_ordered.(update),
    do: Enum.at(update, div(length(update), 2)) |> String.to_integer(),
    else: 0
end)
|> Enum.sum()
|> IO.puts()

updates
|> Enum.reject(fn update -> is_ordered.(update) end)
|> Enum.map(fn update ->
  update
  |> Enum.sort(fn first, second ->
    [r1, _] =
      Enum.find(rules, fn [r1, r2] ->
        (r1 == first and r2 == second) or (r1 == second and r2 == first)
      end)

    r1 == first
  end)
  |> Enum.at(div(length(update), 2))
  |> String.to_integer()
end)
|> Enum.sum()
|> IO.puts()
