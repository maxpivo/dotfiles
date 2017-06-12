-- This is a modularized config for herbstluftwm tags in lemonbar

import System.Environment
import System.Process

import MyHelper

import System.IO
import GHC.IO.Handle
import MyOutput

-- initialize

panelHeight = 24

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- process handler

testLemon :: Int -> [String] -> IO ()
testLemon monitor parameters = do
    let command_out = "lemonbar"

    (Just pipe_in, _, _, ph)  <- 
        createProcess (proc command_out (parameters ++ ["-p"]) )
        { std_in = CreatePipe }

    -- initialize statusbar before loop
    setTagValue monitor 
    setWindowtitle "test"
    
    text <- getStatusbarText monitor

    hPutStrLn pipe_in text
    hFlush pipe_in
    
    hClose pipe_in

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- main

main = do
    -- initialize
    
    args <- getArgs
    let monitor = getMonitor args

    -- do `man herbsluftclient`, and type \pad to search what it means
    system $ "herbstclient pad " ++ show(monitor) ++ " "
        ++ show(panelHeight) ++ " 0 " ++ show(panelHeight) ++ " 0"
        
    geometry <- getGeometry monitor
    let lemonParameters = getLemonParameters panelHeight geometry

    -- test

    -- run process
    testLemon monitor lemonParameters

    -- end of IO
    return ()
