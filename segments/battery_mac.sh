#!/usr/bin/env bash

HEART_CONNECTED=♥
HEART_DISCONNECTED=♡
THRESHOLD=45

case $(uname -s) in
    "Darwin")
        ioreg -c AppleSmartBattery -w0 | \
        grep -o '"[^"]*" = [^ ]*' | \
        sed -e 's/= //g' -e 's/"//g' | \
        sort | \
        while read key value; do
            case $key in
                "MaxCapacity")
                    export maxcap=$value;;
                "CurrentCapacity")
                    export curcap=$value;;
                "ExternalConnected")
                    export extconnect=$value;;
            esac
            if [[ -n $maxcap && -n $curcap && -n $extconnect ]]; then
                export percent=$(( 100 * $curcap / $maxcap ))
                if [[ "$curcap" == "$maxcap" ||  "$percent" -ge "$THRESHOLD"  ]]; then
                    exit
                fi
                # if [[ "$percent" -le "$THRESHOLD" ]]; then
                    # exit
                # fi
                if [[ "$extconnect" == "Yes" ]]; then
                    echo $HEART_CONNECTED $percent"%"
                else
                    echo $HEART_DISCONNECTED $percent"%"
                fi
                break
            fi
        done
esac
