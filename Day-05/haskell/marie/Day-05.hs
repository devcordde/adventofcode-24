import Control.Monad (join)
import Data.Bifunctor (bimap)
import Data.Char (isDigit)
import Data.List (partition)
import Data.Map qualified as Map
import Data.Maybe (fromMaybe)

main = do
  input <- getContents -- read input from stdin
  let (rules, updates) = parseInput input
      middlePageNum update = update !! (length update `div` 2)
  print $ sum $ map middlePageNum $ filter (\update -> update == sort' rules update) updates
  print $ sum $ map (middlePageNum . snd) $ filter (uncurry (/=)) $ map (\u -> (u, sort' rules u)) updates

parseInput :: String -> (Map.Map Int [Int], [[Int]])
parseInput text =
  let (ruleText, updateText) = partition ('|' `elem`) $ filter (not . null) $ lines text
      ruleMap :: [(Int, Int)] = map (join bimap read . splitAt 2 . filter isDigit) ruleText
      rules = foldr (\(a, b) state -> Map.insert b (fromMaybe [] (Map.lookup b state) ++ [a]) state) Map.empty ruleMap
      updates :: [[Int]] = map (map read . split (== ',')) updateText
   in (rules, updates)

split :: (Char -> Bool) -> String -> [String]
split _ [] = []
split pred input =
  let result = takeWhile (not . pred) input
   in result : split pred (drop (length result + 1) input)

sort' :: Map.Map Int [Int] -> [Int] -> [Int]
sort' rules =
  foldl
    ( \state x ->
        let currentRules = fromMaybe [] $ Map.lookup x rules
            first = takeWhile (`elem` currentRules) state
            second = drop (length first) state
         in first ++ x : second
    )
    []
