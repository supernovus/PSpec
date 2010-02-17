#!/usr/local/bin/perl6

use v6;

BEGIN { @*INC.unshift('lib'); }

use Pickle;

my $found = '';
my @found;

handle-story( 
    lines("t/stories/multiline.story"),
    -> $line {
        given matching $line {
            if $line ~~ Pair {
                when /:s value is\: $/ {
                    #diag "Found a multiline value:";
                    #diag $line.value.join("\n# ");
                    @found = @($line.value);
                }
                when /:s result is\: $/ {
                    #diag "Found a multiline result:";
                    #diag $line.value.join("\n# ");
                    my @flipped  = @found>>.flip;
                    my $result   = @flipped.join("\n");
                    my $expected = $line.value.join("\n");
                    assert $result should-be $expected;
                }
            }        
            when /:s value is\: (.+) $/ {
                #diag "Found a single value:";
                #diag "$0";
                $found = ~$0;
            }
            when /:s result is\: (.+) $/ {
                #diag "Found a singe result:";
                #diag "$0";
                assert $found.flip should-be ~$0;
            }
        }
    },
);

## End of tests

