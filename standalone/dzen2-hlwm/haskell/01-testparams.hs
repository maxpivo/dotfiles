-- This is a modularized config for herbstluftwm tags in dzen2 statusbar

import System.Environment
import System.Process
import Data.List

import MyHelper

-- initialize

panelHeight = 24

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- main

main = do
    -- initialize
    
    args <- getArgs
    let monitor = getMonitor args
        
    geometry <- getGeometry monitor
    let dzen2Parameters = getDzen2Parameters panelHeight geometry
    
    print $ intercalate " " $ dzen2Parameters
