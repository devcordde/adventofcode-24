import Data.List (elemIndex)
import Data.Maybe (fromJust)

main :: IO ()
main = do
  input <- getContents -- read input from stdin
  let equations = map parseEquation $ lines input
      sumPossibleEquations operators = sum $ map fst $ filter (\(result, numbers) -> canBeTrue result $ possibilites numbers operators) equations
  print $ sumPossibleEquations (\x o -> [Add o $ Number x, Multiply o $ Number x])
  print $ sumPossibleEquations (\x o -> [Add o $ Number x, Multiply o $ Number x, Concat o $ Number x])

data Operation
  = Number Int
  | Add Operation Operation
  | Multiply Operation Operation
  | Concat Operation Operation
  deriving (Show)

canBeTrue :: Int -> [Operation] -> Bool
canBeTrue result = any ((== result) . evaluate)

possibilites :: [Int] -> (Int -> Operation -> [Operation]) -> [Operation]
possibilites numbers operators =
  let initial = Number $ head numbers
   in foldl (\state x -> concatMap (operators x) state) [initial] $ tail numbers

evaluate :: Operation -> Int
evaluate operation = case operation of
  Number x -> x
  Add a b -> evaluate a + evaluate b
  Multiply a b -> evaluate a * evaluate b
  Concat a b -> read $ show (evaluate a) ++ show (evaluate b)

parseEquation :: String -> (Int, [Int])
parseEquation text =
  let resultIndex = fromJust $ elemIndex ':' text
      result = read $ take resultIndex text
      numbers = map read $ words $ drop (resultIndex + 1) text
   in (result, numbers)
