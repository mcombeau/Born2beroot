#!bin/bash

sleep $(bc <<< $(bc <<< $(uptime -s | cut -d ":" -f 2)%10*60+$(uptime -s | cut -d ":" -f 3)))
