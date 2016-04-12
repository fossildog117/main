import Data.List
import Data.Function

-- input format is in the form of an adjacency list
type Graph = [(Integer, [Integer])]

getVertices :: Graph -> [Integer]
getVertices [] = []
getVertices (v:vs) = [fst v] ++ getVertices vs

ampleSwarms :: Graph -> [Integer] -> [Integer] -> [Integer] -> [[Integer]] -> [[Integer]]
ampleSwarms g r [] [] s = [r] ++ s
ampleSwarms g r [] x s = [[]]
ampleSwarms g r p x s = ampleSwarms g (r ++ [v]) (filterVertices g v (checkVertex) a) (filterVertices g v (checkVertex) x) s ++ ampleSwarms g r a (x++[v]) s

    where v = head p
          a = tail p
          filterVertices _ _ _ [] = []
          filterVertices g v f (p:ps)
             | f g v p = p : filterVertices g v f ps
             | otherwise = filterVertices g v f ps
          checkVertex [] _ _ = False
          checkVertex g m n = length [(a, b) | (a, b) <- g, m == a, n `elem` b] > 0

getMaximalCliques :: Graph -> [[Integer]]
getMaximalCliques g = [ x | x <- ampleSwarms g [] (getVertices g) [] [[]] , x /= [] ]
