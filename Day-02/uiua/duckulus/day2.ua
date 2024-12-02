# Experimental!
&fras "./day2.txt"

⊜□≠@\n.
≡⍚(⊜⋕≠@ .)

IsSafe ← ↧⊃(=⊃(/↧)(/↥)>0) (/↧↧⊃(>0)(<4)⌵) -⇌↘1⇌:↘1.

PartOne ← (
  ≡⍚IsSafe
  °□/+
)

PartTwo ← (
  ≡⍚(≡(IsSafe⍜↻(↘1)°□⊣:°□⊢.) ⍉ ⊟≡□:∵□⇡⧻.↯⊂.⧻.)
  /+≡(/↥°□)
)

[⊃PartOne PartTwo]
