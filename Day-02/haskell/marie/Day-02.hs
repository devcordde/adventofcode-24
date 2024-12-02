import Data.List (sort, sortBy)
import Data.Ord (Down (Down), comparing)
import Data.Set qualified as Set

main = do
  input <- getContents -- read input from stdin
  let reports = map (map read . words) $ lines input
  print $ length $ filter (isSafe 0) reports
  print $ length $ filter (isSafe 1) reports

isSorted :: (Ord a) => [a] -> Bool
isSorted list = sort list == list || sortBy (comparing Down) list == list

isSafe :: Int -> [Int] -> Bool
isSafe skips report =
  let errors =
        Set.toList $
          snd $
            foldl
              ( \(state, errors) (index, value) ->
                  let result = state ++ [value]
                      hasCorrectDiff = (null state || abs (last state - value) `elem` [1 .. 3])
                   in if isSorted result && hasCorrectDiff
                        then (result, errors)
                        else (result, foldr Set.insert errors [index - 1 .. index + 1])
              )
              ([], Set.empty)
              (zip [0 ..] report)
   in (null errors || (skips > 0 && any (\index -> isSafe (skips - 1) (take (index - 1) report ++ drop index report)) errors))
