@shell @interactive
Feature: Abstract shell
  As an outside library user
  I want have interaction media
  In order to send commands to library objects

  Scenario: Sending command to shell
    Given I have an abstract shell
      And I feed foo command to shell
     Then a shell should try to execute foo command

  Scenario: Leaving a shell
    Given I have an abstract shell
      And shells command wants shell to leave
     Then shell leaves loop
