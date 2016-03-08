#The Problems
1. Here's a grammar:
```
S ::= A M
M ::= S?
A ::= 'a' E| 'b' A A
E ::= ('a' B | 'b' A)?
B ::= 'b' E | 'a' B B
```
  a. Describe in English the language of this grammar.
  b. Draw a parse tree for the string "abaa".
  c. Prove or disprove: "This grammar is LL(1)."
  d. Prove or disprove: "This grammar is ambiguous."