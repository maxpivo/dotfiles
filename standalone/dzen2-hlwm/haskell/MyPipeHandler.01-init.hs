module MyPipeHandler
( detachDzen2
, detachTransset
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

-- for use with transset
wSleep :: Int -> IO ()
wSleep mySecond = threadDelay (1000000 * mySecond)

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- pipe 

contentInit :: Int -> Handle -> IO ()
contentInit monitor pipe_dzen2_in = do
    setTagValue monitor 
    setWindowtitle ""
    
    text <- getStatusbarText monitor

    hPutStrLn pipe_dzen2_in text
    hFlush pipe_dzen2_in

runDzen2 :: Int -> [String] -> IO ()
runDzen2 monitor parameters = do
    let command_out = "dzen2"

    (Just pipe_dzen2_in, _, _, ph)  <- 
        createProcess (proc command_out (parameters ++ ["-p"])) 
        { std_in = CreatePipe }
       
    contentInit monitor pipe_dzen2_in
    hClose pipe_dzen2_in

detachDzen2 :: Int -> [String] -> IO ProcessID
detachDzen2 monitor parameters = forkProcess 
    $ runDzen2 monitor parameters 
    
detachTransset :: IO ProcessID
detachTransset = forkProcess $ do    
    wSleep 1
    system "transset .8 -n dzentop >/dev/null"
    return ()
