#!/usr/local/bin/perl6

use v6;

BEGIN { @*INC.unshift('lib'); }

use PSpec;
use Story;

handle-story( 
    lines("t/stories/basic.story"),
    Story::default-handler(),
);

## End of tests

