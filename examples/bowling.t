#!/usr/local/bin/perl6

use v6;

BEGIN { @*INC.unshift('lib'); }

use PSpec;
use Bowling;
use Times;

## See PSpec for more information on 'describe', 'times' and 'should-be'.

sub bowl ($times, $hit) {
    my $bowling = Bowling.new;
    $times times { $bowling.hit($hit); }
    return $bowling;
}

describe Bowling, "score", [
    ## The first one is a direct copy from the RSpec front page.
    'returns 0 for all gutter game' => {
        my $bowling = Bowling.new;
        20 times { $bowling.hit(0) }
        $bowling.score should-be 0;
    },
    ## The following two use a subroutine to make it shorter.
    'returns 1 for a single pin' => {
        bowl(1, 1).score should-be 1;
    },
    ## And yes, this one has an intentional typo in the desired value.
    'returns 200 for 20 strikes' => {
        bowl(20, 10).score should-be 201;
    },
    ## Now we want to test something a bit more complicated.
    'the return is greater than 20 if 2 hits 11 times' => {
        bowl(11,2).score should-be ('> 20' => { $^a > 20 });
    },
    ## And now, the same thing, but with an intentional typo.
    'typo return greater than 30 if 2 hits 11 times' => {
        bowl(11,2).score should-be ('> 30' => { $^a > 30 });
    },
    ## A new comparison operator that is even simpler than the Pair array.
    'testing the new operator' => {
        bowl(11,2).score should-be ( '>', 30 );
    },
    # And if you don't care about the 'got:/expected:' stuff,
    # just pass a regular old test on as the closure.
    # Of course, the benefits of the 'got/expected' is why the
    # should-be operator exists, but anyway...
    'a regular perl test, not using should-be' => {
        bowl(11,2).score == 22;
    },
];

