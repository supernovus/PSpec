+------------------------------------------------------------------------------+
+ PSpec: An RSpec + Cucumber inspired BDD Test Framework for Perl 6            +
+------------------------------------------------------------------------------+

~ Introduction ~

PSpec was started as a fun experiment to see if I could make a library
in Perl 6 that would allow me to create a test that looked similar to
the one on the front page of the RSpec website.

After making one, I turned my attention to the example on the Cucumber
website, and added a simple story handler to the library.

In addition to the basic testing stuff, the PSpec library also includes some
utility functionality such as a 'times' operator and .times Int method.

~ Usage ~

From the main directory, you can run the individual specification tests
by doing:

 $ perl6 ./spec/name-of-spec.t

If you want to run all of the specification tests, you can also use the
'prove' utility as provided with Perl 5.

 $ prove -v --perl perl6 -r ./spec/

Just note that the specs included with the library have intentionally
failing tests to show how the testing framework displays them.

The only test that should pass 100% is the pspec.t which is the test
for the PSpec library itself, and has very basic tests for both the RSpec
like definitions, and the story handling mode.

~ Documentation ~

I'm not that great at writing documentation, see the code, it's pretty
self explanitory. I will add Pod (Perl 6 POD) documentation to the PSpec
library soon, I promise!

For now, please read the original article that I wrote introducing the
PSpec library:

  http://huri.net/tech/perl6-rspec

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

