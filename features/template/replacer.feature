@template @replacer
Feature: Expand template content with / w/o parameters

  Scenario: Simple text w/o expanding
    Given I have template replacer with items:
      | name          | value         |
      | template.text | Test template |
     Then replacing template template.text I will get value Test template

  Scenario: Including another template
    Given I have template replacer with items:
      | name             | value                     |
      | template.include | Whole and {template.part} |
      | template.part    | a part                    |
     Then replacing template template.include I will get value Whole and a part

  Scenario: Expanding with params
    Given I have template replacer with items:
      | name            | value               |
      | template.params | %white% and %black% |
     Then replacing template template.params I will get value %white% and %black%
      And expanding template template.params I will get value Horse and dog with params:
        | name  | value |
        | white | Horse |
        | black | dog   |

  Scenario: Nested include
    Given I have template replacer with items:
      | name                 | value                         |
      | template.outer       | Outer: {template.inner}.      |
      | template.inner       | Inner: {template.inner.outer} |
      | template.inner.outer | template                      |
   Then replacing template template.outer I will get value Outer: Inner: template.

  Scenario: Unknown template placeholder
    Given I have template replacer with items:
      | name                           | value                           |
      | template.searching.for.nowhere | Code sample #{nowhere} that is. |
     Then replacing template template.searching.for.nowhere I will get value Code sample #{nowhere} that is.
