-- This is a modularized config for herbstluftwm tags in dzen2 statusbar

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
    let dzen2Parameters = getDzen2Parameters panelHeight geometry

    -- do `man herbsluftclient`, and type \pad to search what it means
    system $ "herbstclient pad " ++ show(monitor) ++ " "
        ++ show(panelHeight) ++ " 0 " ++ show(panelHeight) ++ " 0"
    
    -- main

    -- remove all dzen2 instance
    system "pkill dzen2"

    -- run process in the background
    detachDzen2 monitor dzen2Parameters

    -- optional transparency
    detachTransset

    -- end of IO
    return ()
