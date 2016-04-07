#The Problems
1. Here's a grammar:
	```
	  S ::= A M
	  M ::= S?
	  A ::= 'a' E | 'b' A A
	  E ::= ('a' B | 'b' A)?
	  B ::= 'b' E | 'a' B B
	```

	a. Describe in English, the language of this grammar.

	This language matches strings that have more 'a's than 'b's. A matches strings that have one more 'a' than 'b's, 'e' matches strings that have an equal number of 'a's and 'b's, and B matches strings that have one more 'b' than 'a's. S matches one more more A's.
  
	b. Draw a parse tree for the string "abaa"

	```
						  -----
						  | S |
						  -----
							|
				   ------------------------
				-----                    -----
				| A |                    | M |
				-----                    -----
				  |                        |
	  ----------------                   -----
	-------         -----                | S |
	| 'a' |         | E |                -----
	-------         -----                  |
					  |                  -----------
			  ------------            -----     -----
			-------     -----         | A |     | M |
			| 'b' |     | A |         -----     -----
			-------     -----           |
						  |         ----------
					  ----------  ------- -----
					------- ----- | 'a' | | E |
					| 'a' | | E | ------- -----
					------- -----

	```

	c. Prove or disprove: "This grammar is LL(1)"

	This grammar is not LL(1). Look at string 'aab'. It matches the first 'a' then arives at category E. The next token is an 'a'. An 'a' is a string that has one more 'a' than it has 'b's, so the 'a' we just matched could be the whole A, and this new 'a' could be another whole A or the beginning of another one. Assuming the second case, we can match nothing at this E and backtrack to the M case. However, if we did that, the string would not match because A doesn't match 'ab' ('ab' does not have one more 'a' than it has 'b's). This string 'aab' does match, however, so we need to know back in the fork at the road that we need to match the 'a' in the E case. But the only way we could have known that was by looking ahead at the 'b'. Thus, this cannot be LL(1).

	d. Prove or disprove: "This grammar is ambiguous"

	This grammar is ambigious because you can potentially write different parse trees for the same string. Consider 'aabbaa'. S can match 'a', 'aabba', and 'abbaa'. We know this matches one or more A's. This means that the first A can be 'a' and the second can be 'abbaa' or the first can be 'aabba' and the second can be 'a'.

2. Here's a grammar that's trying to capture the usual expressions, terms, and factors, while considering assignment to be an expression.

	```
	Exp			::= id ':=' Exp | Term TermTail
	TermTail	::= ('+' Term TermTail)?
	Term		::= Factor FactorTail
	FactorTail  ::= ('*' Factor FactorTail)?
	Factor		::= '(' Exp ')' | id
	```
	
	a. Prove that this grammar is not LL(1)

	For a grammar to be LL(1) it must be parsable by a parser that reads the input string left to right only looking at one character ahead. If we begin with the token 'id' we could either evaluate `id ':='` or we could parse down the path `Term->Factor->id`. However, if the next token is ':=', we have to take the first path. Since this requires looking two ahead, this isn't LL(1).
	
	b. Rewrite it so that it is LL(1)

	```
	Exp         ::= Parens | Ids
    Parens      ::= '(' Exp ')'
    Ids         ::= id (Assign | TermTail)?
    Assign      ::= ':=' Exp
    TermTail    ::= MultTail? '+' Factor MultTail? TermTail?
    MultTail    ::= '*' Factor MultTail?
    Factor      ::= Parens | id
	```

	c. Rewrite the grammar as a PEG

	```
	Exp			::= id ':=' Exp | Term TermTail
	TermTail	::= ('+' Term TermTail)?
	Term		::= Factor FactorTail
	FactorTail  ::= ('*' Factor FactorTail)?
	Factor		::= '(' Exp ')' | id
	```

3. Write an attribute grammar for the grammar in the previous problem. Your attribute grammar should describe the "obvious" run-time semantics.

4. Write an attribute grammar for evaluation (using the notation introduced in this class), whose underlying grammar is amenable to LL(1) parsing, for polynomials whose sole variable is x and for which all coefficients are integers, and all exponents are non-negative integers. The following strings must be accepted.
	* `2x`
	* `2x^3+7x+5`
	* `3x^8-x+x^2`
	* `3x-x^3+2`
	* `-9x^5-0+4x^100`
	* `-3x^1+8x^0`

