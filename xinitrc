#!/usr/bin/bash
# Inspiration:
#  http://www.desertsol.com/~kevin/ratpoison/
ratpoison_dir=$HOME/.ratpoison
ratpoison=/usr/bin/ratpoison
xtoolwait="timeout --signal=KILL 5 $ratpoison_dir/xtoolwait -noprop"
workspace="bspc desktop -f"
screen_run="$ratpoison_dir/screen_run"
term="/usr/bin/urxvt -e"


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

# give cursor
xsetroot -cursor_name left_ptr 

# Fix annoying blank java bug
wmname LG3D

# Background
~/.ratpoison/wp change &

# Init clipboard
~/.ratpoison/clipboard init

#Run dropbox
dropboxd &
~/bin/mountsecure

# Allow user to edit brightness
sudo /usr/bin/brightchown

# Custom
~/.custom

#Keyboard Bindings
setxkbmap us -variant colemak
xcape -t 300 -e 'Shift_L=parenleft;Shift_R=parenright;Hyper_L=Shift_L|exclam;Hyper_R=Shift_L|question' &
xset r 64
xset r rate 170 60
xset m 0 0 
xset -b

# Launch locking program
#xautolock -detectsleep -locker '~/.ratpoison/lock' -time 11 -corners 0-00 &

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
#if [ `xrandr| grep -c HDMI1` -gt 0 ]; then
#     xrandr --output HDMI1 --mode `xrandr | awk 'NR==9 {print $1}'` --right-of LVDS1
#     xrandr --output HDMI1 --mode 1920x1080 --right-of LVDS1 
#fi


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
sxhkd &
if [ $run_everything = true ]; then
    bspwm 2>&1 &
    ~/.config/bspwm/bspwmrc
#    compton & 
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
    $workspace ^1
    $xtoolwait $term  ranger 
fi

# workspace 2 is at the end (pentadactyl) slowing down

# workspace 3 : newsbeuter
if [ $run_everything = true -o $run_workspace = 3 ]; then
    $workspace ^2
    $xtoolwait $term newsbeuter
fi

# workspace 4 : admin workspace
#     window 1: screen (see screenrc.admin for the screen config)
if [ $run_everything = true -o $run_workspace = 4 ]; then
    $workspace ^4
#    $xtoolwait $term $screen_run admin
fi

# workspace 5 : School
#     windows 1: screen notebok
if [ $run_everything = true -o $run_workspace = 5 ]; then
    $workspace ^4
    cd $HOME/Dropbox/notes
#    $xtoolwait $term $screen_run school
fi
#
## workspace 7 : kde workspace (VNC session)
#if [ $run_everything = true -o $run_workspace = 7 ]; then
#    $workspace ^7
#    $xtoolwait vncviewer nerd:1
#    number_and_title 0 "kde"
#fi

# workspace 7 : skype workspace 
if [ $run_everything = true -o $run_workspace = 7 ]; then
    $workspace ^6
#    skype &
#    number_and_title 0 "skype"
    sleep 6
fi

#
## workspace 8 : windows workspace (VMware session)
#if [ $run_everything = true -o $run_workspace = 8 ]; then
#    $workspace ^8
#    #$xtoolwait gnomesu -c /stor/vmware/bin/vmware
#    #number_and_title 0 "windows xp"
#fi
#

# workspace 9 : email workspace
#     window 1: mutt 
if [ $run_everything = true -o $run_workspace = 2 ]; then
    $workspace ^8
    $xtoolwait $term mutt
fi

# workspace 10 : irc workspace
#     window 1: irc 
if [ $run_everything = true -o $run_workspace = 2 ]; then
    $workspace ^9
    $xtoolwait $term $screen_run irssi
#    $xtoolwait $term irssi
fi

# workspace 11 : wifi workspace
#     window 1: wicd 
if [ $run_everything = true -o $run_workspace = 2 ]; then
    $workspace ^10
    $xtoolwait $term sudo wpa_supplicant -i wlp2s0 -c /etc/wpa_supplicant/wpa_supplicant-wlp2s0.conf
fi

# workspace 12 : music workspace
#     window 1: music 
if [ $run_everything = true -o $run_workspace = 2 ]; then
    $workspace ^11
    mpd
    $xtoolwait $term ncmpcpp
fi

# workspace 13 : volume workspace
#     window 1: volume 
if [ $run_everything = true -o $run_workspace = 2 ]; then
    $workspace ^12
    $xtoolwait $term alsamixer
fi

# workspace 2 : Uzbl workspace
if [ $run_everything = true -o $run_workspace = 2 ]; then
    $workspace ^2
    firefox &
fi

# Default workspace: 1(ranger)
#	$workspace ^1

#~/.ratpoison/panel/panel &
#sleep 2 && rpbar

#######################################################################
sleep 1
if [ $run_everything = true ]; then
    wait $wmpid
fi
