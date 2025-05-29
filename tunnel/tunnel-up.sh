#!/bin/bash

ssh -f -N -4 -L localhost:3011:ip-lan-srv-libre-translate:3011 usr-tunnel@ip-pub-lan 

# fin
