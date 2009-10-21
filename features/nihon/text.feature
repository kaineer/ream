@nihon @text
Feature: Nihon text notation

Scenario Outline: Parse nihon text notation
  Given nihon text source <source>
   Then nihon text inspect is <result>

Examples:
  | source                | result                                                          |
  | sakana                | Hiragana(SA,KA,NA)                                              |
  | /piano                | Katakana(PI,A,NO)                                               |
  | {EEEE,FFFF}           | Kanji(EEEE,FFFF)                                                |
  | /purezento{EEEE}owaru | Katakana(PU,RE,ZE,N,TO);Kanji(EEEE);Hiragana(O,WA,RU)      |
  | {9B5A:sakana}         | Kanji(9B5A:Hiragana(SA,KA,NA))                                  |
  | /fu-/ku               | Katakana(FU);Dots(-);Katakana(KU)                               |
  | -in                   | Dots(-);Hiragana(I,N)                                           |
  | (arigatou)toiimashita | Dots(();Hiragana(A,RI,GA,TO,U);Dots());Hiragana(TO,I,I,MA,SHI,TA) |
