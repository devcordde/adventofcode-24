input = File.read!("day09.txt")

blocks =
  input
  |> String.replace("\n", "")
  |> String.split("", trim: true)
  |> Enum.map(&String.to_integer/1)
  |> Enum.reduce({[], 0, :file}, fn
    0, {blocks, id, :file} -> {blocks, id + 1, :free}
    0, {blocks, id, :free} -> {blocks, id, :file}
    digit, {blocks, id, :file} -> {[{digit, id}] ++ blocks, id + 1, :free}
    digit, {blocks, id, :free} -> {[{digit, nil}] ++ blocks, id, :file}
  end)
  |> elem(0)
  |> Enum.reverse()

# part 1
expanded =
  blocks |> Enum.flat_map(fn {length, id} -> for _ <- 1..length, do: id end)

rev = Enum.reverse(expanded) |> Enum.filter(& &1)

expanded
|> Enum.take(Enum.filter(expanded, & &1) |> Enum.count())
|> Enum.reduce({[], 0}, fn
  nil, {blocks, pos} -> {[Enum.at(rev, pos)] ++ blocks, pos + 1}
  block, {blocks, pos} -> {[block] ++ blocks, pos}
end)
|> elem(0)
|> Enum.reverse()
|> Enum.with_index()
|> Enum.reduce(0, fn
  {0, _}, acc -> acc
  {block, pos}, acc -> acc + block * pos
end)
|> IO.puts()

# part 2
blocks
|> Enum.filter(&elem(&1, 1))
|> Enum.sort_by(&elem(&1, 1), :desc)
|> Enum.reduce(blocks, fn {length, id}, blocks ->
  with free_offset <- Enum.find_index(blocks, &(elem(&1, 1) == nil and elem(&1, 0) >= length)),
       false <- is_nil(free_offset),
       free_length = Enum.at(blocks, free_offset) |> elem(0),
       prev_offset = Enum.find_index(blocks, &(elem(&1, 1) == id)),
       true <- prev_offset > free_offset do
    blocks
    |> List.replace_at(free_offset, {length, id})
    |> List.replace_at(prev_offset, {length, nil})
    |> List.insert_at(free_offset + 1, {free_length - length, nil})
  else
    _ ->
      blocks
  end
end)
|> Enum.reduce({0, 0}, fn
  {length, nil}, {sum, pos} -> {sum, pos + length}
  {length, id}, {sum, pos} -> {sum + Enum.sum(pos..(pos + length - 1)) * id, pos + length}
end)
|> elem(0)
|> IO.puts()
