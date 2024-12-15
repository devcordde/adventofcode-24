machines =
  File.read!("day13.txt")
  |> String.split("\n\n", trim: true)
  |> Enum.map(fn machine ->
    [
      "Button A: X+" <> <<ax::2-binary>> <> ", Y+" <> <<ay::2-binary>>,
      "Button B: X+" <> <<bx::2-binary>> <> ", Y+" <> <<by::2-binary>>,
      "Prize: " <> p
    ] = String.split(machine, "\n", trim: true)

    [px, py] = String.split(p, ["X=", ", Y="], trim: true)

    %{
      a: {String.to_integer(ax), String.to_integer(ay)},
      b: {String.to_integer(bx), String.to_integer(by)},
      p: {String.to_integer(px), String.to_integer(py)}
    }
  end)

calculate_token_sum = fn machines ->
  machines
  |> Enum.map(fn %{a: {ax, ay}, b: {bx, by}, p: {px, py}} ->
    a = (px - bx * (py / by)) / ax / (1 - bx * (ay / by) / ax)
    b = (px - ax * (py / ay)) / bx / (1 - ax * (by / ay) / bx)

    if abs(round(a) - a) <= 0.001 and abs(round(b) - b) <= 0.001, do: round(a * 3 + b), else: 0
  end)
  |> Enum.sum()
end

# part 1
machines
|> calculate_token_sum.()
|> IO.puts()

# part 2
machines
|> Enum.map(fn %{a: {ax, ay}, b: {bx, by}, p: {px, py}} ->
  %{a: {ax, ay}, b: {bx, by}, p: {px + 10_000_000_000_000, py + 10_000_000_000_000}}
end)
|> calculate_token_sum.()
|> IO.puts()
