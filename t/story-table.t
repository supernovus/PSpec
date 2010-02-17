#!/usr/local/bin/perl6

use v6;

BEGIN { @*INC.unshift('lib'); }

use Pickle;
use Calculator;

our $calculator = Calculator.new;

handle-story( 
    lines("t/stories/table.story"),
    -> $line {
        given matching $line {
            if $line ~~ Table {
                when /:s operations on the following table/ {
                    my @ops = $line.hashes;
                    #diag "++ " ~ @ops.perl;
                    for @ops -> $op {
                        #diag "-- " ~ $op.perl;
                        $calculator.push: +$op<number>;
                        $calculator."{$op<operation>}";
                    }
                }
                when /:s the following (numbers|operations)/ {
                    my $what = $0;
                    my @flat = $line.flatten;
                    #diag @flat.perl;
                    for @flat -> $flat {
                        if !$flat { next; }
                        if $what eq 'numbers' {
                            #diag "++ Pushing $flat";
                            $calculator.push: +$flat;
                        }
                        else {
                            #diag "-- Performing $flat";
                            $calculator."$flat";
                            #diag "Value is "~ $calculator.last;
                        }
                    }
                }
                when /:s the following table/ {
                    for @($line) -> $table {
                        #diag $table.perl;
                        my $number = $table.shift;
                        for @($table) -> $sub {
                            #diag "--# $number - $sub";
                            $number -= $sub;
                        }
                        #diag "==# $number";
                        $calculator.push: +$number;
                    }
                }
            }        
            when / Scenario\: / {
                $calculator.clear;
            }
            when /:s the result should be (\d+)/ {
                assert $calculator.total should-be +$0;
            }
            when /:s an initial value of (\d+)/ {
                $calculator.push: +$0;
            }
        }
    },
);

## End of tests

