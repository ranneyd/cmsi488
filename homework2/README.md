#The Problems
1. Write regular expressions, and a package of functions (in the language of your choice) to recognize them, for each of the following.

  a. Canadian Postal Codes
  
  According to Wikipedia, Canadian postal codes "are in the format A1A 1A1, where A is a letter and 1 is a digit, with a space separating the third and fourth characters". Thus,
  ```
  /[A-Z]/d[A-Z] \d[A-Z]\d/
  ```
  
  b. Legal Visa® Card Numbers, not including checksums

  A Visa card begins with a 4 and is either 13, 16, or 19 characters long. Thus

  ```
    /4\d{12}\d{3}?\d{3}?/
  ```
  
  c. Legal MasterCard® Numbers, not including checksums

  A MasterCard used to begin with any number between 2221 and 2720. Today it begins with a number 51-55. In both cases it is 16 characters long. Thus

  ```
    /(5[1-5]\d\d)\d{12}/
  ```
  
  d. [Ada 95 numeric literals](http://cui.unige.ch/isi/bnf/Ada95/numeric_literal.html)

  An Ada 95 numeric literal is either a `decimal_literal` or a `based_literal`. A `decimal_literal` is a `numeral` followed by an optional `.numeral` followed by an optional `exponent`. A `numeral` is a `digit` followed by zero or more `digits`, optionally preceded by a `"_"`. A digit is 0-9. An exponent is either `E` followed by an optional `"+"` followed by a `numeral` or `E-numeral`. A `based_literal` is a `base` followed by `#based_numeral` followed by an optional `.based_numeral` followed by another `"#"` followed by an optional `exponent`. And a `base` is just a `numeral`. With all that in mind, behold:
  
  e. Strings of Basic Latin letters beginning with a letter, EXCEPT those strings that are exactly three letters ending with two Latin letter os, of any case.
  
  f. Binary numerals divisible by 16.
  
  g. Decimal numerals in the range 2 through 36, inclusive.
  
  h. Non-nesting ML-style comments: strings beginning with (* and ending with *).
  
  i. All strings of Basic Latin letters, except file, find, or for, without using lookarounds.
  
  j. All strings of Basic Latin letters, except file, find, or for, using lookarounds.
2. Clean up the README.md file for your compile project, and add a beautiful, perfect microsyntax and macrosyntax.
3. Add syntax checking to your compiler project. That is, implement a parser that can determine whether or not an input program is syntactically correct, but does not need to output an abstract syntax tree. (That will come in the next homework assignment.)