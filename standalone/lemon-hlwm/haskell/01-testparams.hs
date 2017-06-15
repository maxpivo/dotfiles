-- This is a modularized config for herbstluftwm tags in lemonbar

import System.Environment
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
    let lemonParameters = getLemonParameters panelHeight geometry
    
    putStrLn $ intercalate " " $ lemonParameters
