#!/usr/bin/env bash

# ~/.osx — http://mths.be/osx
# Watch for changes in files with either of
#  sudo fs_usage | grep plist
#  sudo opensnoop | grep plist

killall "System Preferences"

echo "Please provide password for changes that require sudo"

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing 'sudo' time stamp until '.osx' has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


#
# General Settings
#

# Disable the "reopen windows when logging back in" option
# This works, although the checkbox will still appear to be checked.
defaults write com.apple.loginwindow TALLogoutSavesState -bool false
defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false
# Disable reopen on restart
defaults write NSGlobalDomain ApplePersistence -bool false

# Switch automatically between Light and Dark UI
defaults write NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -int 1

# Enable tabbing to move focus between all controls
defaults write NSGlobalDomain AppleKeyboardUIMode -int 2


#
# Desktop & Screen Saver
#

# Disable the screen saver (System Preferences must be closed)
defaults -currentHost write com.apple.screensaver idleTime -int 0

# Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Set login window text
sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText -string "Very good"


#
# Menubar
#

# Auto hide/show the menubar
defaults write NSGlobalDomain _HIHideMenuBar -bool true


#
# Dock
#

# Set the icon size of Dock items to 48 pixels
defaults write com.apple.dock tilesize -int 48

# Enable dock magification
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 60

# Put the dock on left side
defaults write com.apple.dock orientation -string "bottom"

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Change the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0.2
defaults write com.apple.dock autohide-time-modifier -float 0.2

# Minimize windows to application
defaults write com.apple.dock minimize-to-application -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Don't show recents
defaults write com.apple.dock show-recents -bool false

# Disable the Launchpad gesture (pinch with thumb and three fingers)
defaults write com.apple.dock showLaunchpadGestureEnabled -int 0


#
# Mission Control
#

# Don't show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true

# Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool true

# Don't automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Dock setup
if command -v dockutil; then
  dockutil --remove all

  dockutil --add "/System/Applications/Messages.app"
  dockutil --add "/Applications/Safari.app"
  dockutil --add "/System/Applications/Mail.app"
  dockutil --add "/Applications/Things3.app"
  dockutil --add "/Applications/Reflect.app"
  dockutil --add "/Applications/Visual Studio Code.app"
  dockutil --add "/Applications/Xcode.app"
  dockutil --add "/System/Applications/Utilities/Terminal.app"
  dockutil --add "/Applications/Slack.app"
  dockutil --add "/Applications/Linear.app"
  dockutil --add "/Applications/Notion.app"
  dockutil --add "/Applications/WhatsApp.app"
  dockutil --add "/System/Applications/Music.app"
else
  echo "dockutil not installed, re-run after installing"
fi

# Run hot corners script

# Bottom left screen corner when holding CMD key - lock screen
defaults write com.apple.dock wvous-bl-corner -int 13
defaults write com.apple.dock wvous-bl-modifier -int 1048576


#
# Terminal
#

# Disable leading [ on prompt lines (which is totally broken in anything curses)
# https://twitter.com/UINT_MIN/status/652142001932996609
defaults write com.apple.Terminal AutoMarkPromptLines -bool false
defaults write com.apple.Terminal ShowLineMarks -bool false

# Hide scrollbars in terminal
defaults write com.apple.Terminal AppleShowScrollBars -string "Automatic"

# Setup the correct theme
defaults write com.apple.Terminal "Default Window Settings" -string "Chalk"
defaults write com.apple.Terminal "Startup Window Settings" -string "Chalk"

# Set login command to make it not noisy on open
defaults write com.apple.Terminal "Shell" -string "login -fpql ham ${BREW_PREFIX}/bin/zsh"

# Close Terminal without warnings
/usr/libexec/PlistBuddy "$HOME/Library/Preferences/com.apple.Terminal.plist" \
    -c "add ':Window Settings:ham:warnOnShellCloseAction' integer 0"



#
# Displays
#

defaults write com.apple.systemuiserver menuExtras -array \
  "/System/Library/CoreServices/Menu Extras/AirPort.menu" \
  "/System/Library/CoreServices/Menu Extras/Battery.menu" \
  "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
  "/System/Library/CoreServices/Menu Extras/Clock.menu" \
  "/System/Library/CoreServices/Menu Extras/Volume.menu"

# Enable HiDPI display modes (requires restart)
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true


#
# Power Settings
#

# To stop the display from half dimming before full display 'sleep'
# http://developer.apple.com/library/mac/#documentation/Darwin/Reference/ManPages/man1/pmset.1.html
sudo pmset -a halfdim 0

# Sleep options
sudo pmset -a displaysleep 5
sudo pmset -a sleep 0
sudo pmset -a disksleep 0

# Wake for network access
sudo pmset -a womp 1

# Don't restart after power failure
sudo pmset -a autorestart 0

# Wake computer when laptop is opened
sudo pmset -a lidwake 1

# Don't wake computer when power source changes
sudo pmset -a acwake 0

# Disable sudden motion sensor
sudo pmset -a sms 0

# Power button behavior
defaults write com.apple.loginwindow PowerButtonSleepsSystem -bool NO


#
# Keyboard
#

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15


#
# Mouse/Trackpad
#

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad: enable bottom right corner to right-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# Trackpad: disable three finger tap
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerTapGesture -int 0
defaults -currentHost write NSGlobalDomain com.apple.trackpad.threeFingerTapGesture -int 0

# Trackpad: enable two finger pinch
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadPinch -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.pinchGesture -int 1

# Trackpad: 'smart zoom' two finger double tap
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerDoubleTapGesture -int 0
defaults -currentHost write NSGlobalDomain com.apple.trackpad.twoFingerDoubleTapGesture -int 0

# Trackpad: enable trackpad rotate
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRotate -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.rotateGesture -int 1

# Trackpad: disable swipe from right to show notification center
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 0
defaults -currentHost write NSGlobalDomain com.apple.trackpad.twoFingerFromRightEdgeSwipeGesture -int 0

# Tracking Speed
# 0: Slow
# 3: Fast
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 3

# Force Click and haptic feedback
defaults write NSGlobalDomain com.apple.trackpad.forceClick -bool true
defaults write com.apple.AppleMultitouchTrackpad ForceSuppressed -bool false
defaults write com.apple.AppleMultitouchTrackpad ActuateDetents -bool true

# Silent clicking
defaults write com.apple.AppleMultitouchTrackpad ActuationStrength -int 0

# Haptic feedback
# 0: Light
# 1: Medium
# 2: Firm
defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 0
defaults write com.apple.AppleMultitouchTrackpad SecondClickThreshold -int 0

# Use scroll gesture with the Ctrl (^) modifier key to zoom
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144


#
# Sound
#

# Disable the system alert sound
defaults write NSGlobalDomain com.apple.sound.beep.volume -int 0
defaults write NSGlobalDomain com.apple.sound.uiaudio.enabled -int 0

# Enable volume change feedback
defaults write NSGlobalDomain com.apple.sound.beep.feedback -bool true

#
# Date/Time
#

# Setup the menu bar date format
defaults write com.apple.menuextra.clock DateFormat -string "EEE HH:mm:ss"

# Flash the : in the menu bar
defaults write com.apple.menuextra.clock FlashDateSeparators -bool false

# 24 hour time
defaults write NSGlobalDomain AppleICUForce24HourTime -bool true
defaults write NSGlobalDomain AppleICUTimeFormatStrings -dict \
  1 -string "H:mm" \
  2 -string "H:mm:ss" \
  3 -string "H:mm:ss z" \
  4 -string "H:mm:ss zzzz"


#
# Battery Percentage
#

defaults write com.apple.menuextra.battery ShowPercent -bool true

#
# Spotlight
#

# Ditto-specific
sudo defaults write /System/Volumes/Data/.Spotlight-V100/VolumeConfiguration.plist Exclusions -array-add "$HOME/ditto"


#
# Finder
#

# Hide all icons on desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

# Hide dotfiles
defaults write com.apple.finder AppleShowAllFiles -bool false

# Finder: disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show Path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Allow text selection in QuickLook
defaults write com.apple.finder QLEnableTextSelection -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Finder: new window location set to $HOME. Same as Finder > Preferences > New Finder Windows show
# For other path use "PfLo" and "file:///foo/bar/"
defaults write com.apple.finder NewWindowTarget -string PfLo
defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME/"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Default to local files instead of iCloud
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true

# Should remove downloaded from the internet warnings
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Enable highlight hover effect for the grid view of a stack (Dock)
defaults write com.apple.dock mouse-over-hilite-stack -bool true

# Show the ~/Library folder
chflags nohidden ~/Library

# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Don't use tabs in Finder
defaults write com.apple.finder AppleWindowTabbingMode -string "manual"

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Show item info near icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy name" ~/Library/Preferences/com.apple.finder.plist

# Increase grid spacing for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 64" ~/Library/Preferences/com.apple.finder.plist

# Increase the size of icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist

# Set the finder window toolbar to have slightly altered icons
defaults write com.apple.finder "NSToolbar Configuration Browser" '{
  "TB Default Item Identifiers" =     (
    "com.apple.finder.BACK",
    NSToolbarFlexibleSpaceItem,
    "com.apple.finder.SWCH",
    "com.apple.finder.ARNG",
    "com.apple.finder.ACTN",
    "com.apple.finder.SHAR",
    "com.apple.finder.LABL",
    NSToolbarFlexibleSpaceItem,
    NSToolbarFlexibleSpaceItem,
    "com.apple.finder.SRCH"
  );
  "TB Display Mode" = 2;
  "TB Item Identifiers" =     (
    "com.apple.finder.BACK",
    NSToolbarFlexibleSpaceItem,
    "com.apple.finder.SWCH",
    "com.apple.finder.ARNG",
    "com.apple.finder.ACTN",
    "com.apple.finder.SHAR",
    NSToolbarFlexibleSpaceItem,
    NSToolbarFlexibleSpaceItem,
    "com.apple.finder.SRCH"
  );
}'

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Remove all tags from contextual menu
/usr/libexec/PlistBuddy -c "Delete :FavoriteTagNames" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Add :FavoriteTagNames array" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Add :FavoriteTagNames:0 string" ~/Library/Preferences/com.apple.finder.plist


#
# Safari/WebKit
#

# Show developer tools
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Disable Webkit start page
defaults write org.webkit.nightly.WebKit StartPageDisabled -bool true

# Set Safari's home page to 'about:blank' for faster loading
defaults write com.apple.Safari HomePage -string "about:blank"

# Prevent Safari from opening 'safe' files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Hide Safari’s sidebar in Top Sites
defaults write com.apple.Safari ShowSidebarInTopSites -bool false

# Auto clear downloads
defaults write com.apple.Safari DownloadsClearingPolicy -int 2

# Don't fill passwords
defaults write com.apple.Safari AutoFillPasswords -bool false
defaults write com.apple.Safari AutoFillCreditCardData -int 0

# Show full URL in Safari
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Show status bar
defaults write com.apple.Safari ShowStatusBar -bool true
defaults write com.apple.Safari ShowStatusBarInFullScreen -bool true

# Toolbar setup
/usr/libexec/PlistBuddy -c "Delete :NSToolbar\\ Configuration\\ BrowserToolbarIdentifier-v2:TB\\ Item\\ Identifiers" ~/Library/Preferences/com.apple.Safari.plist &>/dev/null
/usr/libexec/PlistBuddy -c "Add :NSToolbar\\ Configuration\\ BrowserToolbarIdentifier-v2:TB\\ Item\\ Identifiers array" ~/Library/Preferences/com.apple.Safari.plist
items=(BackForwardToolbarIdentifier NSToolbarFlexibleSpaceItem InputFieldsToolbarIdentifier NSToolbarFlexibleSpaceItem ShareToolbarIdentifier)

for i in "${!items[@]}"; do
  /usr/libexec/PlistBuddy -c "Add :NSToolbar\\ Configuration\\ BrowserToolbarIdentifier-v2:TB\\ Item\\ Identifiers:$i string ${items[$i]}" ~/Library/Preferences/com.apple.Safari.plist
done

#
# Mail
#

# Only take address@example.com when copying email addresses in main
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false


#
# Messages
#

# Hide scrollbars in Messages.app
defaults write com.apple.iChat AppleShowScrollBars -string Automatic

# Disable smart quotes as it’s annoying for messages that contain code
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add automaticQuoteSubstitutionEnabled -bool false


#
# Other Applications
#

# Disable new disks for time machine warning
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true


#
# Other Interface changes
#

# Set Help Viewer windows to non-floating mode
defaults write com.apple.helpviewer DevMode -bool true

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true


#
# Other subtle changes
#

# Save screenshots to an iCloud Drive directory
defaults write com.apple.screencapture location -string "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Screenshots"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string png

# Finally disable opening random Apple photo applications when plugging in devices
# https://twitter.com/stroughtonsmith/status/651854070496534528
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Enable automatic update & download
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool true

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Shows ethernet connected computers in airdrop
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0
# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4


#
# X11
#

# Clipboard syncing
defaults write org.macosforge.xquartz.X11 sync_clipboard_to_pasteboard -bool true
defaults write org.macosforge.xquartz.X11 sync_pasteboard -bool true
defaults write org.macosforge.xquartz.X11 sync_pasteboard_to_clipboard -bool true
defaults write org.macosforge.xquartz.X11 sync_pasteboard_to_primary -bool true
defaults write org.macosforge.xquartz.X11 sync_primary_on_select -bool false

# Run xterm by default (without this vim's clipboard doesn't work)
defaults write org.macosforge.xquartz.X11 app_to_run -string /opt/X11/bin/xterm

# Set default shell
defaults write org.macosforge.xquartz.X11 login_shell -string "${BREW_PREFIX}/bin/zsh"


#
# Xcode
#

# Trim trailing whitespace
defaults write com.apple.dt.Xcode DVTTextEditorTrimTrailingWhitespace -bool true

# Trim whitespace only lines
defaults write com.apple.dt.Xcode DVTTextEditorTrimWhitespaceOnlyLines -bool true

# Show line numbers
defaults write com.apple.dt.Xcode DVTTextShowLineNumbers -bool true

# Hide the code folding ribbon
defaults write com.apple.dt.Xcode DVTTextShowFoldingSidebar -bool false

# Enable automatic updates
defaults write com.apple.dt.Xcode DVTDownloadableAutomaticUpdate -bool true

# Live issues
defaults write com.apple.dt.Xcode IDEEnableLiveIssues -bool true

# Setup page guide
defaults write com.apple.dt.Xcode DVTTextShowPageGuide -bool true
defaults write com.apple.dt.Xcode DVTTextPageGuideLocation -int 110

# Enable internal debug menu
defaults write com.apple.dt.Xcode ShowDVTDebugMenu -bool true

# Source control local revision side
defaults write com.apple.dt.Xcode DVTComparisonOrientationDefaultsKey -int 0

# Use custom derived data location
#defaults write com.apple.dt.Xcode IDECustomDerivedDataLocation -string build.noindex

# Show build times in toolbar
# http://cocoa.tumblr.com/post/131023038113/build-speed
defaults write com.apple.dt.Xcode ShowBuildOperationDuration -bool true

# Add more information to Xcode's build output about why specific commands are being run
# https://twitter.com/bdash/status/661742266487205888
# http://www.openradar.me/27516128
defaults write com.apple.dt.Xcode ExplainWhyBuildCommandsAreRun -bool true

# Disable the print keyboard shortcut in Xcode. I accidentally hit this a lot
defaults write com.apple.dt.Xcode NSUserKeyEquivalents -dict-add "Print..." "nil"

# Show indexing progress
# https://twitter.com/dmartincy/status/1034930612543676418
defaults write com.apple.dt.Xcode IDEIndexerActivityShowNumericProgress -bool true

# Make command click jump to definition instead of showing the menu
defaults write com.apple.dt.Xcode IDECommandClickNavigates -bool YES


#
# Third Party
#

# Contexts
defaults write com.contextsformac.Contexts CTAppearanceTheme CTAppearanceNamedVibrantDark
defaults write com.contextsformac.Contexts CTPreferenceSidebarDisplayMode CTDisplayModeNone

echo "Done. Note that some of these changes require a logout/restart to take effect."
