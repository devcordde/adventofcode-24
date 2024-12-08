import Data.Array
import qualified Data.Map as Map
import Data.List
import Data.Bifunctor

main = do
    input <- readFile "08input.txt"
    let grid = listArray ((1, 1), (length (lines input), length (head $ lines input))) (concat $ lines input)
    let antList = Map.elems (foldl (\acc (pos, char) ->  Map.insertWith (++) char [pos] acc) Map.empty (filter (\(_, char) -> char /= '.') (assocs grid)))
    let antPairs = concatMap (filter ((==2).length) . subsequences) antList
    let p1Ant = nub $ concatMap (filter (inRange (bounds grid)) . (\[(x,y), (a,b)] -> [(x + x - a, y + y - b), (a + a - x, b + b - y)])) antPairs
    let p2Ant = nub $ concatMap (filter (inRange (bounds grid)) . (\[(x,y), (a,b)] -> 
            takeWhile (\(i,j) -> inRange (bounds grid) (i,j)) [(i,j) | n <- [0..], let i = x + (x-a)*n, let j = y + (y - b)*n ] 
            ++ takeWhile (\(i,j) -> inRange (bounds grid) (i,j)) [(i,j) | n <- [0..], let i = x - (x-a)*n, let j = y - (y - b)*n ] 
            )) antPairs
    putStrLn $ "Part 1: " ++ show (length p1Ant) ++ "\nPart 2: " ++ show (length p2Ant)
