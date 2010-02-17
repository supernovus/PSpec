#!/usr/local/bin/perl6

use v6;

BEGIN { @*INC.unshift('lib'); }

use Pickle;
use Story;

handle-story( 
    lines("t/stories/chain.story"),
    Story::default-handler(),
    -> $line {
        given $line {
            when /:s \w+ (increment|decrement) (\d+) by (\d+) / {
                declare "initial value of $1";
                declare "$0 $2 times";
            }
            when /:s take (\d+) (\d+) steps higher and (\d+) steps lower / {
                declare "initial value of $0";
                declare "increment $1 times";
                declare "decrement $2 times";
            }
        }
    },
);

## End of tests

