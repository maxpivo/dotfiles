module MyStatusBar
( csbdConkyMonitor
, csbdTopBackground
, csbdTopLeft
, csbdTopRight
, csbdBottomBackground
, csbdBottomLeft
, csbdBottomCenter
, csbdBottomRight
) where

-- csbd = Call Stabus Bar DZen2

-- own module: configuration decomposition --
import MyColor

------------------------------------------------------------------------

-- Dzen2 Bar

-- Reading:
-- https://github.com/robm/dzen

-- Inspired by
-- https://github.com/harukachan/dotfiles/tree/master/unminimalVarokah

------------------------------------------------------------------------    

fgColor = myColor "Foreground"
bgColor = myColor "Background"
dcColor = myColor "Decoration"

screenWidth = "1280"

font1 = "awesome-9"
font2 = "profont-9"
font3 = "Droid Sans Fallback-9:bold"

dzenArgs = " -p -e 'button3=' -fn '"++font3++"' "
dzenColors = " -fg '"++fgColor++"' -bg '"++bgColor++"' "

------------------------------------------------------------------------
-- Top

csbdTopBackground = "echo '^fg("++dcColor++")^p(;-10)^r("++screenWidth++"x5)' |"
    ++ " dzen2 -ta c -h 35 -w "++screenWidth++" "
    ++ dzenArgs ++ dzenColors

csbdTopLeft = "sleep 0.5 && "
    ++ " echo '^bg("++dcColor++")       ^bg()^fg("++dcColor++")^i(.xmonad/assets/deco/mt1.xbm)^fg()' |"    
    ++ " dzen2 -ta l -h 30 -y 4 -w 200 -x 0 "
    ++ dzenArgs ++ dzenColors

csbdTopRight = "sleep 0.5 && "
    ++ " echo '^fg("++dcColor++")^i(.xmonad/assets/deco/mt2.xbm)^fg()^bg("++dcColor++")       ^bg()' |"    
    ++ " dzen2 -ta r -h 30 -y 4 -w 200 -x -200 "
    ++ dzenArgs ++ dzenColors

csbdConkyMonitor = "sleep 2 && "
    ++ " conky -c ~/.xmonad/conky_dzen_top | "
    ++ " dzen2 -ta c -x 0 -y 5 -h 20 "
    ++ " -w `expr "++screenWidth++" - 300` -x 150 "    
    ++ dzenArgs ++ dzenColors

------------------------------------------------------------------------
-- Bottom

csbdBottomBackground = "echo '^fg("++dcColor++")^p(;21)^r("++screenWidth++"x5)' |"
    ++ " dzen2 -ta c -h 35 -y -35 -w "++screenWidth++" "
    ++ dzenArgs ++ dzenColors
    
csbdBottomLeft = "sleep 1; "
    ++ " dzen2 -ta l -h 25 -y -30 "
    ++ " -w `expr "++screenWidth++" / 2` "
    ++ dzenArgs ++ dzenColors

csbdBottomRight = "sleep 1.5 && "
    ++ " conky -c ~/.xmonad/conky_dzen_bottom | "
    ++ " dzen2 -ta r -h 25 -y -30 -w 200 -x -200 "
    ++ dzenArgs ++ dzenColors
        
csbdBottomCenter = "sleep 2; "
    ++ " dzen2 -ta c -h 25 -y -30 "
    ++ " -w 300 -x `expr "++screenWidth++" / 2 - 150` "
    ++ dzenArgs ++ dzenColors
    
