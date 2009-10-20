@romaji
Feature: Romaji parser

  Scenario Outline: Parsing <source>
    Given romaji parser parses <source>
     Then romaji parser returns <result>
      And romaji parser can not parse <rest>
      And romaji parser failure is <failure>

  Examples:
   | source  | result          | rest | failure | comment                                                 |
   | sakana  | SA KA NA        |      | false   | simple and plain case                                   |
   | shogun  | SHI yo GU N     |      | false   | sho -> SHI yo                                           |
   | shi     | SHI             |      | false   | shi example                                             |
   | daijobu | DA I JI yo BU   |      | false   | jo -> JI yo                                             |
   | dorobou | DO RO BO U      |      | false   | long vowel                                              |
   | dorobo: | DO RO BO U      |      | false   | same case, semicolon used                               |
   | foruku  | FU o RU KU      |      | false   | katakana 'fork'                                         |
   | firumu  | FU i RU MU      |      | false   | same thing                                              |
   | ookii   | O O KI I        |      | false   | double vowels                                           |
   | onna    | O N NA          |      | false   | N's                                                     |
   | chotto  | CHI yo tsu TO   |      | false   | cho -> CHI yo                                           |
   | isshoni | I tsu SHI yo NI |      | false   | double consonant, sho -> SHI yo                         |
   | etchi   | E tsu CHI       |      | false   | echhi, first variant                                    |
   | ecchi   | E tsu CHI       |      | false   | ecchi, second variant                                   |
   | kon'ya  | KO N YA         |      | false   | N before ya (with apostrophee)                          |
   | nyobou  | NI yo BO U      |      | false   | nyo -> NI yo                                            |
   | enpitsu | E N PI TSU      |      | false   | N before consonant                                      |
   | patexi  | PA TE i         |      | false   | little vowels                                           |
   | axtsu   | A tsu           |      | false   | little tsu                                              |
   | xxx     |                 | xxx  | true    | this one helped to catch 'xx.." -> ( tsu .. ) transform |
   | kudas   | KU DA           | s    | true    | partially entered romaji 'kudasai'                      |
