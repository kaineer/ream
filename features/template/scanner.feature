@template @scanner
Feature: Template scanner
  In order to get template content
  I will need to scan some source for it

Scenario: Scanning a source
  Given I have a source:
    | --- first.template  |
    | foo                 |
    | --- second.template |
    | bar                 |
    | ---                 |
  When scanner scans a source
  Then scanner content with name first.template should be foo
   And scanner content with name second.template should be bar
