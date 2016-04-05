#!/bin/bash

# Setup CD/DVD tools for OSX
if [ "$SYSTYPE" == "mac" ]; then
    export CDR_DEVICE=1,0,0
    export CDR_SPEED=40
    export CDR_FIFISIZE=2m
    alias cdrecord='sudo cdrecord --driveropts=burnfree -eject'
fi

