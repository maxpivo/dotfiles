import XMonad


-- util --
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)

-- hooks --
import XMonad.Hooks.ManageDocks

-- own module: configuration decomposition --
import MyManageHook
import MyWorkspaces
import MyLayoutHook
import MyLogHook
import MyStatusBar

-- https://pbrisbin.com/posts/xmonad_modules/
-- do '$ ghc xmonad -ilib' in your ~/.xmonad to enable 'xmonad --recompile'

------------------------------------------------------------------------

   
main = do
    d <- spawnPipe callDzen1
    spawn callDzen2
        
    xmonad $ def
        { manageHook    = myManageHook <+> manageDocks <+> manageHook def
        , layoutHook    = myLayoutHook 
        , logHook       = myLogHook d
        , workspaces    = myWorkspaces
        , terminal      = myTerminal
        , modMask       = mod4Mask     -- Rebind Mod to the Windows key
        , normalBorderColor  = colorBlue 
        , focusedBorderColor = colorYellow 
        } `additionalKeys` myKeys

-- Common
myTerminal = "xfce4-terminal"

-- Color names are easier to remember:
colorBlue           = "#5c5dad"
colorYellow         = "#54777d"

------------------------------------------------------------------------

--Keys
myKeys = [ 
    ((mod4Mask .|. shiftMask, xK_z), 
            spawn "xscreensaver-command -lock")
        , ((mod4Mask, xK_p), 
            spawn "dmenu_run  -nb orange -nf '#444' -sb yellow -sf black -fn Monospace-9:normal")
        , ((controlMask, xK_Print), 
            spawn "sleep 0.2; scrot -s")
        , ((0, xK_Print), 
            spawn "scrot")
    ]



