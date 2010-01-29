Feature: Tables
  In order to provide the Tables from Cucumber in PSpec
  As a computer programmer
  I want to be able to supply various forms of tables

  Scenario: A list of hashes
    Given an initial value of 0
    When we perform the operations on the following table:
        | number | operation |
        | 10     | add       |
        | 40     | add       |
        | 20     | subtract  |
        | 2      | multiply  |
        | 4      | divide    |
    Then the result should be 15

  Scenario: Two flat lists
    Given the following numbers:
        | 10 |
        | 40 |
        | 20 |
        | 4  |
    When we perform the following operations:
        | add      |
        | subtract |
        | multiply |
    Then the result should be 160

  Scenario: Subtract columns and add rows
    Given the following table:
        | 100 | 20 | 5 |
        | 30  | 10 | 5 |
        | 10  | 5  | 0 |
    Then the result should be 95


