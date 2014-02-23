#!/bin/bash
#
# Turns on Numlock  
 
echo "$1" | grep -q "New" > /dev/null 2>&1

if [ $? -eq 0 ];
then
	xset led 1
	
else 
	xset -led 1
fi

echo "$1"
