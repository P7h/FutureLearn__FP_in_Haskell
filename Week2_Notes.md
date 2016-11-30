# Week2 Notes of "Haskell Building Blocks" -- "Functional Programming in Haskell" MOOC

## Contents
* [Boolean Values and Expressions](#boolean-values-and-expressions)
    * [Equality and Comparison Operators](#equality-and-comparison-operators)
    * [Testing List membership with the `elem` function](#testing-list-membership-with-the-elem-function)
    * [Using infix and prefix operations](#using-infix-and-prefix-operations)
* [More Boolean Operations](#more-boolean-operations)
* [Zipping Lists](#zipping-lists)
* [Input / Output](#input--output)
* [I/O Monad](#io-monad)
* [Installing Haskell](#installing-haskell)

------

## Boolean Values and Expressions
### Equality and Comparison Operators
* Boolean Values are either `True` and `False`.
* Double-equals operator `==` is used for testing value equality.
* Not-equals operator is `/=` (looks like an equals sign with a line through it).
* Haskell cannot compare two values that have different types.
* Haskell supports the standard comparison / relational operators, `<`, `<=`, `>`, `>=`.

### Testing List membership with the `elem` function
* `elem` function returns true if a value is part of a list, and false otherwise.

```haskell
elem 1 [1,2,3]  -- > True
```

### Using infix and prefix operations
* Haskell permits any two-argument function to be written as an infix operator using backquote (`) characters.

```haskell
1 `elem` [1,2,3]    -- > True
42 `max` 13         -- > 42
(+) 1 1             -- > 2
```

------

## More Boolean Operations
* The `not` function returns the opposite boolean value, the logical complement.

```haskell
not True            -- > False
not (not False)     -- > False
```
* `&&` infix operator is a boolean conjunction (`AND` function).

```haskell
True && True        -- > True
False && True       -- > False
```

* `||` infix operator is a boolean disjunction (logical `OR`); dual of the `AND` operation.

```haskell
True || False       -- > True
False || False      -- > False
```

* `xor` function returns true when its two boolean arguments are different.

```haskell
True `xor` False        -- > True
False `xor` False       -- > False
```

* Haskell supports multi-input boolean operations with `and` and `or` functions that take a list of boolean values as a single input.

```haskell
and [False, True, False, True]      -- > False
or [True, True, False]              -- > True
```

* `if` expressions evaluate to either the `then` value or the `else` value, based on the `if` value.

```haskell
if 2*2==4 then "happy" else "sad"   -- > "happy"
if True then 42 else pi             -- > 42.0
```

------

## Zipping Lists
* `zip` function combines a pair of lists into a list of pairs.
    * If `zip` function is used on lists which are of different lengths, length of the output list will be the length of the shortest list.
* `zip3` function combines three lists into a triplet.
* By adding `import Data.List`, we get pre-baked definitions of `zip3` ... `zip7` and `zipWith3` ... `zipWith7`.
* `zipWith` function is a generalization of `zip`.
    * While `zip` can only combine elements from two input lists by creating pairs of those elements, `zipWith` allows us to provide a function that tells us how to combine the elements from the input lists.
    * `zipWith` function applies a function to the result of `zip`.
    * `zipWith` function can take a lambda function for the operation.

```haskell
zip [1,2,3] [4,5]                           -- > [(1,4),(2,5)]
zipWith max [1,2,3] [0,2,4]                 -- > [1,2,4]
zipWith (+) [1,2,3] [0,2,4]                 -- > [1,4,7]
zipWith (\x->(\y->(x,y))) [1,2,3] "abc"     -- > [(1,'a'),(2,'b'),(3,'c')]    -- Note: Strings in Haskell are list of characters
```

------

## Input / Output
* Input is with `getLine` and output is with `putStrLn`.
* `putStrLn` (like `println` in Java or `print` in Python) prints a character string to the terminal.
* `getLine` function reads in a character string from user input.
    * After `getLine` function is invoked, text should be typed at the `>` prompt followed by pressing the enter key.
* `read` reads values as strings, and converts them into other types.
    * A type annotation (for example: `::Int`)  is mandatory; otherwise it is not clear what type of number the input String is meant to represent.
* `show` takes a value and returns a String representation of that value.
    * `show` function is the dual of the `read` function.
* `read` and `show` functions synthesize values from Strings and vice versa.
* `print` does the composition of `putStrLn` and `show`.

```haskell
putStrLn ("hello " ++ "world" ++ "!!")  -- > "hello world!!" -- :: String
do {
    putStrLn "what is your name?"
    x <- getLine
    putStrLn ("hello " ++ x)
}
read "42" :: Int                        -- > 42     -- :: Int
show 42                                 -- > "42"             -- :: String
print 42                                -- > 42              -- :: IO ()
```

------

## I/O Monad
* Input and output (I/O) operations are impure.
* Use `do` to specify a sequence of actions.
* Use `<-` inside a do to associate input values with names.
* Any value or function that involves I/O has IO in its type.
* Note: `<-` is for associating names with values in do blocks;
    * Whereas `->` is used for defining functions.

```haskell
let greet() = do
    planet <- getLine
    home <- getLine
    putStrLn ("greetings " ++ planet ++ "ling.")
    putStrLn ("I am from " ++ home ++ ".")
    putStrLn "Take me to your leader."
```

------

## Installing Haskell
Two bundled distributions of GHC are:

* [Haskell Platform](https://www.haskell.org/platform) and
* [Stack](https://docs.haskellstack.org/en/stable/README/)

