@nihon @romaji
Feature: Romaji parser

  Scenario Outline: Parsing successfully <source>
    Given romaji parser parses <source>
     Then romaji parser returns <result>
      And romaji parser has nothing unparsed
      And romaji parser failure is false

  Examples:
   | source  | result          | comment                         |
   | fu      | FU              | sample of fu                    |
   | sakana  | SA KA NA        | simple and plain case           |
   | shogun  | SHI yo GU N     | sho -> SHI yo                   |
   | shi     | SHI             | shi example                     |
   | daijobu | DA I JI yo BU   | jo -> JI yo                     |
   | dorobou | DO RO BO U      | long vowel                      |
   | dorobo: | DO RO BO U      | same case, semicolon used       |
   | foruku  | FU o RU KU      | katakana 'fork'                 |
   | firumu  | FU i RU MU      | same thing                      |
   | ookii   | O O KI I        | double vowels                   |
   | onna    | O N NA          | N's                             |
   | chotto  | CHI yo tsu TO   | cho -> CHI yo                   |
   | isshoni | I tsu SHI yo NI | double consonant, sho -> SHI yo |
   | etchi   | E tsu CHI       | echhi, first variant            |
   | ecchi   | E tsu CHI       | ecchi, second variant           |
   | kon'ya  | KO N YA         | N before ya (with apostrophee)  |
   | nyobou  | NI yo BO U      | nyo -> NI yo                    |
   | enpitsu | E N PI TSU      | N before consonant              |
   | patexi  | PA TE i         | little vowels                   |
   | axtsu   | A tsu           | little tsu                      |

  Scenario Outline: Parsing with failure <source>
    Given romaji parser parses <source>
     Then romaji parser returns <result>
      And romaji parser can not parse <rest>
      And romaji parser failure is true

  Examples:
   | source  | result          | rest | comment                                                 |
   | xxx     |                 | xxx  | this one helped to catch 'xx.." -> ( tsu .. ) transform |
   | kudas   | KU DA           | s    | partially entered romaji 'kudasai'                      |
