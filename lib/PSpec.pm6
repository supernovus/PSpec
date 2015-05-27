use v6;
use Test;

unit module PSpec:ver<4.0.0>:auth<http://huri.net/>;

## Perform a block of code x number of times.
multi sub infix:<times> (Int $num, &closure) is export 
{
    for ^$num { closure() }
}

## Same thing, just the other way around.
sub infix:<xxx> (&closure, Int $num) is export
{
  $num times &closure;
}

## Returns the output of a test to describe.
sub infix:<should> ($got, $want) is export
{
  if ($want ~~ Callable)
  {
    return $want($got);
  }
  else
  {
    return $got, $want;
  }
}

## eq, the most basic test possible. The same as passing the raw value.
sub eq ($val) is export
{
  return $val;
}

## gt, is a value greater than?
multi sub gt (Numeric $want) is export
{
  -> $got 
  {
    $got > $want;
  }
}

## lt, is a value lesser than?
multi sub lt (Numeric $want) is export
{
  -> $got
  {
    $got < $want;
  }
}

# Public function: describe ($class_name, $method_name, @tests)
# Implements a describe statement inspired by the one from RSpec.
# The @tests array must contain Pair objects, where the key is the
# name of the test, and the value is a closure containing the actual
# test to perform. The output must be sent by the 'should' operator.
#
#   describe "PSpec", "times", [
#     'operator works' => {
#       my $value = 0;
#       20 times { $value++ }
#       return $value, 20;
#     },
#   ];
#

sub describe ($class, $name, @tests) is export {
  for @tests -> $pair {
    my $sub = $pair.value;
    my @return = $sub();
    my $test = "$class.$name: {$pair.key}";
    if @return.elems == 1
    {
      ok @return[0], $test;
    }
    elsif @return.elems == 2
    {
      is @return[0], @return[1], $test;
    }
    else
    {
      die "invalid test paramters";
    }
  }
}

## End of library

