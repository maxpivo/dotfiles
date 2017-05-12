module MyHelper
( hc
, do_config
, set_tags_with_name
, bind_cycle_layout
, do_panel
) where

import System.Process
import System.Exit

import System.Directory
import System.IO

import MyConfig

type Pair = (String, String)

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- helpers

hc :: String -> IO ExitCode
hc arguments = system $ "herbstclient " ++ arguments

-- IO action procedure
do_config :: String -> [Pair] -> IO ()
do_config command pairs = do
    -- loop over a hash dictionary of tuples
    mapM_ (\(key, value) -> do 
            hc(command ++ " " ++ key ++ " " ++ value)

            -- uncomment to debug in terminal
            -- putStrLn(command ++ " " ++ key ++ " " ++ value)
        ) pairs   

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- tags related

get_indices :: [Int] -> [Int]
get_indices l = [0 .. (length l) - 1]

-- Pattern Matching
keybind_keytag :: Int -> Maybe Int -> IO ()
keybind_keytag index Nothing = do return ()
keybind_keytag index (Just key) = do
        hc("keybind Mod4-" ++ show(key) 
                ++ " use_index '" ++ show(index) ++ "'")
        hc("keybind Mod4-Shift-" ++ show(key) 
                ++ " move_index '" ++ show(index) ++ "'")
        return ()

set_tag :: Int -> IO ()
set_tag index = do
    hc("add '" ++ show(tag_names !! index) ++ "'")
    
    -- uncomment to debug in terminal
    -- putStrLn $ show index

    let key = tag_keys !! index
    keybind_keytag index (Just key)
    
    return ()

set_tags_with_name :: IO ()
set_tags_with_name = do
    hc("rename default '" 
        ++ show (tag_names !! 0) ++ "' 2>/dev/null || true")

    mapM_ set_tag (get_indices tag_names)
    
    return ()
    
-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- miscellanous

bind_cycle_layout :: IO ExitCode
bind_cycle_layout = do
    -- The following cycles through the available layouts
    -- within a frame, but skips layouts, if the layout change 
    -- wouldn't affect the actual window positions.
    -- I.e. if there are two windows within a frame,
    -- the grid layout is skipped.

    hc( "keybind Mod4-space "
        ++ "or , and . compare tags.focus.curframe_wcount = 2 "
        ++ ". cycle_layout +1 vertical horizontal max vertical grid "
        ++ ", cycle_layout +1 " )

-- do multi monitor setup here, e.g.:
-- hc("set_monitors 1280x1024+0+0 1280x1024+1280+0");
-- or simply:
-- hc("detect_monitors");

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- find the panel

-- poorly designed, need more refactoring
-- and migrate imperative thinking to functional
do_panel :: IO ()
do_panel = do
    -- Source directory is irrelevant in Haskell
    -- So hardcoded, for the sake of learning
    let path = "/.config/herbstluftwm/bash/dzen2/panel.sh"
    
    home <- getHomeDirectory
    let file = home ++ path

    isExist <- doesFileExist file
    permission <- getPermissions file
    let exec_ok = executable permission
    
    -- need to check for executable permission also
    let panel = if(isExist && exec_ok)
            then file    
            else "/etc/xdg/herbstluftwm/panel.sh"
    
    -- uncomment to debug in terminal
    -- putStrLn panel
     
    (_, Just pipeout, _, _) <- 
        createProcess (proc "herbstclient" ["list_monitors"])
        { std_out = CreatePipe } 

    (_, Just cutout, _, ph)  <- 
        createProcess (proc "cut" ["-d:", "-f1"]) 
        { std_in = UseHandle pipeout, std_out = CreatePipe }
        
    raw <- hGetContents cutout   
    _ <- waitForProcess ph

    -- uncomment to debug in terminal       
    -- putStrLn raw
    let monitors = lines raw
    
    mapM_ (\monitor -> do
            system(panel ++ " " ++ show(monitor) ++ " &")
          ) monitors

    return ()
