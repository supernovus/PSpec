#!/bin/bash

die() {
    echo "$@"
    exit 1
}

noext() {
    echo $1 | perl -pe 's/\.\w+$//g'
}

compile() {
    echo "Compiling $1.pm => $1.pir"
    perl6 --target=pir --output=$1.pir $1.pm
}

getmodule() {
    TDIR=./lib/
    [ -n "$2" ] && TDIR=$2
    MODULE="${TDIR}`echo $1 | sed -e 's|::|/|g'`"
}

clean() {
    [ -f $1.pir ] && rm -v $1.pir
}

[ $# -lt 1 ] && die "must specify a command or module name"

case "$1" in
    clean|-C)
        if [ -n "$2" ]; then
            getmodule $2
            clean $MODULE
        else
            find lib -name '*.pir' -exec rm -v {} \;
        fi
    ;;
    compile|-c)
        if [ -n "$2" ]; then
            getmodule $2 ./
            pushd lib
            clean $MODULE
            compile $MODULE
            popd
        else
            pushd lib
            for file in `find . -name '*.pm'`; do
                src=`noext $file`
                if [ ! -f "$src.pir" ]; then
                    compile $src
                fi
            done
            popd
        fi
    ;;
    *)
        getmodule $1
        clean $MODULE
        [ ! -f "$MODULE.pm" ] && die "could not find $MODULE.pm"
        $EDITOR $MODULE.pm
    ;;
esac

