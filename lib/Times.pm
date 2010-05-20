## A times method for Int, as suggested by Carl Masak

use MONKEY_TYPING;

augment class Int {
    method times (&code) {
        for ^self { code() }
    }
}

module Times:ver<3.0.0>:auth<http://huri.net/>;

# New infix operator: times
# Specify a number, and a block of code. The block of code will be
# executed the specified number of times.
# Example:  20 times { say "hello" }

multi sub infix:<times> (Int $num, &closure) is export(:DEFAULT) {
    for ^$num { closure() }
}

# Overloaded infix operator: x
# Specify a block of code, x, then an integer.
# It calls $integer times { block of code }.
# Example: { say "hello" } x 20

multi sub infix:<x> (&closure, Int $num) is export(:ALL) {
    $num times &closure;
}

## End of Library

