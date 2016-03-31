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

	d. Prove or disprove: "This grammar is ambiguous"

2. Here's a grammar that's trying to capture the usual expressions, terms, and factors, while considering assignment to be an expression.

	```
	Exp			::= id ':'' Exp | Term TermTail
	TermTail	::= ('+' Term TermTail)?
	Term		::= Factor FactorTail
	FactorTail ::= ('*' Factor FactorTail)?
	Factor		::= '(' Exp ')' | id
	```
	
	a. Prove that this grammar is not LL(1)
	
	b. Rewrite it so that it is LL(1)

	c. Rewrite the grammar as a PEG

3. Write an attribute grammar for the grammar in the previous problem. Your attribute grammar should describe the "obvious" run-time semantics.

4. Write an attribute grammar for evaluation (using the notation introduced in this class), whose underlying grammar is amenable to LL(1) parsing, for polynomials whose sole variable is x and for which all coefficients are integers, and all exponents are non-negative integers. The following strings must be accepted.
	* `2x`
	* `2x^3+7x+5`
	* `3x^8-x+x^2`
	* `3x-x^3+2`
	* `-9x^5-0+4x^100`
	* `-3x^1+8x^0`
