#!/bin/sh
cd /Users/andrew/Dropbox/Alfred/extensions/scripts/Ping/
ping -c5 192.168.1.139 | perl ./parse.pl
