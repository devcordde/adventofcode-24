module Main where

import Data.List.Split (splitOn)
import Data.List

cmpFkt :: [(Int, Int)] -> Int -> Int -> Ordering
cmpFkt rules x y = if (x, y) `elem` rules then LT else GT

sortHelper :: [(Int,Int)] -> [[Int]] -> (Int,Int)
sortHelper rules [] = (0,0)
sortHelper rules (x:xs) = let y = sortBy (cmpFkt rules) x in if y== x then (fst sum + (x!!(length x `div` 2 )), snd sum) else (fst sum, snd sum + (y!!(length x `div` 2 )))
    where
        sum = sortHelper rules xs

main :: IO ()
main = do
    content <- readFile "05input.txt"
    let rules = map ((\[x,y] -> ((read::String -> Int) x,(read::String -> Int) y)) . splitOn "|") (splitOn "\n" $ head $ splitOn "\n\n" content)
    let updates = map (map (\x -> read x :: Int) . splitOn ",") (init $ splitOn "\n" $ last $ splitOn "\n\n" content)
    print (sortHelper rules updates)
