use v6;

#use PSpec :ALL;
use PSpec;

use MONKEY_TYPING;

## A tag replacement parser for Str. Pass it a hash, and optionally
#  a prefix and suffix and it will replace any instances of the keys
#  with the mapped values. Useful for templates!
#  NOTE: This method MODIFIES the String object that calls it, use carefully!

augment class Str {
    method replace-tags (%tags, $prefix='<', $suffix='>') {
        for %tags.kv -> $key, $value {
            self.=subst("$prefix$key$suffix", $value);
        }
        return self;
    }
}

use Table;

module Pickle:ver<3.0.0>:auth<http://huri.net/>;

# This module needs to be documented properly.
# It's documentation currently sucks.
# I also plan on writing some Pod for this at some point.

sub check-verbose is export(:DEFAULT) {
    my $verbose = 0;
    if @*ARGS[0] ~~ / ^ \- (v+) / {
        $verbose = ~$0.chars;
    }
    return $verbose;
}

our $feature_name    = '';
our $scenario_name   = '';
our @call_queue; ## Now we add statements in handlers.

sub declare (Str $line) is export(:DEFAULT) {
    @call_queue.push: $line;
}

sub split-def ($line) {
    my @def = $line.split(/:s \| /);
    @def.pop;    ## Kill the last empty field.
    @def.shift;  ## Kill the first empty field.
    return @def;
}

sub build-fields ($line, @fields) {
    my @temp_fields = split-def $line; 
    return @temp_fields.hashMap(@fields);
}

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

## A quick way to check verbosity levels.

sub chain-handler (@story, @handlers, $verbose, $min) {
    my $inner_verbose = 0;
    if ($verbose > $min) { $inner_verbose = $verbose; }
    story-handler(@story, :verbose($inner_verbose), @handlers);
}

## The real story handler.
sub story-handler (@story, @handlers, :$verbose=0 ) {

    ## For backgrounds
    my $in_background   = 0;
    my @background;

    ## For tables
    my $previous_line   = '';
    my $table = Table.new;

    ## For multiline text
    my $multiline = '';
    my @multiline;
    my $line_length = 0;

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
            when Table { } # We skip tables. Handle elsewhere.
            when Pair { }  # We skip pairs.  Handle elsewhere.
            if $in_examples {
                when not /:s ^ \| / {
                    $in_examples = 0;
                }
            }
            elsif !$in_outline && !$in_background {
                if $table.key {
                    when not /:s ^ \| / {
                        line-handler $table, @handlers;
                        $table.clear;
                        continue;
                    }
                }
                if $multiline {
                    when /:s ^ \"\"\" $/ {
                        ## We've reached the end of the text.
                        my $linePair = $multiline => @multiline;
                        line-handler $linePair, @handlers;
                        @multiline.splice;
                        $multiline = '';
                        $line_length = 0;
                    }
                    when not /:s ^ \"\"\" $/ {
                        $line.=substr($line_length);
                        @multiline.push: $line;
                        $follow_dispatch = 0;
                    }
                }
                else {
                    when /^(<.ws>)\"\"\"<.ws>$/ {
                        $line_length = ~$0.chars;
                        $follow_dispatch = 0;
                        $multiline = $previous_line;
                    }
                }
                when /:s ^ \| / {
                    $follow_dispatch = 0;
                    $table.key = $previous_line if !$table.key;
                    my @fields = split-def $line;
                    $table.push: \@fields;
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
                    ## Then run the rest:
                    chain-handler @background, @handlers, $verbose, 2; 
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
            $follow_dispatch = 0;
            if @example_fields {
                my %example = build-fields($line, @example_fields);
                $scenario_name = $outline_name ~ ' # ' ~ $in_examples++;
                line-handler "Subtest: $scenario_name", @handlers;
                my @outline = @outline_text;
                @outline>>.replace-tags(%example);
                chain-handler @outline, @handlers, $verbose, 1;
            }
            else {
                ## Get rid of the first line, it's the Outline statement.
                @outline_text.shift;
                @example_fields = split-def $line;
            }
        }

        if $in_background {
            if $line !~~ /:s Background\: / {
                @background.push: $line;
            }
            $follow_dispatch = 0;
        }

        if $follow_dispatch {
            line-handler $line, @handlers;
        }

        $previous_line = $line;

        ## Next up, run anything in the call queue.
        if @call_queue {
            my @chain_story = @call_queue;
            @call_queue.splice;
            chain-handler @chain_story, @handlers, $verbose, 1;
        }

    }
}

sub assert ($condition) is export(:DEFAULT) {
    return ok $condition, "$feature_name: $scenario_name";
}

## Use for handlers that need to support tables and multiline text.

sub matching ($line) is export(:DEFAULT) {
    my $matcher = $line;
    if $line ~~ Table | Pair {
        $matcher = $line.key;
    }
    return $matcher;
}

## End of Library

