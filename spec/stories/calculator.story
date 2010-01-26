Feature: Addition
  In order to avoid silly mistakes
  As a math idiot
  I want to be told the sum of two numbers

  Scenario: Add two numbers
    Given I have entered 50 into the calculator
    And I have entered 70 into the calculator
    When I press add
    Then the result should be 120 on the screen

  Scenario: Add five numbers, with implicit add
    Given I have entered 10 into the calculator
    And I have entered 20 into the calculator
    And I have entered 30 into the calculator
    And I have entered 40 into the calculator
    And I have entered 50 into the calculator
    Then the result should be 150 on the screen

Feature: Subtraction
  In order to do our bookkeeping
  As a total moron
  I want to be told the difference between two numbers

  Scenario: Subtract two numbers
    Given I have entered 50 into the calculator
    And I have entered 20 into the calculator
    When I press subtract
    Then the result should be 30 on the screen

Feature: Multiplication
  In order to show this is up with the times
  As a calculator of four functions
  I want to see it multiply

  Scenario: Multiply two numbers
    Given I have entered 20 into the calculator
    And I have entered 5 into the calculator
    When I press multiply
    Then the result should be 100 on the screen

Feature: Division
  In order to show how modular this is, it must be divided
  As a purveyor of bad puns
  I want to see the quotient

  Scenario: Divide two numbers
    Given I have entered 100 into the calculator
    And I have entered 4 into the calculator
    When I press divide
    Then the result should be 25 on the screen

  Scenario: Intentionally broken test
    Given I have entered 100 into the calculator
    And I have entered 25 into the calculator
    When I press divide
    Then the result should be 5 on the screen

Feature: Common scenarios with a background
  In order to show how backgrounds works
  As a developer of this lovely library
  I want to see a set of scenarios with a common background

  Background:
    Given I have entered 100 into the calculator

  Scenario: Add 50
    Given I have entered 50 into the calculator
    When I press add
    Then the result should be 150 on the screen

  Scenario: Subtract 25
    Given I have entered 25 into the calculator
    When I press subtract
    Then the result should be 75 on the screen

  Scenario: Multiply by 5
    Given I have entered 5 into the calculator
    When I press multiply
    Then the result should be 500 on the screen

  Scenario: Divide by 2
    Given I have entered 2 into the calculator
    When I press divide
    Then the result should be 50 on the screen

