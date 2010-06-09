use Times;
use PSpec;

module Story;

my $value;

our sub default-handler () {
    return -> $line {
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
}

