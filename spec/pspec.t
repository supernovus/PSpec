#!/usr/local/bin/perl6

use v6;

BEGIN { @*INC.unshift('lib'); }

use PSpec;

sub MAIN ( $verbose=0 ) {

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
    }
];

my $value;

handle-story( 
    lines("spec/stories/pspec.story"),
    :verbose($verbose),
    -> $line {
        given $line {

            ## A rule for entering the numbers.
            when /:s initial value of (\d+)/ {
                $value = +$0;
            }

            ## One for incrementing.
            when /:s increment (\d+) times/ {
                +$0.Int times { $value++ }
            }

            ## One for decrementing.
            when /:s decrement (\d+) times/ {
                +$0.Int times { $value-- }
            }

            ## Finally, a way to get back the results.
            when /:s value should be (\d+)/ {
                assert $value should-be +$0;
            }

        }
    }
);

}
## End of tests

