#!/usr/local/bin/perl6

use v6;

BEGIN { @*INC.unshift('lib'); }

use Pickle;
use Calculator;

our $calculator = Calculator.new;

sub MAIN ( $verbose=0 ) {

handle-story( 
    lines("examples/stories/calculator.story"),
    :verbose($verbose),
    -> $line {
        given $line {

            ## Every Scenario, we should start with a clear calculator.
            when / Scenario\: / {
                #diag "====> Clearing Calculator";
                $calculator.clear;
            }

            ## A rule for entering the numbers.
            when /:s have entered (.*?) into the calculator/ {
                my $num = +$0;
                $calculator.push: $num;
                #diag "====> Entered $num in calculator";
            }

            ## And one for pressing the operation buttons.
            when /:s press (.*)/ {
                #diag "====> Pressing $0 on calculator";
                $calculator."$0"();
            }

            ## Finally, a way to get back the results.
            when /:s the result should be (\d+) on the screen/ {
                assert $calculator.total should-be +$0;
            }

        }
    }
);

}

