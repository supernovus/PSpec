Feature: Tables
  In order to provide the multiline text from Cucumber in PSpec
  As a computer programmer
  I want to be able to use Python like """ quotes

  Scenario: Flipping a single line
    Given the value is: Ooga booga
    Then the result is: agoob agoO

  Scenario: Flipping a multi line
    Given the value is:
        """
        Hello World
        Goodbye Universe
        """
    Then the result is:
        """
        dlroW olleH
        esrevinU eybdooG
        """

