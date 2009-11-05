@template @hashbuilder
Feature: Hash builder
  As a template engine author
  I want a way to keep template parts
  In order to use'em when I need'em

  Scenario: Empty hash builder
    Given I have a new hash builder
     Then key foo from hash builder does not exist

  Scenario: One-line value
    Given I have a new hash builder
      And I added to hash builder a key foo
      And I added to hash builder a line mew
     Then key foo from hash builder should be mew

  Scenario: Several lines value
    Given I have a new hash builder
      And I added to hash builder a key foo
      And I added to hash builder lines mew, bark, moan
     Then key foo from hash builder should be mew\nbark\nmoan

  Scenario: Not adding after close
    Given I have a new hash builder
      And I added to hash builder a key foo
      And I added to hash builder a line mew
      And I closed hash builder's key
      And I added to hash builder a line bark
     Then key foo from hash builder should be mew

