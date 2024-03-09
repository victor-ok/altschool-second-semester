#!/bin/bash
# list directories with disk usuage and specify -n

echo "altschool assignment submission for Victor Okafor mail: vua.okafor@gmail.com"

list_directories () {
    if [ -d "$1" ] ; then
       du -shc "$1"
       exit 1
    else
        echo "Not a dir: $1"
        exit 1
    fi
}

list_directories_num () {
    if [ -d "$2" ] ; then
        du -shc "$2" | head -"$3"
        exit 1
    else
        echo "Not a dir: $2"
        exit 1
    fi
}

if [ "$#" -lt 1 ] ; then
    echo "pass at least -d or -n argument"
elif [ "$1" == "-d" -a "$2" != "" ] ; then
    list_directories "$2"
elif [ "$1" == "-n" -a "$2" != "" -a "$3" != "" ] ; then
    list_directories_num "$2" "$3"
fi
