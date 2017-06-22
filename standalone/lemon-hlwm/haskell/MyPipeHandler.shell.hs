module MyPipeHandler
( detachLemon
) where

import System.Process
import System.Posix.Types
import System.Exit

import GHC.IO.Handle

import System.IO
import System.Posix.Process

import Control.Concurrent
import Control.Monad

-- cabal install split
import Data.List.Split

import MyOutput


-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- helper

wSleep :: Int -> IO ()
wSleep mySecond = threadDelay (1000000 * mySecond)

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- pipe 

handleCommandEvent :: Int -> String -> IO ()
handleCommandEvent monitor event
  | origin == "reload"      = do system("pkill lemonbar"); return ()
  | origin == "quit_panel"  = do exitSuccess; return ()
  | elem origin tagCmds     = do setTagValue monitor
  | elem origin titleCmds   = do setWindowtitle (column !! 2)
  where
    tagCmds   = ["tag_changed", "tag_flags", "tag_added", "tag_removed"]
    titleCmds = ["window_title_changed", "focus_changed"]

    -- find out event origin
    column = splitOn "\t" event
    origin = column !! 0

initContent :: Int -> Handle -> IO ()
initContent monitor pipe_in = do
    -- initialize statusbar before loop
    setTagValue monitor 
    setWindowtitle ""
    
    text <- getStatusbarText monitor

    hPutStrLn pipe_in text
    hFlush pipe_in

walkContent :: Int -> Handle -> IO ()
walkContent monitor pipe_in = do
    let command_in = "herbstclient"

    (_, Just pipe_out, _, ph)  <- 
        createProcess (proc command_in ["--idle"]) 
        { std_out = CreatePipe }

    forever $ do
        -- wait for next event 
        event <- hGetLine pipe_out 
        handleCommandEvent monitor event
 
        text <- getStatusbarText monitor

        hPutStrLn pipe_in text
        hFlush pipe_in

    hClose pipe_out

runLemon :: Int -> [String] -> IO ()
runLemon monitor parameters = do
    let command_out = "lemonbar"

    (Just pipe_in, Just pipe_out, _, ph)  <- 
        createProcess (proc command_out parameters) 
        { std_in = CreatePipe, std_out = CreatePipe }

    (_, _, _, ph)  <- 
        createProcess (proc "sh" []) 
        { std_in = UseHandle pipe_out }

    initContent monitor pipe_in
    walkContent monitor pipe_in  -- loop for each event
    
    hClose pipe_in
    hClose pipe_out

detachLemon :: Int -> [String] -> IO ProcessID
detachLemon monitor parameters = forkProcess 
    $ runLemon monitor parameters 
