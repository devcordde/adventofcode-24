input = File.read!("day09.txt")

replace_dot = fn list ->
  index = Enum.find_index(list, &(&1 == "."))
  index_back = length(list) - (Enum.reverse(list) |> Enum.find_index(fn e -> e != "." end)) - 1
  {el, list} = List.pop_at(list, index_back)
  List.delete_at(list, index) |> List.insert_at(index, el)
end

input
|> String.replace("\n", "")
|> String.split("", trim: true)
|> Enum.map(&String.to_integer/1)
|> Enum.reduce({[], 0, :file}, fn
  0, {blocks, id, :file} -> {blocks, id + 1, :free}
  0, {blocks, id, :free} -> {blocks, id, :file}
  digit, {blocks, id, :file} -> {blocks ++ for(_ <- 1..digit, do: to_string(id)), id + 1, :free}
  digit, {blocks, id, :free} -> {blocks ++ for(_ <- 1..digit, do: "."), id, :file}
end)
|> elem(0)
|> then(fn list ->
  Enum.reduce(1..(Enum.filter(list, &(&1 == ".")) |> Enum.count()), list, fn _, list ->
    replace_dot.(list)
  end)
end)
|> Enum.map(&String.to_integer/1)
|> Enum.with_index()
|> Enum.reduce(0, fn {id, position}, acc -> acc + id * position end)
|> IO.puts()
