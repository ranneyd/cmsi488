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

	I have no idea what this language does other than match strings that have 'a's and 'b's
  
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

	This grammar is not LL(1). The problem is with nonterminal E. E is optional. Suppose we are parsing a string, the next character is 'a' and we end up at E. Do we match `'a' B` or do we terminate and backtrack to `A M` and let M continue to `S->A->'a' E` which matches our 'a'? The choice matters because if the next character is a 'b', the second option will not work and we must evaluate the `'a' B`. Since we're looking ahead two, this is not LL(1); it is at least LL(2).

	d. Prove or disprove: "This grammar is ambiguous"

	This grammar is ambigious because you can write different parse trees for the same string for some strings. Consider 'aabbaa'. S can match 'a', 'aabba', and 'abbaa'. Since S is A followed by M, and M is an optional new S, our S can be followed by another S. This means that the first S can be 'a' and the second can be 'abbaa' or the first can be 'aabba' and the second can be 'a'.

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
	Exp		::= Mult ('+' Mult)*
	Mult	::= Factor ('*' Factor)*
	Factor	::= '(' Exp ')' | id ( ':=' Exp)?
	```

	c. Rewrite the grammar as a PEG

	```
	Exp		::= Mult (Plus Mult)*
	Mult	::= Factor (Star Factor)*
	Factor	::= oParen Exp cParen
	Factor	::= Id (Assign Exp)?
	Id		::= id
	Plus	::= '+'
	Star	::= '*'
	oParen	::= '('
	cParen	::= ')'
	assign	::= ':='
	```

3. Write an attribute grammar for the grammar in the previous problem. Your attribute grammar should describe the "obvious" run-time semantics.

4. Write an attribute grammar for evaluation (using the notation introduced in this class), whose underlying grammar is amenable to LL(1) parsing, for polynomials whose sole variable is x and for which all coefficients are integers, and all exponents are non-negative integers. The following strings must be accepted.
	* `2x`
	* `2x^3+7x+5`
	* `3x^8-x+x^2`
	* `3x-x^3+2`
	* `-9x^5-0+4x^100`
	* `-3x^1+8x^0`
