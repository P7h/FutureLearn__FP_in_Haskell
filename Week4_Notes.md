# Week4 Notes of "When Programs Get Bigger" -- "Functional Programming in Haskell" MOOC


## Contents
* [Program Structure](#program-structure)
    * [`let` expression](#let-expression)
    * [`where` clause](#where-clause)
    * [`let` vs `where`](#let-vs-where)
    * [Guards](#guards)
    * [`case` expressions](#case-expressions)
    * [Dealing with uncertainty](#dealing-with-uncertainty)
* [Parsing Text](#parsing-text)
    * [Functional machinery](#functional-machinery)
    * [Parsing text](#parsing-text)
        * [Alternative approaches to parsing](#alternative-approaches-to-parsing)
        * [Parser combinators](#parser-combinators)
    * [Quick Primer on Monads](#quick-primer-on-monads)
        * [Key syntactic features of a monad](#key-syntactic-features-of-a-monad)
    * [Parsing using Parsec](#parsing-using-parsec)
* [QuickCheck](#quickcheck)

------

## Program Structure
### `let` expression
* A `let` expression provides local scope.
* A `let` expression has a series of equations defining variable values and a final expression (after the `in` keyword) that computes a value with those variables in scope.
* The variable names in a `let` expression should be lined up underneath one another.
    * Whitespace is important to interpret the code correctly.

```haskell
journeycost :: Float -> Float -> Float
journeycost miles fuelcostperlitre =
 let milespergallon = 35
     litrespergallon = 4.55
     gallons = miles/milespergallon
 in (gallons*litrespergallon*fuelcostperlitre)
```

### `where` clause
* Inside an equation, `where` keyword provides definitions for variables that are used in the equation.
* Similar to `let`, `where` must be indented more than the start of the enclosing equation.

```haskell
cel2fahr :: Float -> Float
cel2fahr x = (x*scalingfactor) + freezingpoint
    where scalingfactor = 9.0/5.0
          freezingpoint = 32
```

### `let` vs `where`
* `let` and `where` have similarities:
    * Both introduce a local scope.
    * Both allow any number of equations to be written.
    * Both allow the equations to be written in any order, and variables defined in any equation can be used ("are in scope") in the other equations.

* Yet there are a few differences:
    * `let` expressions are expressions;
        * `let` can be used anywhere an expression is allowed.
    * `where` clauses are not expressions;
        * `where` can be used only to provide some local variables for a top level equation.


### Guards
* Guards are a notation for defining functions based on predicate values.
* Guards are easier to read than `if` / `then` / `else`, if there are more than two conditional outcomes
* `otherwise` guard should always be last, it’s like the `default` case in a C-style `switch` statement.

```haskell
-- `absolute` method
absolute x = if (x < 0) then (-x) else x

-- same method using guards
absolute x
    | x < 0     = -x
    | otherwise = x
```

### `case` expressions
*  A value with an algebraic data type may have one of several different forms — such as a `Leaf` or a `Node`, in the case of `Tree` structures.
    * Therefore to process such a value we need several segments of code, one for each possible form.
* The `case` expression examines the value, and chooses the corresponding clause.
* Similar to a guard, but `case` expression does __*pattern matching*__ and selects clause based on the value.
    * Like `otherwise` in guards, a `case` expression has a catch-all pattern: underscore character `_`,  which means 'don't care' or 'match anything'.
* `if` expression is just _syntactic sugar_ for `case` expressions.

```haskell
data Pet = Cat | Dog | Fish

hello :: Pet -> String
hello x =
  case x of
    Cat -> "meeow"
    Dog -> "woof"
    Fish -> "bubble"

hello Dog     -- > "woof"
```

### Dealing with uncertainty
* `Maybe` encapsulates an optional or possibly missing values.
* `Maybe` values denote missing results with `Nothing`.
    * This is type-safe and better than `null` in C-like languages.
    * `Maybe` is like `Option` in Scala.
* `Maybe` is either `Nothing` or `Just` a.
* `Maybe` derives two type classes:
    * `Eq` for equality and
    * `Ord` for comparison.
* `Maybe` values can be propagated by:
    * Using lots of `case` statements or
    * `Monads`
* `fmap`, a higher-order function applies function to the value inside `Maybe`.

```haskell
maxhelper :: Int -> [Int] -> Int
maxhelper x []      = x
maxhelper x (y:ys)  = maxhelper (if x > y then x else y) ys

-- get maximum item of a list
maxfromlist :: [Int] -> Maybe Int
maxfromlist []      = Nothing
maxfromlist (x:xs)  = Just (maxhelper x xs)

maxfromlist [1,2,3]     -- > Just 3
maxfromlist []          -- > Nothing


-- how to apply a function to the value inside `Maybe`
let inc = (+1)
inc 1                   -- > 2
inc (Just 1)            -- > Fails
fmap inc (Just 1)       -- > Just 2
fmap inc Nothing        -- > Nothing
```

------

## Parsing Text
### Functional machinery
* Returning functions as values
    * Functions that take functions as arguments.
    * Functions can also return functions as values.
    * 2 different interpretations:

```haskell
-- `sum` is the result returned by partial application of (`foldl`).
sum = foldl (+) 0

--  `sum` is a function resulting from partial application of (`foldl`).
sum = \xs -> foldl (+) 0 xs
```

* Function generators
    * We can use this concept to generate parameterised functions:

```haskell
-- Generates functions that add a constant number to their argument
gen_add_n = \n ->
    \x -> x+n

add_3 = gen_add_n 3
add_7 = gen_add_n 7

add_3 5 --> 8
add_7 4 --> 11
```

    * It is not limited to numeric constants:

```haskell
-- Generates functions that perform a given arithmetic operation on a constant number and their argument
gen_op_n = \op n ->
    \x -> x `op` n

add_3 = gen_op_n (+) 3
mult_7 = gen_op_n (*) 7

add_3 5 --> 8
mult_7 4 --> 28
```

### Parsing text
* A functional program is organised around a tree-like data structure with an algebraic data type that represents the core data.
* A parser reads text input and generates the tree.
* Functions perform transformations or traversals on the tree.
* Pretty-printer functions output the tree (original or transformed).

#### Alternative approaches to parsing
* User provides input in an awkward form. _Don't do it_.
* Write the parser by hand, with just ordinary list processing functions. _Don't do it_.
* Write the parser using regular expressions. _Don't do it_.
* Use parser combinators. _Recommended approach_.
* Use a parser generator; e.g. bison, antlr, happy. _Best approach for heavy-weight parsers_.

#### Parser combinators
* Parser combinators are functions that allow you to combine smaller parsers into bigger ones.
* They are higher-order functions that take functions as arguments and return functions.
* A parser combinator library provides both basic parsers (for words, numbers etc.) and combinators.

### Quick Primer on Monads
* Monads are used to structure computations.
* Example: `IO` monad is used to perform IO.

```haskell
hello :: String -> IO String
hello x =
  do
     putStrLn ("Hello, " ++ x)
     putStrLn "What's your name?"
     name <- getLine
     return name
```

#### Key syntactic features of a monad
* The `do` keyword;
* The sequence of commands;
* The way to extract information from a monadic computation using the left arrow `<-`;
* And the return keyword.
    * using the `do` notation is quite similar to imperative programming.
* A computation done in a monad returns a "monadic" type ==> string is returned inside the monad.
    * `return` value of the above `hello` function: not just `String` but `IO String`.

### Parsing using Parsec
[Building a simple parser using the Parsec library](https://github.com/wimvanderbauwhede/HaskellMOOC/tree/master/ParsecTutorial)

------

## QuickCheck
* QuickCheck automatically generates test cases for Haskell programs.
* `quickCheck` shows the results of the testcases executed.
    * `verboseCheck` also shows the generated testcases.

```haskell
-- Returns the absolute value of a number.
absolute x
    | x < 0     = -x
    | otherwise = x

-- Testcases can be generated using the following QuickCheck property specification.
import Test.QuickCheck
quickCheck ((\n -> (absolute (n) == n) || (0 - absolute(n) ==n)) :: Int -> Bool)


-- Find minimum of a list [first element of a sorted list is its minimum].
import Data.List
import Test.VerboseCheck
verboseCheck ((\l -> (if l == [] then True else (minimum l) == (sort l) !! 0)) :: [Char] -> Bool)
```
