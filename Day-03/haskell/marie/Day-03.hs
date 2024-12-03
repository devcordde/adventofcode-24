import Data.Char (isDigit)

main = do
  input <- getContents -- read input from stdin
  let instructions = parseInstructions input
  print $ interpret instructions False
  print $ interpret instructions True

data Instruction = Multiply (Int, Int) | EnableMul | DisableMul
  deriving (Show)

interpret :: [Instruction] -> Bool -> Int
interpret instructions conditionals =
  snd $
    foldl
      ( \(enabled, amount) inst -> case inst of
          Multiply (a, b) -> (enabled, if enabled then a * b + amount else amount)
          EnableMul -> (conditionals || True, amount)
          DisableMul -> (not conditionals || False, amount)
      )
      (True, 0)
      instructions

parseMultiply :: String -> Maybe ((Int, Int), String)
parseMultiply input = do
  rest <- parseString "mul(" input
  (first, rest2) <- parseInt rest
  rest3 <- parseChar ',' rest2
  (second, rest4) <- parseInt rest3
  rest5 <- parseChar ')' rest4
  return ((first, second), rest5)

parseInstructions :: String -> [Instruction]
parseInstructions [] = []
parseInstructions input =
  let instruction = parseMultiply input
      enableMul = parseString "do()" input
      disableMul = parseString "don't()" input
   in case instruction of
        Just (inst, rest) -> Multiply inst : parseInstructions rest
        Nothing -> case enableMul of
          Just rest -> EnableMul : parseInstructions rest
          Nothing -> case disableMul of
            Just rest -> DisableMul : parseInstructions rest
            Nothing -> parseInstructions $ tail input

parseString :: String -> String -> Maybe String
parseString pattern input =
  if take (length pattern) input == pattern
    then Just $ drop (length pattern) input
    else Nothing

parseChar :: Char -> String -> Maybe String
parseChar _ [] = Nothing
parseChar char input =
  if head input == char
    then Just $ tail input
    else Nothing

parseInt :: String -> Maybe (Int, String)
parseInt input =
  let digits = takeWhile isDigit input
   in if null digits
        then Nothing
        else Just (read digits, drop (length digits) input)
