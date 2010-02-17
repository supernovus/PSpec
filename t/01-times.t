#!/usr/local/bin/perl6

use v6;

BEGIN { @*INC.unshift('lib'); }

use PSpec;

describe "PSpec", "times", [
    'operator works' => {
        my $value = 0;
        20 times { $value++ }
        $value should-be 20;
    },
    "method works" => {
        my $value = 0;
        25.times: { $value++ }
        $value should-be 25;
    },
    "overloaded x operator" => {
        my $value = 0;
        { $value++ } x 30;
        $value should-be 30;
    },
];

## End of tests

