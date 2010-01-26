#!/usr/local/bin/perl6

use v6;

BEGIN { @*INC.unshift('lib'); }

use PSpec;
use Calculator;

our $calculator = Calculator.new;

handle-story( 
    lines("spec/stories/calculator.story"),
    -> $line {
        given $line {
            ## Every Scenario, we should start with a clear calculator.
            when / Scenario\: / { $calculator.clear }
            ## A rule for entering the numbers.
            when /:s have entered (.*?) into the calculator/ {
                my $num = +$0;
                $calculator.push: $num
            }
            ## And one for pressing the operation buttons.
            when /:s press (.*)/ {
                $calculator."$0";
            }
            ## Finally, a way to get back the results.
            when /:s the result should be (\d+) on the screen/ {
                assert $calculator.total should-be +$0;
            }
        }
    }
);

