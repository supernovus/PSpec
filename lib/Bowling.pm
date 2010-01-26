#!/usr/local/bin/perl6

class Bowling {
    has $.score is rw = 0;
    
    method hit ($pins) {
         $.score += $pins;
    }
}

