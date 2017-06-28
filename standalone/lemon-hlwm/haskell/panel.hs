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
    args <- getArgs
    let monitor = getMonitor args

    geometry <- getGeometry monitor

    killZombie
    system $ "herbstclient pad " ++ show(monitor) ++ " "
        ++ show(panelHeight) ++ " 0 " ++ show(panelHeight) ++ " 0"

    -- run process in the background

    let paramsTop = getParamsTop panelHeight geometry
    detachLemon monitor paramsTop

    let paramsBottom = getParamsBottom panelHeight geometry
    detachLemonConky paramsBottom

    -- end of IO
    return ()
