#The Problems
1. We saw in the course notes, on the page entitled "[Syntax](http://cs.lmu.edu/~ray/notes/syntax/)", an example of an abstract syntax tree with five concrete syntaxes. Show a sixth version of this "same" program, this time using a concrete syntax that also passes for a JSON object.

    ```
    {
        Program:{
            Var: [x,y],
            While:{
                condition: y - 5,
                body: {
                    Var: y,
                    Read: [x, y],
                    x: 2 * (3 + y)
                }
            },
            Write: 5
        }
    }
    ```  
2. In the Ada language comments are started with "--" and go to the end of the line. Therefore the designers decided not to make the unary negation operator have the highest precedence. Instead, expressions are defined as follows:

   ```
    Exp  → Exp1 ('and' Exp1)*  |  Exp1 ('or' Exp1)*
    Exp1 → Exp2 (relop Exp2)?
    Exp2 → '-'? Exp3 (addop Exp3)*
    Exp3 → Exp4 (mulop Exp4)*
    Exp4 → Exp5 ('**'  Exp5)?  |  'not' Exp5  |  'abs' Exp5
   ```

   Explain why this choice was made. Also, give an abstract syntax tree for the expression `-8 * 5` and explain how this is similar to and how it is different from the alternative of dropping the negation from `Exp2` and adding `- Exp5` to `Exp4`.




    Since comments are denoted by "--", if negation had precedence over addition operations, the programmer would run into issues where they might want to subtract by a negative number and they end up with code commented out. For example, suppose a programmer wrote:

    ```
    x--y
    ```
    If the unary negation operator did have a higher precedence than the subtraction, this would technically be correct syntax (because whitespace is optional). But it would also be the correct syntax for a comment. One would obviously have precedence over the other, but it would likely be the comment and certainly be ambiguous and unintended. By giving the add operation precedence, the above code is incorrect syntax, since you cannot subtract by `-y`. 

    The abstract syntax tree for `-8*5` is

    ```
       -----
       | - |
       -----
         |
       -----
       | * |
       -----
         |
      -------
    ----- -----
    | 8 | | 5 |
    ----- -----
    ```

    If the unary negation operator was in `Exp4`, the diagram would be
    ```
       -----
       | * |
       -----
         |
      -------
    ----- -----
    | - | | 5 |
    ----- -----
      |
    -----
    | 8 |
    -----
    ```

    Because of math the result would be the same, but in the first example the product is negated, and in the second the term 8 is negated and then the product is found.

3. Here is a description of a language. Programs in this language are made up of a non-empty sequence of function declarations, followed by a single expression. Each function declaration starts with the keyword **fun** followed by the function's name (an identifier), then a parenthesized list of zero or more parameters (also identifiers) separated by commas, then the body, which is a sequence of one or more expressions terminated by semicolons with the sequence enclosed in curly braces. Expressions can be numeric literals, string literals, identifiers, function calls, or can be made up of other expressions with the usual binary arithmetic operators (plus, minus, times, divide) and a unary prefix negation and a unary postfix factorial (**!**). There's a conditional expression with the syntax `x` if `y` else `z`. Factorial has the highest precedence, followed by negation, the multiplicative operators, the additive operators, and finally the conditional. Parentheses are used, as in most other languages, to group subexpressions. Numeric literals are non-empty sequences of decimal digits with an optional fractional part and an optional exponent part. String literals delimited with double quotes with the escape sequences `\'`, `\"`, `\r`, `\n`, `\\`, and `\u` followed by four hexadecimal digits. Identifiers are non-empty sequences of letters, decimal digits, underscores, at-signs, and dollar signs, beginning with a letter or dollar sign, that are not also reserved words. Function calls are formed with an identifier followed by a comma-separated list of expressions bracketed by parentheses. There are no comments in this language, and whitespace can be used liberally between tokens.

   Write the micro and macrosyntax of this language.



    Please ignore whitespace.

    ## Microsyntax

    ```
    s          -> \s+
    id         -> (?!keyword)[a-zA-Z$][a-zA-Z0-9_@$]*
    numlit     -> \d+ (\.\d+)? ('e'\d+)?
    strlit     -> \"( \w | escape )+\"
    escape     -> \\( \' | \" | 'r' | 'n' | \\ | u[0-9A-F]{4} )
    keyword    -> fun
    ```

    ## Macrosyntax

    ```
    Program      -> (FunctionDec s*)+ _Exp_
    FunctionDec  -> 'fun' s+ id s* \(s* id?(, s* id)*\) s* Body
    Body         -> {(exp ';')+}
    Exp          -> 'if' s+ Exp1 s+ 'else' s+ Exp1
    Exp1         -> Exp2 s* addop s* Exp3
    Exp2         -> Exp3 s* multop s* Exp3
    Exp3         -> -? s* Exp4
    Exp4         -> Exp5!
    Exp5         -> s* (numlit | strlit | id | FunctionCall | \( s* Exp s* \)) s*
    FunctionCall -> id s* \(s* Exp? (, s* Exp)*\)
    ```

4. Give an abstract syntax tree for the following Java code fragment:

   ```
if (x > 2 || !String.matches(f(x))) {
    write(- 3*q);
} else if (! here || there) {
    do {
        while (close) tryHarder();
        x = x >>> 3 & 2 * x;
    } while (false);
    q[4].g(6) = person.list[2];
} else {
    throw up;
}
   ```

   Please note that the question asked for an abstract syntax tree and not a parse tree. If you give a parse tree, you will get a zero on the problem.

5. Complete the first pass of the design of the language that you will be writing a compiler for during this term. Give your language description on the README.md file of a public github repository you will be setting up for the project. You should have, in your README,
  * A nice logo
  * The name of your language, in a large font
  * A one paragraph introduction
  * A list of features
  * Lots of example programs. You can do the “your language on the left, JavaScript on the right” presentation style.

   Here are some examples of READMEs from previous years' projects. Please note that not all of these examples are sufficient, so the fact that they are called out here is in no way meant to suggest that these are worthy of full credit. Use your judgement.

  * [AboveAverageScript](https://github.com/ajohn104/AboveAverageScript)
  * [TeaScript](https://github.com/alexschneider/teascript)
  * [YACBL](https://github.com/akrs/YACBL)
  * [Yoda](https://github.com/andyjwon/yoda-lang)
  * [Spitfire](https://github.com/jcrawley/spitfire)
  * [Koan](https://github.com/jazzyfresh/koan-lang)
  * [Derpodile](https://github.com/thathalfkorean/cmsi488)
  * [GollumScript](https://github.com/r2d32/GollumScript)
  * [Singularity](https://github.com/waverill7/Singularity)
  * [KobraScript](https://github.com/AuthorOfTheSurf/kobra-script)
  * [Min](https://github.com/offDaCharts/min)

6. Implement the lexical analyzer for your compiler. You can look at [my little Iki compiler](https://github.com/rtoal/iki-compiler) for inspiration.