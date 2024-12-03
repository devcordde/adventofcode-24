# Experimental!
&fras "./day3.txt"

EvalList ← /+≡(/×⊜⋕≠@,.⍜⇌(↘1)↘4°□⊢)

PartOne ← (
  regex "mul\\(\\d+,\\d+\\)"
  EvalList
)

PartTwo ← (
  regex "mul\\(\\d+,\\d+\\)|do\\(\\)|don't\\(\\)"
  /+≡(EvalList°□)⊜(⊢⊜□≠□"don't()".)≠□"do()".≡⊢
)

[⊃PartOne PartTwo]
