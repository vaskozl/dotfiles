#!/bin/bash
# Note to make xset led 1 and 2 work:
#
#   /usr/share/X11/xkb/compat/ledcaps
#   /usr/share/X11/xkb/compat/lednum
#   and replace:
#       !allowExplicit;
#   with:
#       allowExplicit;
#
#####################k
# Turns on CapsLock  
#
 
echo "$1"
echo "$1" | grep -q "New" > /dev/null 2>&1
status=$?

if [ $status -eq 0 ];then
	xset led 1
	touch ~/.mutt/newmail
else 
	xset -led 1
if [ -e ~/.mutt/newmail ];then 
	rm ~/.mutt/newmail
fi
fi
