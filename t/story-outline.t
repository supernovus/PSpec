#!/usr/local/bin/perl6

use v6;

BEGIN { @*INC.unshift('lib'); }

use Pickle;
use Story;

handle-story( 
    lines("t/stories/outline.story"),
    Story::default-handler(),
);

## End of tests

