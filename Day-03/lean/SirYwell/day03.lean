inductive Token
  | num (val : Nat)
  | mul
  | pOpen
  | pClose
  | comma
  | trash
  | do_
  | don_t
deriving Repr

def tokenize (input : String) : List Token :=
  let rec tk (cs : List Char) (acc : List Token) : List Token :=
    match cs with
    | [] => acc
    | '(' :: rest => tk rest (Token.pOpen :: acc)
    | ')' :: rest => tk rest (Token.pClose :: acc)
    | ',' :: rest => tk rest (Token.comma :: acc)
    | 'm' :: 'u' :: 'l' :: rest => tk rest (Token.mul :: acc)
    | 'd' :: 'o' :: '(' :: ')' :: rest => tk rest (Token.do_ :: acc)
    | 'd' :: 'o' :: 'n' :: '\'' :: 't' :: '(' :: ')' :: rest => tk rest (Token.don_t :: acc)
    | c :: rest =>
      if c.isDigit then
        tk rest (Token.num (c.toNat - 48) :: acc)
      else tk rest (Token.trash :: acc)
  tk input.toList [] |>.foldr (fun elem res => match res, elem with
    | (Token.num n) :: rest, Token.num m => Token.num (n * 10 + m) :: rest
    | _, _ => elem :: res
  ) [] |>.reverse

inductive Expr
  | numeric (value : Nat)
  | boolean (value : Bool)
deriving Repr

def isNumeric : Expr → Bool
  | Expr.numeric _ => true
  | _ => false

def extractExprs (string : String) : List Expr :=
  let tokens := tokenize string
  let rec parse (tokens : List Token) (acc : List Expr) : List Expr :=
    match tokens with
    | Token.mul :: Token.pOpen :: Token.num lhs :: Token.comma :: Token.num rhs :: Token.pClose :: rest => parse rest (Expr.numeric (lhs * rhs) :: acc)
    | Token.do_ :: rest => parse rest (Expr.boolean true :: acc)
    | Token.don_t :: rest => parse rest (Expr.boolean false :: acc)
    | _ :: rest => parse rest acc
    | [] => acc
  parse tokens [] |>.reverse

def sum (list : List Expr) (consider : Bool := true) (acc : Nat := 0) : Nat := match list with
  | Expr.numeric n :: rest => if consider then sum rest consider (n + acc) else sum rest consider acc
  | Expr.boolean b :: rest => sum rest b acc
  | [] => acc

def main : IO Unit := do
  let file <- IO.FS.readFile "day03.txt"
  let exprs := extractExprs file
  exprs.filter isNumeric |> sum |> IO.println
  sum exprs |> IO.println
