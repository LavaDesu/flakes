#!/bin/sh
#
# Super simple script that saves clock to file and reads from it later
# Something like fake-hwclock from debian
# CC0-1.0

CMD="${1:-save}"

if [ ! -v FILE ]; then
    echo 'missing $FILE'
    exit 64
fi

case $CMD in 
    save)
        date -u '+%Y-%m-%d %H:%M:%S' > $FILE
        ;;
    load)
        if [ ! -e $FILE ]; then
            echo "attempted to load from nonexistent file"
            exit 65
        fi
        NEW=$(cat $FILE)
        date -u -s "$NEW"
        ;;
    *)
        echo "unknown subcommand"
        exit 66
        ;;
esac
