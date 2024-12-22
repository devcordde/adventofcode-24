defmodule Equation do
  def solvable?(result, numbers, acc \\ 0, concat)

  def solvable?(result, [n], acc, concat) do
    acc + n == result or acc * n == result or (concat and concat(acc, n) == result)
  end

  def solvable?(result, [n | numbers], acc, concat) do
    solvable?(result, numbers, acc + n, concat) or
      solvable?(result, numbers, if(acc == 0, do: n, else: acc * n), concat) or
      (concat and solvable?(result, numbers, concat(acc, n), concat))
  end

  defp concat(n1, n2), do: n1 * Integer.pow(10, trunc(:math.log10(n2)) + 1) + n2
end

equations =
  File.read!("day07.txt")
  |> String.split("\n", trim: true)
  |> Enum.map(fn equation ->
    [result | numbers] = String.split(equation, [": ", " "]) |> Enum.map(&String.to_integer/1)
    {result, numbers}
  end)

# part 1
equations
|> Enum.filter(fn {result, numbers} -> Equation.solvable?(result, numbers, false) end)
|> Enum.sum_by(&elem(&1, 0))
|> IO.puts()

# part 2
equations
|> Enum.filter(fn {result, numbers} -> Equation.solvable?(result, numbers, true) end)
|> Enum.sum_by(&elem(&1, 0))
|> IO.puts()
