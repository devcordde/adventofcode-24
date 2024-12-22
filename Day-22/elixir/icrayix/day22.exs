mix = fn new, old -> Bitwise.bxor(new, old) end
prune = fn secret -> rem(secret, 16_777_216) end

next_secret = fn prev ->
  secret = (prev * 64) |> mix.(prev) |> prune.()
  secret = Integer.floor_div(secret, 32) |> mix.(secret) |> prune.()
  (secret * 2048) |> mix.(secret) |> prune.()
end

evolutions =
  File.read!("day22.txt")
  |> String.split("\n", trim: true)
  |> Enum.map(&String.to_integer/1)
  |> Enum.map(fn secret ->
    Enum.reduce(1..2000, {{Map.new(), []}, secret}, fn _, {{seq_map, seq}, prev} ->
      secret = next_secret.(prev)

      seq = Enum.take([rem(secret, 10) - rem(prev, 10)] ++ seq, 4)
      seq_map = Map.put_new(seq_map, seq, rem(secret, 10))
      {{seq_map, seq}, secret}
    end)
  end)

# part 1
evolutions |> Enum.map(&elem(&1, 1)) |> Enum.sum() |> IO.puts()

# part 2
Enum.reduce(evolutions, Map.new(), fn {{seq_map, _}, _}, map ->
  seq_map
  |> Enum.reduce(map, fn {seq, prize}, map ->
    Map.update(map, seq, prize, &(&1 + prize))
  end)
end)
|> Map.values()
|> Enum.max()
|> IO.puts()
