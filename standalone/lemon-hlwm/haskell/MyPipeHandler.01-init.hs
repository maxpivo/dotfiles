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

contentInit :: Int -> Handle -> IO ()
contentInit monitor pipe_lemon_in = do
    -- initialize statusbar before loop
    setTagValue monitor 
    setWindowtitle ""
    
    text <- getStatusbarText monitor

    hPutStrLn pipe_lemon_in text
    hFlush pipe_lemon_in

runLemon :: Int -> [String] -> IO ()
runLemon monitor parameters = do
    let command_out = "lemonbar"

    (Just pipe_lemon_in, _, _, ph) <- 
        createProcess (proc command_out (parameters ++ ["-p"])) 
        { std_in = CreatePipe }

    contentInit monitor pipe_lemon_in    
    hClose pipe_lemon_in

detachLemon :: Int -> [String] -> IO ProcessID
detachLemon monitor parameters = forkProcess 
    $ runLemon monitor parameters 
