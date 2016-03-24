import XMonad

-- hooks --
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.InsertPosition

-- util --
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)

-- layout --
import XMonad.Layout.Spacing
import XMonad.Layout.Gaps
import XMonad.Layout.SimpleFloat
import XMonad.Layout.NoBorders
import XMonad.Layout.ThreeColumns
import XMonad.Layout.PerWorkspace


-- miscelllanous --
import System.IO
import Control.Monad
import qualified XMonad.StackSet as W

------------------------------------------------------------------------
   
main = do
    xmprocws <- spawnPipe myXMobarWS
    spawnPipe myXMobar
        
    xmonad $ defaultConfig
        { manageHook	= myManageHook <+> manageDocks <+> manageHook defaultConfig        
        , layoutHook	= myLayoutHook 		
        , logHook		= myLogHook xmprocws 
        , workspaces	= myWorkspaces
        , terminal		= myTerminal
        , modMask		= mod4Mask     -- Rebind Mod to the Windows key
		, normalBorderColor = colorBlue 
		, focusedBorderColor = colorYellow 
        } `additionalKeys` myKeys

------------------------------------------------------------------------

-- Workspaces
myWorkspaces = ["term", "net", "edit", "place", "mail", "ζ", "η", "θ", "ι"]

-- Common
myTerminal = "xfce4-terminal"


-- Bar
myXMobarWS = "/usr/bin/xmobar /home/epsi/.xmonad/xmobarrc.workspace.hs"
myXMobar = "/usr/bin/xmobar /home/epsi/.xmonad/xmobarrc.hs"

-- Color names are easier to remember:
colorOrange         = "#FD971F"
colorDarkGray       = "#1B1D1E"
colorPink           = "#F92672"
colorGreen          = "#A6E22E"
colorBlue           = "#66D9EF"
colorYellow         = "#E6DB74"
colorWhite          = "#CCCCC6" 
colorNormalBorder   = "#CCCCC6"
colorFocusedBorder  = "#fd971f"


-- Layout Hook
myLayoutHook 
	=	onWorkspaces ["term"] screenshotLayout 
	$	onWorkspaces ["edit","place"] workingLayout 
	$	onWorkspaces ["net","mail"] browserLayout 
	$	commonLayout			

commonLayout = avoidStruts 
	$ gaps [(U,5), (D,5)] 
	$ spacing 10
	$ Tall 2 (5/100) (1/3)

screenshotLayout = avoidStruts 
	$ gaps [(U,0), (D,10)] 
	$ spacing 32
--	$ Tall 2 (5/100) (1/3)
--	$ Tall 1 (30/1280) (794/1280)  
	$ ThreeColMid 1 (3/100) (1/2)

workingLayout = avoidStruts 
	$ gaps [(U,5), (D,5)] 
	$ spacing 10
	$ layoutHook defaultConfig

browserLayout = noBorders 
	$ Full
--	$ simpleFloat

-- Log Hook
myLogHook h = do
  dynamicLogWithPP $ oxyPP h 
  
oxyPP :: Handle -> PP
oxyPP h = defaultPP
		{ ppOutput				= hPutStrLn h
		, ppOrder				= \(ws:l:t:_) -> [ws, t]
		, ppCurrent				= xmobarColor colorGreen colorDarkGray . wrap ">" "<"
		, ppVisible 			= xmobarColor colorBlue "" 
		, ppHidden				= xmobarColor colorPink ""
		, ppHiddenNoWindows		= xmobarColor colorDarkGray ""
		, ppUrgent				= xmobarColor colorYellow ""		
		, ppSep					= " :: "		
	--	, ppWsSep				= "."

		, ppTitle = xmobarColor colorYellow colorDarkGray . shorten 50
		}

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

-- Window Management 

myManageHook = (composeAll . concat $
  [
    [resource  =? r --> doIgnore           | r <- myIgnores    ]

  , [className =? b --> viewShift "net"    | b <- myBrowser    ]
  , [className =? c --> viewShift "ζ"      | c <- myGfxs       ]
  , [role      =? r --> doShift   "ζ"      | r <- myFs         ]

  , [name      =? n --> doCenterFloat      | n <- myNames      ]
  , [className =? c --> doCenterFloat      | c <- myFloats     ]
  , [className =? c --> doFullFloat        | c <- myFullFloats ]

  , [isDialog       --> doFocusCenterFloat                     ]
  , [isFullscreen   --> doFullFloat                            ]

  , [insertPosition Below Newer                                ]
  ])

  where
  viewShift = doF . liftM2 (.) W.greedyView W.shift

  role = stringProperty "WM_WINDOW_ROLE"
  name = stringProperty "WM_NAME"

  doFocusCenterFloat = doF W.shiftMaster <+> doF W.swapDown <+> doCenterFloat

  doFocusFullFloat   = doFullFloat

  -- classnames
  myFloats      = ["MPlayer", "Vlc", "Smplayer", "Lxappearance", "XFontSel"]
  myFullFloats  = ["feh", "Mirage", "Zathura", "Mcomix"]
  myGfxs        = ["Inkscape", "Gimp"]

  -- roles
  myFs          = ["ranger_startup"]

  -- resources
  myIgnores = ["desktop", "desktop_window"]

  -- names
  myNames   = ["Google Chrome Options", "Chromium Options", "Firefox Preferences"]
  
  -- browser
  myBrowser = ["Midori", "midori4", "Chromium", "Firefox", "Navigator"]


