@nihon @dots
Feature: Nihon punctuation

Scenario: Inspect and display dots object
  Given nihon syntax string "[.,(~\" "
   Then nihon syntax string inspect should be Dots([.,(~" )
    And nihon syntax string should display as "『。、「〜〞 "

Scenario Outline: Test whether input text is dots
  Given nihon syntax tested with "<source>"
   Then nihon syntax success is <success>
    And ninon syntax unparsed is <unparsed>

Examples:
  | source     | success | unparsed |
  | (~.~)      | true    |          |
  | \"toiimasu | true    | toiimasu |
  | sakana.)   | false   | sakana.) |
