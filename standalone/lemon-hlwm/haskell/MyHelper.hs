module MyHelper
( getMonitor
, getGeometry
, XYWH (XYWH)
, getTopPanelGeometry
, getBottomPanelGeometry
, getLemonParameters
, getParamsTop
, getParamsBottom
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
                      (show ((geometry !! 0) + 0))
                      (show ((geometry !! 3) - height))
                      (show ((geometry !! 2) - 0))
                      (show height)

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- lemonbar Parameters

getParamsTop :: Int -> [Int] -> [String]
getParamsTop panelHeight geometry = [
          "-g", geom_res,  "-u", "2",
          "-B", bgcolor, "-F", fgcolor,
          "-f", font_takaop,
          "-f", font_awesome,
          "-f", font_symbol
        ]
      where
        -- calculate geometry
        XYWH xpos ypos width height = getTopPanelGeometry 
                                      panelHeight geometry        

        -- geometry: -g widthxheight++y
        geom_res = width ++ "x" ++ height
            ++ "+" ++ xpos ++ "+" ++ ypos

        -- color, with transparency    
        bgcolor = "#aa000000"
        fgcolor = "#ffffff"
        
        -- XFT: require lemonbar_xft_git 
        font_takaop  = "takaopgothic-9"
        font_symbol  = "PowerlineSymbols-11"
        font_awesome = "FontAwesome-9"

getParamsBottom :: Int -> [Int] -> [String]
getParamsBottom panelHeight geometry = [
          "-g", geom_res,  "-u", "2",
          "-B", bgcolor, "-F", fgcolor,
          "-f", font_mono,
          "-f", font_awesome,
          "-f", font_symbol
        ]
      where
        -- calculate geometry
        XYWH xpos ypos width height = getBottomPanelGeometry 
                                      panelHeight geometry        

        -- geometry: -g widthxheight++y
        geom_res = width ++ "x" ++ height
            ++ "+" ++ xpos ++ "+" ++ ypos

        -- color, with transparency    
        bgcolor = "#aa000000"
        fgcolor = "#ffffff"
        
        -- XFT: require lemonbar_xft_git 
        font_mono    = "monospace-9"
        font_symbol  = "PowerlineSymbols-11"
        font_awesome = "FontAwesome-9"

getLemonParameters :: Int -> [Int] -> [String]
getLemonParameters panelHeight geometry = 
    getParamsTop panelHeight geometry
