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

contentInit :: Int -> Handle -> IO ()
contentInit monitor pipe_lemon_in = do
    -- initialize statusbar before loop
    setTagValue monitor 
    setWindowtitle ""
    
    text <- getStatusbarText monitor

    hPutStrLn pipe_lemon_in text
    hFlush pipe_lemon_in

contentWalk :: Int -> Handle -> IO ()
contentWalk monitor pipe_lemon_in = do
    let command_in = "herbstclient"

    (_, Just pipe_idle_out, _, ph) <- 
        createProcess (proc command_in ["--idle"]) 
        { std_out = CreatePipe }

    forever $ do
        -- wait for next event 
        event <- hGetLine pipe_idle_out 
        handleCommandEvent monitor event
 
        text <- getStatusbarText monitor

        hPutStrLn pipe_lemon_in text
        hFlush pipe_lemon_in

    hClose pipe_idle_out

runLemon :: Int -> [String] -> IO ()
runLemon monitor parameters = do
    let command_out = "lemonbar"

    (Just pipe_lemon_in, _, _, ph) <- 
        createProcess (proc command_out parameters) 
        { std_in = CreatePipe }

    contentInit monitor pipe_lemon_in
    contentWalk monitor pipe_lemon_in  -- loop for each event
    
    hClose pipe_lemon_in

detachLemon :: Int -> [String] -> IO ProcessID
detachLemon monitor parameters = forkProcess 
    $ runLemon monitor parameters 
