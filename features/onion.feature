@onion
Feature: Onion hash
  I want a hash-like object
  Which can contain another hash-like objects
  And behave like one hash

  Scenario: Overriding a hash
    Given I have an onion
      And I place a hash into onion:
        | name | value |
        | foo  | one   |
        | bar  | two   |
      And I place a hash into onion:
        | name | value |
        | foo  | three |
        | bar  | four  |
     Then onion should contain values:
        | name | value |
        | foo  | three |
        | bar  | four  |


  Scenario: Overriding different object
    Given I have an onion
      And I place a hash into onion:
        | name | value |
        | foo  | one   |
        | bar  | two   |
      And I place a proc into onion which takes foo and returns zee
     Then onion should contain values:
        | name | value |
        | foo  | zee   |
        | bar  | two   |
