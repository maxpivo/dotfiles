module MyHelper
( getMonitor
, getGeometry
, getDzen2Parameters
) where

import System.Process
import System.IO
import System.Exit

import Control.Monad

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- helpers

getMonitor :: [String] -> Int
getMonitor args
  | length(args) > 0 = read (args !! 0) :: Int
  | otherwise        = 0

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- geometry calculation

getGeometry :: Int -> IO [Int]
getGeometry monitor = do 
    let args = ["monitor_rect", show(monitor)]

    (_, Just pipe_out, _, ph) <- 
        createProcess (proc "herbstclient" args)
        { std_out = CreatePipe } 
        
    raw <- hGetContents pipe_out   
    _ <- waitForProcess ph
    
    when (raw == "") $ do
        putStrLn $ "Invalid monitor " ++ show(monitor)
        exitSuccess

    let geometry = map (read::String->Int) (words raw)
    
    return geometry


-- geometry has the format X Y W H
data XYWH = XYWH String String String String

getTopPanelGeometry :: Int -> [Int] -> XYWH
getTopPanelGeometry 
    height geometry = XYWH 
                      (show (geometry !! 0))
                      (show (geometry !! 1))
                      (show (geometry !! 2))
                      (show height)

getBottomPanelGeometry :: Int -> [Int] -> XYWH
getBottomPanelGeometry 
    height geometry = XYWH 
                      (show (geometry !! 0))
                      (show ((geometry !! 3) - height))
                      (show (geometry !! 2))
                      (show height)

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- dzen Parameters

getDzen2Parameters :: Int -> [Int] -> [String]
getDzen2Parameters 
    panelHeight geometry = [
          "-x", xpos,  "-y", ypos,
          "-w", width, "-h", height,
          "-fn", font,
          "-ta", "l",
          "-bg", bgcolor,
          "-fg", fgcolor,
          "-title-name", "dzentop"
        ]
      where
        XYWH xpos ypos width height = getTopPanelGeometry 
                                      panelHeight geometry        
        bgcolor = "#000000"
        fgcolor = "#ffffff"
        font    = "-*-takaopgothic-medium-*-*-*-12-*-*-*-*-*-*-*"
