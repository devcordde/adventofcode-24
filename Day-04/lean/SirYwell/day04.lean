structure Vec where
  x : Int
  y : Int
deriving Repr

def isWord (word : List Char) (array : Array (Array Char)) (direction : Vec) (xc : Int) (yc : Int) : Bool :=
  match word with
  | h :: t =>
    let xn := xc + direction.x
    let yn := yc + direction.y
    if xn < 0 || yn < 0 || xn >= array[0]!.size || yn >= array.size then false
    else if array[yn.toNat]![xn.toNat]! == h then isWord t array direction xn yn
    else false
  | [] => true

def matchings (word : List Char) (array : Array (Array Char)) (directions : List Vec) (xs : Nat) (ys : Nat) : List Vec :=
  directions.filter (isWord word array . xs ys)

def forAllMatches (isMatch : Char → Bool) (array : Array (Array Char)) (action : Char → Nat → Nat → Array (Array Char) → α) : List α :=
  let d := array.map (Array.zipWithIndex . |>.toList) |>.zipWithIndex |>.toList
  d.bind (fun r => r.fst.bind (fun c => (if isMatch c.fst then [action c.fst c.snd r.snd array] else [])))

def floodCollect (word : String) (array : Array (Array Char)) : List (Nat × Nat × List Vec) :=
  let w := word.toList
  let directions := [
    (-1, -1), (-1, 0), (-1, 1),
    ( 0, -1),          ( 0, 1),
    ( 1, -1), ( 1, 0), ( 1, 1)
  ].map (fun v => Vec.mk v.fst v.snd)
  forAllMatches (. == w.head!) array (fun _ x y arr => matchings w.tail arr directions x y |> (x, y, .))

def floodCount (word : String) (array : Array (Array Char)) : Nat :=
  floodCollect word array |>.bind (fun e => e.snd.snd) |>.length

def isMasX (x : Int) (y : Int) (array : Array (Array Char)) : Bool :=
  let xl := x - 1; let xu := x + 1
  let yl := y - 1; let yu := y + 1
  if xl < 0 || xu >= array[0]!.size || yl < 0 || yu >= array.size then false
  else
    let xl := xl.toNat; let xu := xu.toNat
    let yl := yl.toNat; let yu := yu.toNat
    (array[yl]![xl]! == 'M' && array[yu]![xu]! == 'S' || array[yl]![xl]! == 'S' && array[yu]![xu]! == 'M') &&
    (array[yl]![xu]! == 'M' && array[yu]![xl]! == 'S' || array[yl]![xu]! == 'S' && array[yu]![xl]! == 'M')

def countMas (array : Array (Array Char)) : Nat :=
  forAllMatches (. == 'A') array (fun _ x y arr => isMasX x y arr) |>.count true

def toPuzzle (input : String) : Array (Array Char) :=
  input.splitOn "\n" |>.map (String.toList . |>.toArray) |>.toArray

def main : IO Unit := do
  let file <- IO.FS.readFile "day04.txt"
  let puzzle := toPuzzle file
  floodCount "XMAS" puzzle |> IO.println
  countMas puzzle |> IO.println
