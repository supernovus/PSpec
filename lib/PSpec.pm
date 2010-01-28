# -----------------------------------------------------------------------------
#  PSpec: RSpec + Cucumber for Perl 6
#   See: http://huri.net/tech/pspec
#   or: http://github.org/supernovus/PSpec
# -----------------------------------------------------------------------------

## A times method for Int, as suggested by Carl Masak

class Int is also {
    method times (&code) {
        for ^self { code() }
    }
}

## A tag replacement parser for Str. Pass it a hash, and optionally
#  a prefix and suffix and it will replace any instances of the keys
#  with the mapped values. Useful for templates!
#  NOTE: This method MODIFIES the String object that calls it, use carefully!

class Str is also {
    method replace-tags (%tags, $prefix='<', $suffix='>') {
        for %tags.kv -> $key, $value {
            self.=subst("$prefix$key$suffix", $value);
        }
        return self;
    }
}

module PSpec:ver<2.4.0>:auth<http://huri.net/>;

our $tests_run    = 0;
our $failed_tests = 0; 
our $die_on_fail  = 0; 
our $test_plan    = 0; 

sub check-verbose is export(:DEFAULT) {
    my $verbose = 0;
    if @*ARGS[0] ~~ / ^ \- (v+) / {
        $verbose = ~$0.chars;
    }
    return $verbose;
}

# New infix operator: should-be
# Performs a test, and if it fails, lists the value that was returned, 
# as well as what was expected. Example:  
#
#   $one should-be 1;
#

multi sub infix:<should-be> (Any $a, Any $b) is export(:DEFAULT) {
    should-be( $a ~~ $b, $a, $b );
}

multi sub infix:<should-be> (Num $a, Num $b) is export(:DEFAULT) {
    should-be( $a == $b, $a, $b );
}

multi sub infix:<should-be> (Str $a, Str $b) is export(:DEFAULT) {
    should-be( $a eq $b, $a, $b );
}

# Infix operator: should-be (Any, Pair)
# A special version of the should-be operator which allows you to
# specify a tag as the 'expected' as well as a more complex comparision
# closure. Example:
#
#   $five should-be ( '> 4' => { $^a > 4 } );
#

multi sub infix:<should-be> (Any $a, Pair $b) is export(:DEFAULT) {
    my $code = $b.value;
    my $result = $code($a);
    should-be($result, $a, $b.key);
}

# A special version of the should-be operator made specifically for
# comparison operators such as '>', '<', 'gt', etc. Uses a simpler
# syntax than the above operator. Example:
#
#   $five should-be ( '>', '4' );
#

multi sub infix:<should-be> (Any $a, @array) is export(:DEFAULT) {
    my $expected = @array.join(' ');
    my $result   = eval("$a $expected");
    should-be($result, $a, $expected);
}

# Public function: should-be (Boolean, $got, $expected)
# The function which powers all of the above infix operators.
# Normally, you'd want to use the infix operators for better readability
# but if you want, you can run the function version directly. Example:
#
#   should-be $five > 4, $five, '> 4';
#
# This is not very pretty, but does allow for the most flexibility.

sub should-be (Bool $result, Any $got, Any $expected) is export(:DEFAULT) {
    if !$result {
        diag '-' x 76;
        diag "expected: $expected";
        diag "got:      $got";
    }
    return $result;
}

# New infix operator: times
# Specify a number, and a block of code. The block of code will be
# executed the specified number of times.
# Example:  20 times { say "hello" }

multi sub infix:<times> (Int $num, &closure) is export(:DEFAULT) {
    for ^$num { closure() }
}

# Public function: plan ($number)
# Adds the specified number to the planned number of tests.
# By default the test suites have no plan, so this is optional.

sub plan ($count=1) is export(:DEFAULT) { $test_plan += $count; }

# API function: diag ($message)
# Prints a message prefixed with '# ' so-as to make it suitable
# for TAP formatted output.

sub diag ($message) is export(:DEFAULT) { say "# " ~$message; }

# Public function: die_on_fail (Bool)
# If called as die_on_fail; it will set the test set to bail out if
# any individual test fails. You can disable this feature again
# by calling die_on_fail(False);

sub die_on_fail ($fail=1) is export(:DEFAULT) {
    $die_on_fail = $fail;
}

# API function: ok ($boolean, $description)
# Provides the Test::Simple like 'ok()' functionality.
# Outputs in TAP format (does not support nested TAP yet.)

sub ok is export(:ALL) ($cond, $desc) {
    $tests_run++;
    unless $cond {
        print "not ";
        $failed_tests++;
    }
    say "ok ", $tests_run, " - ", $desc;
    if !$cond && $die_on_fail {
        die "Test failed. Stopping test";
    }
    return $cond;
}

# Public function: describe ($class_name, $method_name, @tests)
# Implements a describe statement inspired by the one from RSpec.
# The @tests array must contain Pair objects, where the key is the
# name of the test, and the value is a closure containing the actual
# test to perform. As an example:
#
#   describe "PSpec", "times", [
#     'operator works' => {
#       my $value = 0;
#       20 times { $value++ }
#       $value should-be 20;
#     },
#   ];
#

sub describe ($class, $name, @tests) is export(:DEFAULT) {
    for @tests -> $pair {
        my $sub = $pair.value;
        my $value = $sub();
        ok $value, "$class.$name: {$pair.key}";
    }
}

END {
    if !$test_plan {
        $test_plan = $tests_run;
    }
    say "1..$test_plan"; ## Yes, we're backwards here.
    if $test_plan != $tests_run {
        diag "You planned $test_plan tests, but only ran $tests_run";
    }
    if $failed_tests {
        diag "Well, $failed_tests tests out of $tests_run failed!";
    }
}

### PickleSandwich (aka Cucumber) functionality below here.
# 
# I haven't written any documentation for this bit of code yet.
# See the 'calc.p6' and 'calculator.story' for an example of
# how this works. It's a simple emulation of the 'story' from
# Cucumber. It doesn't support backgrounds, or scenario outlines
# yet though, so don't even bother trying.

our $feature_name    = '';
our $scenario_name   = '';

sub lines-handler (@lines, @handlers) {
    for @lines -> $line {
        line-handler $line, @handlers;
    }
}

sub line-handler ($line, @handlers) {
    for @handlers -> $handle {
        $handle($line);
    }
}

## The public story handler function.
#  Calls the private method.

sub handle-story (
    @story, 
    :$verbose=check-verbose(), 
    Code *@handlers
) is export(:DEFAULT) {
    story-handler(@story, :verbose($verbose), @handlers);
}

## The real story handler.
sub story-handler (@story, :$verbose=0, Code *@handlers) {

    ## For backgrounds
    my $in_background   = 0;
    my @background;

    ## For tables
    my $previous_line   = '';
    my $table_statement = ''; ## Empty when unused.
    my @table_fields;
    my @table_data;

    ## For outlines
    my $outline_name    = '';
    my $in_outline      = 0;
    my @outline_text;
    my $in_examples     = 0;
    my @example_fields;
    
    for @story -> $line {
        if $verbose { diag $line; }
        my $follow_dispatch = 1;
        
        given $line {
            if $in_examples {
                when not /:s ^ \| / {
                    $in_examples = 0;
                }
            }
            when /:s Feature\: (.*)/ {
                @background.splice; ## Kill existing backgrounds.
                $feature_name    = $0;
                $follow_dispatch = 1;
            }
            when /:s Scenario Outline\: (.*)/ {
                @outline_text.splice;  ## Make sure this is empty.
                $outline_name    = $0;
                $in_outline      = 1;
            }
            if ($in_outline) {
                when /:s Examples\:/ {
                    @example_fields.splice; ## Make sure this is empty.
                    $in_outline  = 0;
                    $in_examples = 1;
                }
            }
            when /:s Scenario\: (.*)/ {
                $scenario_name   = $0;
                $in_background   = 0;
                if @background {
                    $follow_dispatch = 0;                 ## No dispatch.
                    line-handler $line, @handlers;        ## Run this now.
                    lines-handler @background, @handlers; ## Then run the rest.
                }
            }
            when /:s Background\:/ {
                $in_background   = 1;
            }
        }

        if $in_outline {
            @outline_text.push: $line;
            $follow_dispatch = 0;
        }

        if $in_examples && $line ~~ /:s ^ \| / {
            ## Get rid of the first line, it's the Outline statement.
            $follow_dispatch = 0;
            if @example_fields {
                my %example;
                my @temp_fields = $line.split(/:s \| /);
                for @example_fields Z @temp_fields -> $field, $value {
                    if $field {
                        %example{$field} = $value;
                    }
                }
                $scenario_name = $outline_name ~ ' # ' ~ $in_examples++;
                line-handler "Subtest: $scenario_name", @handlers;
                my @outline = @outline_text;
                @outline>>.replace-tags(%example);
                my $inner_verbose = 0;
                if ($verbose > 1) { $inner_verbose = $verbose; }
                story-handler @outline, :verbose($inner_verbose), @handlers;
            }
            else {
                @outline_text.shift;
                @example_fields = $line.split(/:s \| /);
            }
        }

        if $in_background {
            @background.push: $line;
            $follow_dispatch = 0;
        }

        if $follow_dispatch {
            line-handler $line, @handlers;
        }

        $previous_line = $line;

    }
}

sub assert ($condition) is export(:DEFAULT) {
    return ok $condition, "$feature_name: $scenario_name";
}

## End of library

