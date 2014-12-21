!/usr/bin/env bash
# Inspiration:
#  http://www.desertsol.com/~kevin/ratpoison/
ratpoison_dir=$HOME/.ratpoison
ratpoison=/usr/bin/ratpoison
xtoolwait="timeout --signal=KILL 5 /usr/bin/xtoolwait -timeout 10"
workspace="/usr/bin/rpws"
screen_run="$ratpoison_dir/screen_run"
term="/usr/bin/urxvt -e"

# Set the current window's number and title
# $1 = number
# $2 = title (remember to quote if title has spaces)
function number_and_title() {
	$ratpoison -c "number $1"
	$ratpoison -c "title $2"
}

#######################################################################
#
# If this script is run with no arguments, ratpoison and all workspaces are loaded.
# If a workspace number is given as the argument, only that workspace is initialized.
#
#######################################################################

# Launch config files
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi


# Background
nitrogen --restore

#Run dropbox
dropboxd &

#Keyboard Bindings
setxkbmap us -variant colemak
xcape -t 300 -e 'Shift_L=parenleft;Shift_R=parenright;Hyper_L=Shift_L|exclam;Hyper_R=Shift_L|question' &
xset r 64
xset r rate 180 40
xset m 0 0 

# Launch locking program
xautolock -detectsleep -locker 'i3lock -i ~/Pictures/1440.png' -time 11 -corners 0-00 &

# Load xterm colors
xrdb -merge ~/.Xresources
xrdb -merge ~/.Xdefaults
# Start some programs
#dropbox start
~/bin/offline-run
#~/bin/xflux -z 24531 -l 56 -g 13
#sudo nm-applet &

#Disable annoying point tap
synclient PalmDetect=1
synclient TapButton1=1
synclient TapButton2=3
synclient TapButton3=2
synclient TapAndDragGesture=0
synclient VertEdgeScroll=0  RTCornerButton=0  RBCornerButton=0  LTCornerButton=0  LBCornerButton=0    FingerHigh=37  FingerLow=35  FingerPress=100 
#Natural Scrolling 
xmodmap -e "pointer = 1 2 3 5 4 7 6 8 9 10 11 12"

# Detect secondary monitor and automatically adjust
if [ `xrandr| grep -c VGA1` -gt 0 ]; then
     xrandr --output VGA1 --mode `xrandr | awk 'NR==9 {print $1}'` --right-of LVDS1
     xrandr --output VGA1 --mode 1920x1080 --right-of LVDS1 
fi


if [ $# -lt 1 ]; then
    # if no arguments given, run everything 
    run_everything=true
    run_workspace=all
else
    # if 1 argument given, run that workspace
    run_everything=false
    run_workspace=$1
fi

#
# Startup the ratpoison window manager first

if [ $run_everything = true ]; then
    $ratpoison 2>&1 &
    wmpid=$!
    sleep 1 &
fi
#######################################################################
#
# I create a section for each workspace so that individual workspaces 
# can be reloaded without reloading ratpoison, which doesn't work so well.
#
#######################################################################

# workspace 0 : volume workspace
#     window 1: volume 
#if [ $run_everything = true -o $run_workspace = 2 ]; then
#    $workspace 0
#    $xtoolwait $term alsamixer
#    number_and_title 0 "volume"
#fi


# workspace 1 : Ranger workspace
#     window 1+: Ranger
if [ $run_everything = true -o $run_workspace = 1 ]; then
    $workspace 1
    $xtoolwait $term  ranger 
    number_and_title 0 "ranger"
fi

# workspace 2 is at the end (pentadactyl) slowing down

# workspace 3 : newsbeuter
if [ $run_everything = true -o $run_workspace = 3 ]; then
    $workspace 3
    $xtoolwait $term newsbeuter
    number_and_title 0 "newsbeuter"
fi

# workspace 4 : admin workspace
#     window 1: screen (see screenrc.admin for the screen config)
if [ $run_everything = true -o $run_workspace = 4 ]; then
    $workspace 4
#    $xtoolwait $term $screen_run admin
    number_and_title 0 "admin screen"
fi

# workspace 5 : School
#     windows 1: screen notebok
if [ $run_everything = true -o $run_workspace = 5 ]; then
    $workspace 5
    cd $HOME/Dropbox/notes
#    $xtoolwait $term $screen_run school
    number_and_title 0 "notebook"
fi

## workspace 6 : projects workspace
if [ $run_everything = true -o $run_workspace = 6 ]; then
    $workspace 6
#    $xtoolwait $term $screen_run projects
    number_and_title 0 "projects screen"
fi
#
## workspace 7 : kde workspace (VNC session)
#if [ $run_everything = true -o $run_workspace = 7 ]; then
#    $workspace 7
#    $xtoolwait vncviewer nerd:1
#    number_and_title 0 "kde"
#fi

# workspace 7 : skype workspace 
if [ $run_everything = true -o $run_workspace = 7 ]; then
    $workspace 7
#    skype &
#    number_and_title 0 "skype"
    sleep 6
fi

#
## workspace 8 : windows workspace (VMware session)
#if [ $run_everything = true -o $run_workspace = 8 ]; then
#    $workspace 8
#    #$xtoolwait gnomesu -c /stor/vmware/bin/vmware
#    #number_and_title 0 "windows xp"
#fi
#

# workspace 9 : email workspace
#     window 1: mutt 
if [ $run_everything = true -o $run_workspace = 2 ]; then
    $workspace 9
    $xtoolwait $term mutt
    number_and_title 0 "email"
fi

# workspace 10 : irc workspace
#     window 1: irc 
if [ $run_everything = true -o $run_workspace = 2 ]; then
    $workspace 10
    $xtoolwait $term $screen_run irssi
#    $xtoolwait $term irssi
    number_and_title 0 "irc"
fi

# workspace 11 : wifi workspace
#     window 1: wicd 
if [ $run_everything = true -o $run_workspace = 2 ]; then
    $workspace 11
    $xtoolwait $term  wicd-curses
    number_and_title 0 "wicd"
fi

# workspace 12 : music workspace
#     window 1: music 
if [ $run_everything = true -o $run_workspace = 2 ]; then
    $workspace 12
    cd $HOME/Music	
    $xtoolwait $term cmus
    $ratpoison -c "meta 2"
    number_and_title 0 "music"
fi

# workspace 13 : volume workspace
#     window 1: volume 
if [ $run_everything = true -o $run_workspace = 2 ]; then
    $workspace 13
    $xtoolwait $term alsamixer
    number_and_title 0 "volume"
fi

# workspace 2 : Firefox workspace
#     window 1+: firefox
if [ $run_everything = true -o $run_workspace = 2 ]; then
    $workspace 2
    firefox &
    number_and_title 0 "firefox"
fi

# Default workspace: 1(ranger)
#	$workspace 1

xfce4-panel --disable-wm-check &
sleep 2 && rpbar

#######################################################################
sleep 1
if [ $run_everything = true ]; then
    wait $wmpid
fi
