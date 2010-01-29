Feature: Story Rule Chaining
  In order to provide Cucumber's ability to chain steps
  As a computer programmer
  I want to be able to have one rule call another rule.

  Scenario: Increment 20 by 10
    Given we increment 20 by 10
    Then the value should be 30

  Scenario: Decrement 50 by 20
    Given we decrement 50 by 20
    Then the value should be 30

  Scenario: Increment and decrement together
    Given we take 100 75 steps higher and 125 steps lower
    Then the value should be 50

