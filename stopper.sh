#!/bin/bash -v

#ps aux | grep -v grep | grep ruby && ps aux | grep -v grep | grep ruby | awk '{print $2}' | xargs kill -9
ps -ef |  grep -v grep | grep ruby && ps aux | grep -v grep | grep ruby | awk '{print $2}' | xargs kill -9;
bash