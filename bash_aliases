#lsblk to list all  partitions
# to get bumblebee working ' MODULES="i915 bbswitch"  ' in mkinitcpio.conf and rcutree.rcu_idle_gp_delay=1 in grub.conf
# pacat /dev/urandom > padsp
# to enable disable services sudo update-rc.d apache2 disable
# for volume over 150: pactl set-sink-volume 0 150%  (or volume 150%)
alias volume='pactl set-sink-volume 0'
#if you wanna change timezone just copy one of /usr/share/zoneinfo/place to /etc/localtime

# I am stupid sometimes
#alias sudo vim='sudo -e'

# Notes
alias physics='vim ~/Dropbox/Notes/Physics/physics.txt'
alias chemistry='vim ~/Dropbox/Notes/Chemistry/chemistry.txt'
alias english='vim ~/Dropbox/Notes/English/english.txt'
alias swedish='vim ~/Dropbox/Notes/Swedish/swedish.txt'

#zombify
alias zombify='sudo -u dork /home/vasko/dorknet/dork zombify'

alias irc='autossh -M 0 -o "ServerAliveInterval 45" -o "ServerAliveCountMax 2" -p 80 vasko@wherewe.servebeer.com'
alias sourcel='source ~/.bash_aliases'
alias ,.='fc -e -'
alias cd..='cd ..'
alias nkill='pkill -f'
alias drop='/home/vasko/drop/dropbox_uploader.sh'
alias lo='libreoffice'
alias tuner='lingot'
alias efbterm='export TERM=fbterm'
alias listd='ls -al /dev/disk/by-uuid/*'
alias py='python3'
alias scan='iwlist wlan0 scan'
alias connect='sudo iwconfig wlan0 essid'
alias home='cd /home/vasko'
alias l='ls -F'
alias d='ls'
alias dm='ls | more'
alias e='cd'
alias en='cd ..'
alias n='clear'
alias s='sudo'
alias m='mv'
alias r='rm'
alias md='mkdir'
alias rd='rm -rf'
alias c='gcp'
alias v='vim'
alias sv='sudo vim'
alias f='gnome-commander'
alias o='less'
alias g='wget'
alias x='tar -xvzf'
alias a='tar -cvzf'
alias i='sudo pacman -S'
alias p='sudo pacman -R'
alias t='optirun'
alias ts='optirun -b none nvidia-settings -c :8'
alias tc='lsof -n /dev/nvidia0'
alias endsu='exit & sudo su'
alias iso='dd if=/dev/cdrom of=~/cdrom_image.iso'
#alias glxspheres='vblank_mode=0 /opt/VirtualGL/bin/glxspheres64'
alias tglxspheres='vblank_mode=0 optirun -vv /opt/VirtualGL/bin/glxspheres64'
alias pglxspheres='vblank_mode=0 primusrun /opt/VirtualGL/bin/glxspheres64'
alias httpserve='python -m SimpleHTTPServer'


# Screen
alias scradmin='$HOME/.ratpoison/screen_run admin'
alias scrschool='$HOME/.ratpoison/screen_run school'


# Switch layouts
alias qwerty='setxkbmap us'
alias bgkey='setxkbmap bg'
alias colemak='setxkbmap us -variant colemak'
alias svenmak='setxkbmap us2 -variant colemak'
alias ansi='setxkbmap us3 -variant colemak'

# Make mount give all users right permission
alias mount='mount -o gid=users,fmask=113,dmask=002'  

# Alias FTP mount
alias ftpmount='curlftpfs eu5.org ~/ftp/' 
alias ftpumount='umount /home/vasko/ftp'

alias desk='cd ~/Desktop' 
alias cbb='cat /proc/acpi/bbswitch' 
alias vimrc='vi ~/.vimrc'
alias aliases='vi ~/.bash_aliases'
alias solarize='~/.solarized/solarize'
alias rat='vim ~/.ratpoison/ratpoisonrc.conf'
alias screenrc='vim ~/.ratpoison/screenrc'
alias xkb='sudo vim /usr/share/X11/xkb/symbols/us'
alias pdf='apvlv'
alias kpaint='kolourpaint'
alias gnu='vrms'
alias layout='vi .rat_layout'
alias lightdm='sudo /etc/init.d/lightdm start'
alias mountem='sudo mount -t auto /dev/sda5 /mnt/sda5'
alias grub='sudo vi /etc/default/grub'
alias reboot='sudo reboot'

# Games
#alias minecraft='optirun java -Xmx1024M -Xms1024M -XX:+UseFastAccessorMethods -XX:+AggressiveOpts  -XX:+DisableExplicitGC -XX:+UseAdaptiveGCBoundary -XX:MaxGCPauseMillis=500 -XX:SurvivorRatio=16 -XX:+UseParallelGC -XX:UseSSE=3 -XX:ParallelGCThreads=2 -jar ~/.minecraft/launcher.jar'
alias amnesia='optirun /usr/games/Amnesia/Launcher.bin'
alias nethackterm='rxvt -bg black -fg green +tr &'
alias cfgpanel=' fgpanel --fg-root=/usr/share/games/flightgear --panel=Aircraft/c172p/Panels/FGPanel_c172p.xml'
alias cfgfs='optirun fgfs --generic=socket,out,20,127.0.0.1,34200,udp,../Aircraft/c172p/Panels/FGPanel_Protocol_c172p'
#alias xonotic='cd ~/.Xonotic && optirun ~/.Xonotic/xonotic-linux64-glx -sessionid vaskozl'
alias starcraft='PULSE_LATENCY_MSEC=60 optirun /usr/share/playonlinux/playonlinux --run "StarCraft II"'
alias starbound='~/games/starbound/linux64/launch_starbound.sh'

# Network tools

#scan available networks
alias wifi='sudo nmcli dev wifi'

alias ipscan='nmap -sP'
alias localscan='sudo nmap -PR -sP 192.168.0.1/24'
alias wifires='modprobe ipw2100'

# Drawing
alias mspaint='/usr/share/playonlinux/playonlinux --run "Microsoft paint"'
alias msexcel='/usr/share/playonlinux/playonlinux --run "Microsoft Excel 2010"'
alias msword='/usr/share/playonlinux/playonlinux --run "Microsoft Word 2010"'


