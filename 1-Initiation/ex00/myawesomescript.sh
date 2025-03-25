#!/bin/sh

if [ $# -eq 1 ]; then
    url="$1"

    #Make sure url = bit.ly/...
    # =~ is regex comparaison ; part of the [[ ... ]] conditional exp syntax
    if [[ "$url" =~ ^bit\.ly/ ]]; then 
        # Check HTTP status code
        # Curl -I -> return the headers only
        http_code=$(curl -sI "$1" | grep HTTP | cut -d ' ' -f2)
        url=$(curl -sI "$1" | grep Location | cut -d ' ' -f2)
        if [ "$http_code" = "301" ]; then
            end=${url: -2}
            if [ "${end:0:1}" = "/" ]; then
                length=$((${#url} - 2))
                curl -s "$1" | grep "href" | cut -d '"' -f2 | cut -c 1-$length
            else
                curl -s "$1" | grep "href" | cut -d '"' -f2
            fi
        fi
    fi
fi