@shell @interactive
Feature: Abstract shell
  As an outside library user
  I want have interaction media
  In order to send commands to library objects

  Scenario: Starting abstract shell
    Given I have an abstract shell with mock executor
     Then abstract shell does not leave loop
      And abstract shell does not get exception

  Scenario: Sending command to shell
    Given I have an abstract shell with mock executor
      And mock shell executor expects foo command
     Then abstract shell should take foo command successfully
      And abstract shell does not get exception

  Scenario: Parsing command line
    Given I have an abstract shell with mock executor
      And mock shell executor expects foo command with args:
        | bar   |
        | baz   |
        | queue |
     Then abstract shell should take foo bar baz queue command successfully
      And abstract shell does not get exception

  Scenario: Leaving a shell
    Given I have an abstract shell with mock executor
      And shells command wants shell to leave
     Then abstract shell leaves loop
      And abstract shell does not get exception

  Scenario: Command throws exception
    Given I have an abstract shell with mock executor
      And mock executor throws exception on each command
      And I feed foo command to shell
     Then abstract shell does not leave loop
      And abstract shell gets exception

  Scenario: Shell lifecycle
    Given I have an abstract shell with mock executor
      And mock shell executor expects foo command
      And mock shell executor expects exit command which wants shell to leave
      And abstract shell reads:
        | foo  |
        | exit |
     When I run shell
     Then abstract shell is not running anymore
