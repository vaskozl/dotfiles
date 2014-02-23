#!/usr/bin/env bash
# Inspiration:
#  http://www.desertsol.com/~kevin/ratpoison/
ratpoison_dir=$HOME/.ratpoison
ratpoison=/usr/bin/ratpoison
xtoolwait="/usr/bin/X11/xtoolwait -timeout 10"
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

# Load xterm colors
xrdb -merge ~/.Xresources
# Start Dropbox
dropbox start
# Start Offline Imap
offlineimap &

# Start calendar sync
#$HOME/.calendar/run

# Detect secondary monitor and automatically adjust
if [ `xrandr| grep -c VGA1` -gt 0 ]; then
     xrandr --output VGA1 --mode `xrandr | awk 'NR==9 {print $1}'` --right-of LVDS1
fi

# Fix rodentss
xinput --set-prop "SynPS/2 Synaptics TouchPad" 296 -106, -106
synclient PalmDetect=1
xinput --set-prop "SynPS/2 Synaptics TouchPad" "Synaptics Noise Cancellation" 50 50
xinput --set-prop "Logitech Gaming Mouse G400" "Device Accel Profile" -1
xinput --set-prop "Logitech Gaming Mouse G400" "Device Accel Velocity Scaling" 1
xset r rate 200 30


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
#
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
    $xtoolwait $term $screen_run admin
    number_and_title 0 "admin screen"
fi

# workspace 5 : School
#     windows 1: screen notebok
if [ $run_everything = true -o $run_workspace = 5 ]; then
    $workspace 5
    cd $HOME/Dropbox/notes
    $xtoolwait $term $screen_run school
    number_and_title 0 "notebook"
fi

## workspace 6 : projects workspace
if [ $run_everything = true -o $run_workspace = 6 ]; then
    $workspace 6
    $xtoolwait $term $screen_run projects
    number_and_title 0 "projects screen"
fi
#
## workspace 7 : kde workspace (VNC session)
#if [ $run_everything = true -o $run_workspace = 7 ]; then
#    $workspace 7
#    $xtoolwait vncviewer nerd:1
#    number_and_title 0 "kde"
#fi
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
    $xtoolwait $term irssi
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
#     window 1+: Firefox
if [ $run_everything = true -o $run_workspace = 2 ]; then
    $workspace 2
    firefox 
    number_and_title 0 "firefox"
fi

# Default workspace: 1(ranger)
	$workspace 1

# Launch locking program
xscreensaver -no-splash

#######################################################################
sleep 1
if [ $run_everything = true ]; then
    wait $wmpid
fi
