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

    system "pkill dzen2"
    system $ "herbstclient pad " ++ show(monitor) ++ " "
        ++ show(panelHeight) ++ " 0 " ++ show(panelHeight) ++ " 0"

    -- run process in the background

    let paramsTop = getParamsTop panelHeight geometry
    detachDzen2 monitor paramsTop

    let paramsBottom = getParamsBottom panelHeight geometry
    detachDzen2Conky paramsBottom

    -- optional transparency
    detachTransset

    -- end of IO
    return ()
