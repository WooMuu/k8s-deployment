#!/bin/bash
if  [ ! $(rpm -qa | grep $1) ]; then
    exit 1
else
    exit 0
fi
