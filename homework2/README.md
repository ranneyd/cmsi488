#The Problems
1. Write regular expressions, and a package of functions (in the language of your choice) to recognize them, for each of the following.

  a. Canadian Postal Codes
  According to Wikipedia, Canadian postal codes "are in the format A1A 1A1, where A is a letter and 1 is a digit, with a space separating the third and fourth characters". Thus,
  ```
  /[A-Z]/d[A-Z] \d[A-Z]\d/
  ```
  a. Legal Visa® Card Numbers, not including checksums
  a. Legal MasterCard® Numbers, not including checksums
  a. Ada 95 numeric literals
  a. Strings of Basic Latin letters beginning with a letter, EXCEPT those strings that are exactly three letters ending with two Latin letter os, of any case.
  a. Binary numerals divisible by 16.
  a. Decimal numerals in the range 2 through 36, inclusive.
  a. Non-nesting ML-style comments: strings beginning with (* and ending with *).
  a. All strings of Basic Latin letters, except file, find, or for, without using lookarounds.
  a. All strings of Basic Latin letters, except file, find, or for, using lookarounds.
2. Clean up the README.md file for your compile project, and add a beautiful, perfect microsyntax and macrosyntax.
3. Add syntax checking to your compiler project. That is, implement a parser that can determine whether or not an input program is syntactically correct, but does not need to output an abstract syntax tree. (That will come in the next homework assignment.)