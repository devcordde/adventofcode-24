import Data.Char (isDigit, isLetter)
import Data.List (nub)
import Data.Map qualified as Map

main :: IO ()
main = do
  input <- getContents
  let antennas = Map.fromListWith (++) $ map (\(a, b) -> (a, [b])) $ filter (isAntenna . fst) $ parseInput rows
      rows = lines input
      limits = (length (head rows) - 1, length rows - 1)
  print $ length $ nub $ concatMap snd $ Map.toList $ Map.map (calcAntinodes partOne limits) antennas
  print $ length $ nub $ concatMap snd $ Map.toList $ Map.map (calcAntinodes (partTwo limits) limits) antennas

isAntenna :: Char -> Bool
isAntenna x = isDigit x || isLetter x

calcAntinodes :: ((Int, Int) -> (Int, Int) -> [(Int, Int)]) -> (Int, Int) -> [(Int, Int)] -> [(Int, Int)]
calcAntinodes produceAntinodes (maxX, maxY) antennas = calcAntinodes' antennas
  where
    calcAntinodes' [] = []
    calcAntinodes' ((aX, aY) : xs) =
      let otherAntennas = filter (/= (aX, aY)) antennas
       in filter (\(x, y) -> x >= 0 && x <= maxX && y >= 0 && y <= maxY) $
            concatMap
              (produceAntinodes (aX, aY))
              otherAntennas
              ++ calcAntinodes' xs

partOne :: (Int, Int) -> (Int, Int) -> [(Int, Int)]
partOne (aX, aY) (bX, bY) = [(aX - (bX - aX), aY - (bY - aY))]

partTwo :: (Int, Int) -> (Int, Int) -> (Int, Int) -> [(Int, Int)]
partTwo (maxX, maxY) (aX, aY) (bX, bY) =
  let diffX = bX - aX
      diffY = bY - aY
      takeInRange max = takeWhile (\a -> a >= 0 && a <= max)
      x = takeInRange maxX ([aX, aX + diffX ..] ++ [aX, aX - diffX ..])
      y = takeInRange maxY ([aY, aY + diffY ..] ++ [aY, aY - diffY ..])
   in zip x y

parseInput :: [String] -> [(Char, (Int, Int))]
parseInput rows =
  let rowLen = length (head rows)
   in zipWith (\x index -> (x, (index `mod` rowLen, index `div` rowLen))) (concat rows) [0 ..]
