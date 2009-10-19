@markup @cubetext
Feature: Cubetext markup
  As a blog designer
  I want have my own markup language
  In order to have it my own

  Scenario Outline: Case <name>
    Given I have cubetext source <source>
      And I have cubetext config <config>
     Then cubetext result should be <result>

  Examples:
   | name                 | source                       | config     | result                                              |
   | paragraph            | [p[sample paragraph]]        |            | <p>sample paragraph</p>                             |
   | header               | [h1[header]][p[paragraph]]   |            | <h1>header</h1><p>paragraph</p>                     |
   | empty content anchor | [a {tag}[]]                  |            | <a id="tag"></a>                                    |
   | no content anchor    | [a {tag}]                    |            | <a id="tag"></a>                                    |
   | left bracket         | [p[left [[]]                 |            | <p>left [</p>                                       |
   | right bracket        | [p[right []]]                |            | <p>right ]</p>                                      |
   | br inside            | begin[br]end                 |            | begin<br>end                                        |
   | using some class     | [lj 2345]                    | lj_class   | [<a href="2345.html">2345@LJ</a>]                   |
   | using copy entity    | [p[[copyright] me]]          | copyright  | <p>&copy; me</p>                                    |
   | image tag, 1         | [image http://url.jpg]       |            | <img src="http://url.jpg" alt="">                   |
   | image, alt + size    | [img ./jpg "Ttl" (100x30)]   |            | <img src="./jpg" alt="Ttl" width="100" height="30"> |
   | image, alt + size, 2 | [img ./jpg "Ttl" (100x30)[]] |            | <img src="./jpg" alt="Ttl" width="100" height="30"> |
   | spacing              | [p[  boo [b[bold]] baz ]]    |            | <p>boo <b>bold</b> baz</p>                          |
   | nil attribute        | [hr]                         | nil_attr   | <hr noshade>                                        |
   | normalizing          | [p[\nnormalize\n\nme!\n]]    |            | <p>normalize me!</p>                                |
   | header element       | [header[ this is a header ]] | header_elt | <h2>this is a header</h2>                           |
   | element attributes   | [chapter[[para[foo]]         | attributes | <div class="chapter"><p>foo</p></div>               |
   | skip spaces          | [p[begin     [skip]\n, end]] |            | <p>begin, end</p>                                   |
   | skip spaces, short   | [p[begin     [/]\n, end]]    |            | <p>begin, end</p>                                   |
