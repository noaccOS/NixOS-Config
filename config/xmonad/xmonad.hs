module Main where

import System.Exit
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.SpawnOn
import XMonad.Actions.UpdatePointer
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Groups.Examples
import XMonad.Layout.IndependentScreens
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Reflect
import XMonad.Layout.Spacing
import XMonad.Layout.ThreeColumns
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig
import XMonad.Util.SpawnOnce

import XMonad.Hooks.StatusBar

import XMonad.Hooks.EwmhDesktops

-- One xmobar process for each monitor
main = do
  screens <- countScreens
  xmonad . docks . ewmh . dynamicSBs barSpawner $ myConfig screens

myConfig screens =
  def
    { borderWidth = 1
    , terminal = myTerminal
    , normalBorderColor = nord0
    , focusedBorderColor = nord9
    , modMask = mod4Mask
    , startupHook = myStartupHook
    , keys = myKeys
    , workspaces =
        withScreens screens ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    , layoutHook = myLayoutHook
    , manageHook = myManageHook
    , logHook = mouseFollowFocus
    }

-- Settings
myTerminal = "wezterm"

nord0 = "#2E3440" -- Background

nord1 = "#3B4252"

nord2 = "#434C5E"

nord3 = "#4C566A" -- Not so dark background

nord4 = "#D8DEE9" -- Grey

nord5 = "#E5E9F0"

nord6 = "#ECEFF4" -- White

nord7 = "#8FBCBB" -- Aquamarine

nord8 = "#88C0D0" -- Light Blue

nord9 = "#81A1C1" -- Lilac

nord10 = "#5E81AC" -- Bluish

nord11 = "#BF616A" -- Red

nord12 = "#D08770" -- Orange

nord13 = "#EBCB8B" -- Yellow

nord14 = "#A3BE8C" -- Green

nord15 = "#B48EAD" -- Purple

-- Startup
myStartupHook :: X ()
myStartupHook = do
  spawnOnce "xrdb ~/.Xresources"
  spawnOnce "ibus-daemon"
  spawnOnce "xsetroot -cursor_name left_ptr"
  spawnOnce "feh --bg-fill ~/Pictures/Wallpapers/Minimalist/nord/2.jpg"
  spawnOnOnce (marshall 1 "1") "telegram-desktop"
  spawnOnOnce (marshall 1 "2") "discord"
  spawnOnOnce (marshall 0 "1") myTerminal

-- Keybindings
myKeys c =
  mkKeymap c $
    -- workspaces keybindings
  [ (m ++ "M-" ++ [k], windows $ onCurrentScreen f i)
  | (i, k) <- zip (workspaces' c) "',.pyfgcr"
  , (f, m) <- [(W.greedyView, ""), (W.shift, "S-")]
  ] ++
      -- application launcher
  [ ("M-u " ++ k, spawn app)
  | (k, app) <-
      [ ("h", "nyxt")
      , ("S-t", "telegram-desktop")
      , ("d", "discord")
      , ("S-s", "spotify")
      , ("y", "yuzu")
      , ("s", "steam")
      , ("l", "lutris")
      , ("g", "gdlauncher-bin")
      , ("e", "emacs")
      , ("t", "teams")
      , ("n", "nautilus")
      , ("b", "blueman-manager")
      , ("j", "jellyfin-mpv-desktop")
      ]
  ] ++
      -- other applications
  [ ("M-<Return>", spawn myTerminal)
  , ("M-o", spawn "flameshot gui")
  , ("M-<Space>", spawn "~/.config/rofi/launchers/misc/launcher.sh")
  ] ++
      -- xmonad keybindings
  [ ("M-S-q", kill)
  , ("M-S-m", windows W.swapMaster)
  , ("M-S-t", windows W.swapDown)
  , ("M-S-n", windows W.swapUp)
  , ("M-m", windows W.focusMaster)
  , ("M-t", windows W.focusDown)
  , ("M-n", windows W.focusUp)
  , ("M-h", sendMessage Shrink)
  , ("M-s", sendMessage Expand)
  , ("M-l", nextScreen)
  , ("M-S-l", shiftNextScreen *> nextScreen)
  , ("M-C-l", shiftNextScreen)
  , ("M-b", tileFocused) -- tile a floating window
  , ("M-a", sendMessage NextLayout *> sendMessage ToggleStruts) -- only works because I have 2 layouts
  , ("M-e", toggleWindowFull)
  , ("M-S-z", spawn "xmonad --recompile && xmonad --restart")
  , ("M-C-z", io exitSuccess)
  ]

-- Workspaces - 9 for each monitor
-- myWorkspaces = withScreens nScreens $ map show [1 .. 9]
myLayoutHook =
  avoidStruts .
  spacingRaw True (Border 20 0 20 0) True (Border 0 20 0 20) True .
  onWorkspace (marshall 1 "1") (wideLayout $ 3 / 10) $ -- Telegram Layout
  onWorkspaces
    (map (marshall 1 . show) [2 .. 9])
    (wideLayout $ 1 / 2) -- Other workspaces on second monitor
    ultrawideLayout -- Main monitor Layouts

-- The layout for my primary monitor
ultrawideLayout = tiled ||| noBorders Full
  where
    tiled = ThreeColMid nmaster delta ratio
    nmaster = 1 -- The default number of windows in the master pane
    ratio = 1 / 2 -- Default proportion of screen occupied by master pane
    delta = 3 / 100 -- Percent of screen to increment by when resizing panes

-- Layout for my other monitor, having it on the left it's more practical to have the master on the right
wideLayout ratio = reflectHoriz tiled ||| noBorders Full
  where
    tiled = Tall nmaster delta ratio
    nmaster = 1
    delta = 3 / 100

tileFocused = withFocused $ windows . W.sink

floatFocused = withFocused float

myManageHook = manageSpawn

-- Color text in xmobar syntax
xmbcolor color text _ = "<fc=" ++ color ++ ">" ++ text ++ "  </fc>"

-- Mouse will follow focused window
mouseFollowFocus = updatePointer (0.5, 0.5) (0, 0)

logId :: Int -> String
logId x = "_XMONAD_LOG_" ++ show x

barCmd :: Int -> String
barCmd x = "xmobar -x " ++ show x ++ " -C \"[Run NamedXPropertyLog \\\"" ++ logId x ++ "\\\" \\\"XMLog\\\"]\""

noaccosXMobarPP :: PP
noaccosXMobarPP =
  def
    { ppCurrent = xmbcolor nord14 "\61713"
    , ppVisible = xmbcolor nord9 "\61713"
    , ppHidden = xmbcolor nord9 "\61842"
    , ppHiddenNoWindows = xmbcolor nord9 "\61708"
    , ppUrgent = xmbcolor nord11 "\62759"
    , ppOrder = \(ws:_) -> [ws]
    }

makeBar :: ScreenId -> StatusBarConfig
makeBar (S x) =
  statusBarPropTo
    (logId x)
    --("xmobar -x " ++ show x)
    (barCmd x)
    (pure $ marshallPP (S x) 
     noaccosXMobarPP)

barSpawner :: ScreenId -> IO StatusBarConfig
barSpawner x
  | x >= 0 = pure $ makeBar x
  | otherwise = mempty
