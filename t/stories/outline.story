Feature: Story Outlines
  In order to provide the Scenario Outline functionality from Cucumber
  As a computer programmer
  I want to be able to have a template and a table of data to work with

  Scenario Outline: Templates
    Given an initial value of <init>
    When I <action> <count> times
    Then the value should be <value>

    Examples:
        | init  | action     | count  | value  |
        | 10    | increment  | 10     | 20     |
        | 30    | decrement  | 20     | 10     |
        | 50    | decrement  | 25     | 25     |
        | 75    | decrement  | 25     | 50     |
        | 100   | increment  | 50     | 150    |


