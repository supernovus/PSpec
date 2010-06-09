#!/usr/local/bin/perl6

use v6;

BEGIN { @*INC.unshift('lib'); }

use PSpec;
use Times;
#use Times :ALL;

describe "PSpec", "times", [
    'operator works' => {
        my $value = 0;
        20 times { $value++ }
        $value should-be 20;
    },
    "overloaded x operator" => {
        my $value = 0;
        { $value++ } x 30;
        $value should-be 30;
    },
];

## End of tests

