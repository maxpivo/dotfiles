module MyStatusBar
( callDzen1, callDzen2
) where

------------------------------------------------------------------------

-- Dzen2 Bar

-- Reading:
-- https://github.com/robm/dzen


callDzen1_alt = "dzen2 -ta l -y -10 -w 1280 -h 18 "
    ++ "-fn 'awesome-9' -bg '#5c5dad' -e 'button3='"

callDzen2_alt = "sleep 1 && "
    ++ "conky -c /home/epsi/.xmonad/conky_dzen | "
    ++ "dzen2 -ta l -x 0 -y 2 -h 18 "
    ++ "-fn 'profont-9' -bg '#5c5dad' -fg '#dddddd' -e 'onnewinput=;button3='"

callDzen1 = "dzen2 -ta l -y -10 -w 1280 -h 18 "
    ++ "-fn 'awesome-9' -bg '#202040' -e 'button3='"

callDzen2 = "sleep 1 && "
    ++ "conky -c /home/epsi/.xmonad/conky_dzen | "
    ++ "dzen2 -ta l -x 0 -y 2 -h 18 "
    ++ "-fn 'profont-9' -bg '#202040' -e 'onnewinput=;button3='"
