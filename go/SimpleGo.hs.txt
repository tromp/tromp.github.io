-- implements the Logical Rules of Go (http://www.cwi.nl/~tromp/go.html)
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
module Go where
import Data.List
import Control.Monad.State

-- article 1a: Go is played on a 19x19 square grid of points
size = 19
coords = [1..size]
type Point = (Int,Int)
points = [(x,y) | x<-coords, y<-coords]

-- article 1b: by two players called Black and White
data Player = Black | White deriving (Eq, Show)

-- article 2: Each point on the grid may be colored black, white or empty.
data Color = Empty | Stone Player deriving (Eq, Show)

type Position = Point -> Color

-- article 3b: if there is a path of (vertically or horizontally) adjacent points of P's color from P
neighbours (x,y) = [(x,y1) | y1<-neighbours1 y] ++
                         [(x1,y) | x1<-neighbours1 x] where
 neighbours1 z = [pred z | z/=1] ++ [succ z | z/=size]

string pos point = join (expand [[point],[]]) where
 expand l@(curr:prev:_) = if (null next) then l else expand (next:l) where
  next = nub [nbr | nbr <- curr>>=neighbours, pos nbr==pos point] \\ prev

-- article 4: Clearing a color is the process of emptying all points of that color
clear pos points = \pt -> if pt `elem` captured then Empty else pos pt where
  captured = join [str | pt<-points, let str=string pos pt, null (liberties pos str)]

-- article 4b: that don't reach empty.
liberties pos group = nub [nbr | nbr<-group>>=neighbours, pos nbr==Empty]

-- article 5a: Starting with an empty grid
emptypos = const Empty

-- article 5b: the players alternate turns, starting with Black.
results turns = evalState (sequence $ zipWith play (cycle [Black,White]) turns) [emptypos]

-- article 6a: A turn is either a pass; or a move
data Turn = Pass | Move Point deriving (Show)

-- article 6b: that doesn't repeat an earlier grid coloring.
data GoError = Occupied | Superko Int deriving (Eq, Show) -- cycle length

testko pos past noko = case elemIndex (map pos points) (map (`map` points) past) of
  Just i  -> return $ Left $ Superko (1+i)
  Nothing -> noko

-- article 7: A move consists of coloring an empty point one's own color; then clearing the opponent color, and then clearing one's own color.
move player point pos = pos3 where
  pos1 = \pt -> if pt==point then (Stone player) else pos pt
  opponent = [nbr|nbr<-neighbours point, (Stone p)<-[pos1 nbr], p/=player]
  pos2 = clear pos1 opponent
  pos3 = clear pos2 [point]

play player Pass = do
  past@(pos:_) <- get
  put (pos:past)
  return $ Right $ show (length past) ++ ". " ++ show player ++ " pass\n" ++ gameover past
play player (Move point) = do
  past@(pos:_) <- get
  let pos' = move player point pos
  if pos point /= Empty then return (Left Occupied) else let
    pos' = move player point pos
    in testko pos' past $ do
       put (pos':past)
       return $ Right $ show (length past) ++ ". " ++ show player++" "++show point++"\n\n"++showpos pos'

-- article 8: The game ends after two consecutive passes.
gameover (pos:pos':_) | map pos points == map pos' points = "\nGame Over. Black: " ++ show bscore ++ " White: " ++ show wscore ++ ". " ++ winner bscore wscore ++ "\n" where
    (bscore, wscore) = (score pos Black, score pos White)
gameover _ = ""

-- article 9: A player's score is the number of points of her color, plus the number of empty points that reach only her color.
score pos player = sum $ map scorepoint points where
 scorepoint pt = case pos pt of
  Stone p | p == player -> 1
          | otherwise -> 0
  Empty   | owners == [player] -> 1
          | otherwise ->0 where
    owners = nub [p|(Stone p)<-string pos pt>>=neighbours>>=return.pos]

-- article 10: The player with the higher score at the end of the game is the winner. Equal scores result in a tie.
winner bscore wscore = case compare bscore wscore of
  LT -> "White wins."
  EQ -> "It's a tie."
  GT -> "Black wins."

-- show stuff
showpos pos = unlines (map showrow (reverse coords)) where
  showrow y = ' ':intersperse ' ' [tochar (pos(x,y))|x<-coords]
  tochar (Stone Black) = '@'
  tochar (Stone White) = 'O'
  tochar Empty = '.'
showgame game = do
  putStrLn $ showpos emptypos
  mapM_ (putStrLn . either (error.show) id) (results game)

-- example game
game = [Move (2,1), Move (2,3), Move (2,2), Move (3,2), Move (1,2), Pass, Pass]

main = showgame game
