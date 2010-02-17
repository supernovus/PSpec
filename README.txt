+------------------------------------------------------------------------------+
+ PSpec: An RSpec + Cucumber inspired BDD Test Framework for Perl 6            +
+------------------------------------------------------------------------------+

~ Introduction ~

PSpec was started as a fun experiment to see if I could make a library
in Perl 6 that would allow me to create a test that looked similar to
the one on the front page of the RSpec website.

After making one, I turned my attention to the example on the Cucumber
website, and added a simple story handler to the library.

The story handler has been separated out as it's own library (which
still depends on PSpec) called Pickle.

Pickle currently handles simple stories, backgrounds, scenario outlines,
tables, and multiline text.

There is also support for chaining rules. If you want to call another rule
from a step definition, use: declare "test for $rule";

In addition to the basic testing stuff, the PSpec project also includes some
utility functionality, mostly separated out into other libraries, such
as the Times library which provides a 'times' operator and .times Int method.

Pickle also has a tag parser method for Str objects (called 'replace-tags'). 
Pass it a hash, and it will replace any instance of <key> with the 
mapped value. Useful for templates (and Scenario Outlines.)

There is an object called Table which is used by Pickle to provide
Cucumber-like Tables. It allows multiple "views" of the data from the
table.

Oh, and for no particular reason whatsoever, there is a reverse polish
calculator class called Calculator also included, it's used in a few of
the examples and tests.

~ Usage ~

From the main directory, you can run the individual specification tests
by doing:

 $ perl6 ./examples/name-of-test.t

If you want to run all of the specification tests, you can also use the
'prove' utility as provided with Perl 5.

 $ prove -v --perl perl6 -r ./t/

Oh, and now the story based tests are quiet by default. If you want
them to display their story (as TAP comments) then call the test
with the -v flag. For example:

  $ perl6 ./t/pspec-story.t -v

The test scripts in the 'examples' folder have intentional "failing" tests
to show how the output from such tests would appear.

The tests in the 't' folder on the other hand are used to test PSpec itself
and should pass. If they don't, there is a problem.

~ Caveats ~

This currently does not work with the 'ng' branch of Rakudo, which
as of February 12th, 2010, is the new 'master' branch.

Until the new branch is back up to the functionality of the old one,
the recommended release of Rakudo to use with PSpec is #25, the
release from January 2010.

I will be testing the new Rakudo master branch as it's development
continues and will be helping to get it to run PSpec again.

I will remove this section when that glorious day happens.

~ Documentation ~

This README file is it for now.

If you want to enable extra verbosity, just keep adding v characters to
the flag. So -vv is double verbosity, -vvv is triple, etc.

Currently enabling double verbosity will allow you to see the statements
being run by Scenario Outlines for each Example.

I'm not that great at writing documentation, see the code, it's pretty
self explanitory. I will add Pod (Perl 6 POD) documentation to the PSpec
library soon, I promise!

For now, please read the original article that I wrote introducing the
PSpec library:

  http://huri.net/tech/pspec

~ Credits ~

Well, I must send cudos to the original authors of RSpec and Cucumber,
without them, this wouldn't exist.

Also, a big cheers to Carl Masak, who is always friendly and helpful,
and who offered a solution to the .times method for Int objects. 
And a call-out to Larry Wall whose help on the #perl6 channel has been 
greatly appreciated! I guess I should also thank him for creating Perl :-)

~ License ~

This work is licensed under the Artistic License 2.0, the same license that
Perl 6 itself uses. Please see the LICENSE.txt for the full text of the
license.

~ Summary ~

Well, that's all folks. Have fun!

