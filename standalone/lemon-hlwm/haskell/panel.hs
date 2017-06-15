-- This is a modularized config for herbstluftwm tags in lemonbar

import System.Environment
import System.Process

import MyHelper
import MyPipeHandler

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

    -- do `man herbsluftclient`, and type \pad to search what it means
    system $ "herbstclient pad " ++ show(monitor) ++ " "
        ++ show(panelHeight) ++ " 0 " ++ show(panelHeight) ++ " 0"
    
    -- main

    -- remove all lemonbar instance
    system "pkill lemonbar"

    -- run process in the background
    detachLemon monitor lemonParameters

    -- end of IO
    return ()
