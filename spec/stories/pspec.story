Feature: Story Handling
  In order to provide Cucumber like functionality to PSpec
  As a computer programmer
  I want to be able to read plain text stories and parse them as tests

  Scenario: Increment 20 times
    Given an initial value of 0
    When I increment 20 times
    Then the value should be 20

  Scenario: Decrement from 50, 20 times
    Given an initial value of 50
    When I decrement 20 times
    Then the value should be 30

  Scenario: Mixed increment and decrement
    Given an initial value of 100
    When I decrement 60 times
    And I increment 30 times
    Then the value should be 70

