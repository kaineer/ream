@romaji @kana
Feature: Kana text element

  Scenario Outline: Create hiragana with romaji <romaji>
    Given hiragana created with <romaji>
     Then kana string should be <string>
      And kana html code should be <html>
      And kana inspect should be <inspect>

  Examples:
    | romaji | string | html         | inspect            |
    | sakana | さかな | さかな       | Hiragana(SA,KA,NA) |
    | kudas  | くだ   | くだ<u>s</u> | Hiragana(KU,DA/s)  |

  Scenario: Create katakana with romaji
    Given katakana created with foruku
     Then kana string should be フォルク
      And kana inspect should be Katakana(FU,o,RU,KU)

  Scenario Outline: Test whether input is romaji
    Given kana checks <source>
     Then kana success should be <success>
      And kana rest should be <rest>

  Examples:
    | source | success | rest |
    | sakana | true    |      |
    | kudas  | true    | s    |
    | ...    | false   | ...  |
