#!/usr/local/bin/perl6

use v6;

BEGIN { @*INC.push('lib'); }

use Test;
use PSpec;

plan 5;

describe "PSpec", "operators",
[
  'eq' => 
  {
    20 should eq(20);
  },
  'gt' => 
  {
    20 should gt(15);
  },
  'lt' =>
  {
    20 should lt(25);
  }
];

describe "PSpec", "helpers", 
[
  'times' => 
  {
    my $value = 0;
    20 times { $value++ }
    $value, 20;
  },
  'xxx' =>
  {
    my $value = 50;
    { $value--; } xxx 25;
    $value, 25;
  }
];

## End of tests

