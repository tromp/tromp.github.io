{-# LANGUAGE ScopedTypeVariables #-}

module Go where

import Data.Ix
import Data.List
import Data.Array
import Control.Monad
import Control.Monad.State

data Player = Black | White deriving (Eq, Enum, Show)

data Color = Empty | Stone Player deriving (Eq, Show)

newtype Position p = Position (Array p Color) deriving (Eq)

color :: (Point p) => Position p -> p -> Color
color (Position pos) p = pos!p

class (Show p, Ix p) => Point p where
  pointBounds :: (p,p)
  neighbours :: p -> [p]
  showpos :: Position p -> String

string :: (Point p) => Position p -> p -> [p]
string pos point = join (expand [[point],[]]) where
 expand l@(curr:prev:_) = if (null next) then l else expand (next:l) where
   next = nub [nbr | nbr <- curr>>=neighbours, color pos nbr == color pos point] \\ prev

liberties :: (Point p) => Position p -> [p] -> [p]
liberties pos group = [nbr | nbr <- group>>=neighbours, color pos nbr == Empty]

clear :: (Point p) => Position p -> [p] -> Position p
clear pos@(Position ar) points = Position (ar // zip captured (repeat Empty)) where
  captured = join [str | pt<-points, let str=string pos pt, null (liberties pos str)]

move :: (Point p) => Player -> p -> Position p -> Position p
move player point (Position ar) = pos3 where
  pos1 = Position (ar // [(point,Stone player)])
  opponent = [nbr|nbr<-neighbours point, (Stone p)<-[color pos1 nbr], p/=player]
  pos2 = clear pos1 opponent
  pos3 = clear pos2 [point]

data (Point p) => Turn p = Pass | Move p deriving (Eq, Show)

type Game p = [Turn p]

data GoError = NoPoint | Occupied | Superko Int deriving (Eq, Show) -- cycle length

type TurnOut = Either GoError String

type GameState p = State [Position p] -- remember list of previous positions

play :: (Point p) => Player -> Turn p -> GameState p TurnOut
play player Pass = do
  past@(pos:_) <- get
  put (pos:past)
  return $ Right $ show (length past) ++ ". " ++ show player ++ " pass\n" ++ gameover past
play player (Move point) = if not (inRange pointBounds point) then return (Left NoPoint) else do
  past@(pos:_) <- get
  if color pos point /= Empty then return (Left Occupied) else let
    pos' = move player point pos
    in case elemIndex pos' past of
      Just i  -> return $ Left $ Superko (1+i)
      Nothing -> do
        put (pos':past)
        return $ Right $ show (length past) ++ ". " ++ show player++" "++show point++"\n\n"++showpos pos'

gameover :: (Point p) => [Position p] -> String
gameover (pos:pos':_) | pos == pos' = "\nGame Over. Black: " ++ show bscore ++ " White: " ++ show wscore ++ ". " ++ winner ++ "\n" where
  [bscore, wscore] = map (score pos) [Black, White]
  winner = case compare bscore wscore of
    LT -> "White wins."
    EQ -> "It's a tie."
    GT -> "Black wins."
gameover _ = ""

score :: (Point p) => Position p -> Player -> Int
score pos player = length . filter (== (Just (Stone player))) . elems . ownermap $ pos

allpoints :: (Point p) => [p]
allpoints = range pointBounds

ownermap :: (Point p) => Position p -> Array p (Maybe Color)
ownermap pos@(Position ar) = foldr findowner (fmap Just ar) allpoints where
  findowner pt ar = if ar!pt /= Just Empty then ar else let
    empties = string pos pt
    owners = nub [c|c@(Stone p)<-empties>>=neighbours>>=return.color pos]
    owner = case owners of [color]  -> Just color; otherwise -> Nothing
    in ar // zip empties (repeat owner)

playgame :: (Point p) => Game p -> GameState p [TurnOut]
playgame game = sequence $ zipWith play (cycle [Black,White]) game

showgame :: forall p. (Point p) => Game p -> IO ()
showgame game = do
  let startpos = emptypos
  putStrLn $ showpos startpos
  mapM_ (putStrLn . (either (error.show) id)) $ evalState (playgame game) [startpos]

emptypos :: (Point p) => Position p
emptypos = Position (listArray pointBounds (repeat Empty))


class (Ord c, Bounded c, Enum c, Ix c, Show c) => Coord c

data (Coord x, Coord y) => Point2D x y = Point2D x y deriving (Eq,Ord,Ix)

instance (Coord x, Coord y) => Show (Point2D x y) where
  show (Point2D x y) = show x ++ show y

instance (Coord x, Coord y) => Point (Point2D x y) where
  neighbours = neighbours2D
  pointBounds = (Point2D minBound minBound, Point2D maxBound maxBound)
  showpos = showpos2D

neighbours2D :: (Coord x, Coord y) => Point2D x y -> [Point2D x y]
neighbours2D (Point2D x y) = [Point2D x y1 | y1<-neighbours1D y] ++
                             [Point2D x1 y | x1<-neighbours1D x] where
  neighbours1D z = [pred z | z/=minBound] ++ [succ z | z/=maxBound]

showpos2D :: forall x y. (Coord x, Coord y) => Position (Point2D x y) -> String
showpos2D pos = unlines (map showrow (reverse allcoords)) ++ files where
  showrow y = show y ++ ' ' : intersperse ' ' [tochar (color pos (Point2D x y)) | x<-allcoords]
  tochar (Stone Black) = '@'
  tochar (Stone White) = 'O'
  tochar Empty = '.'
  files = "  " ++ unwords (map show (allcoords::[x])) ++ "\n"

allcoords :: (Bounded c, Enum c) => [c]
allcoords = [minBound..maxBound]

mv :: (Coord x, Coord y) => (Int,Int) -> Turn (Point2D x y)
mv (x,y) = Move (Point2D (toEnum x) (toEnum y))

-- example 9x9 game
newtype XCoord = XCoord Int deriving (Eq,Ord,Ix)
instance Enum XCoord where
  fromEnum (XCoord x) = x
  toEnum = XCoord
instance Bounded XCoord where
  minBound = XCoord 1
  maxBound = XCoord 9
instance Show XCoord where show x = [(['A'..'T']\\['I'])!!(fromEnum x - 1)]
instance Coord XCoord

newtype YCoord = YCoord Int deriving (Eq,Ord,Ix)
instance Enum YCoord where
  fromEnum (YCoord y) = y
  toEnum = YCoord
instance Bounded YCoord where
  minBound = YCoord 1
  maxBound = YCoord 9
instance Show YCoord where
  show y = showy "  " (show . fromEnum $ y) where
    showy leading sy = drop (length sy) leading ++ sy

instance Coord YCoord

game :: Game (Point2D XCoord YCoord)
game = init (map Move allpoints) ++ [Pass, Pass]

main = showgame game
