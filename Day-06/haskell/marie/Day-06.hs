import Control.Monad (msum)
import Data.List (elemIndex, nub)
import Data.Maybe (fromJust)
import Data.Set qualified as Set

main = do
  input <- getContents -- read input from stdin
  let map' = lines input
      start = findStartPosition map'
      route = nub $ map snd $ walk start Up map'
  print $ length route
  print $ length $ findObstaclePositions start map' route

data Direction = Up | Right | Down | Left deriving (Enum, Eq, Show, Ord)

turnRight :: Direction -> Direction
turnRight dir = head $ tail $ dropWhile (/= dir) $ cycle (enumFrom Up)

addDirection :: Direction -> (Int, Int) -> (Int, Int)
addDirection d (x, y) = case d of
  Up -> (x, y - 1)
  Down -> (x, y + 1)
  Main.Left -> (x - 1, y)
  Main.Right -> (x + 1, y)

findStartPosition :: [String] -> (Int, Int)
findStartPosition map' =
  fromJust $
    msum $
      zipWith
        ( \row y ->
            case elemIndex '^' row of
              Just x -> Just (x, y)
              Nothing -> Nothing
        )
        map'
        [0 ..]

isInRange :: (Int, Int) -> [String] -> Bool
isInRange (x, y) map' = x >= 0 && x < length (head map') && y >= 0 && y < length map'

walk :: (Int, Int) -> Direction -> [String] -> [(Direction, (Int, Int))]
walk pos direction map =
  let (x, y) = addDirection direction pos
   in if isInRange (x, y) map
        then case map !! y !! x of
          '#' -> (direction, pos) : walk pos (turnRight direction) map
          _ -> (direction, pos) : walk (x, y) direction map
        else [(direction, pos)]

findObstaclePositions :: (Int, Int) -> [String] -> [(Int, Int)] -> [(Int, Int)]
findObstaclePositions start map' =
  foldr
    ( \pos result ->
        let newMap = addObstacle pos map'
         in if pos /= start
              && isCycle (walk start Up newMap)
              then pos : result
              else result
    )
    []

isCycle :: (Ord a) => (Eq a) => [a] -> Bool
isCycle = isCycle' Set.empty
  where
    isCycle' seen (x : xs) = Set.member x seen || isCycle' (Set.insert x seen) xs
    isCycle' _ [] = False

addObstacle :: (Int, Int) -> [String] -> [String]
addObstacle pos map' =
  map
    ( \y ->
        map
          ( \x ->
              if (x, y) == pos
                then '#'
                else map' !! y !! x
          )
          [0 .. (length (head map') - 1)]
    )
    [0 .. (length map' - 1)]
