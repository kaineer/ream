@template @re
Feature: Template engine extending regexps
  As a template engine author
  I want to know what string will match template names and parameters
  In order to parse templates successfully

  Scenario Outline: Parsing template placeholder successfully
    Given I have a string <string>
     When I try to detect if string is a template placeholder
     Then parsing result should be true
      And result name should be <name>

  Examples:
    | string             | name             |
    | {foo}              | foo              |
    | {digits.123}       | digits.123       |
    | {foo:bar}          | foo:bar          |
    | {foo.bar}          | foo.bar          |
    | {prot:name.suffix} | prot:name.suffix |

  Scenario Outline: Parsing template placeholder failing
    Given I have a string <string>
     When I try to detect if string is a template placeholder
     Then parsing result should be false

  Examples:
    | string            | comment           |
    | foo               | no curly brackets |
    | {wrong-name}      | wrong name        |
    | {dots.:.together} | dots together     |


  Scenario Outline: Parsing template parameter placeholder successfully
    Given I have a string <string>
     When I try to detect if string is a template parameter placeholder
     Then parsing result should be true
      And result name should be <name>

  Examples:
    | string             | name             |
    | %foo%              | foo              |
    | %foo:bar%          | foo:bar          |
    | %foo.bar%          | foo.bar          |
    | %prot:name.suffix% | prot:name.suffix |
