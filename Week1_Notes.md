# Week1 Notes of "Haskell First Steps" -- "Functional Programming in Haskell" MOOC


```
Haskell is a purely functional, lazily evaluated, statically typed programming language with type inference.
```

## Contents
* [Haskell Basics](#haskell-basics)
    * [Expressions](#expressions)
    * [Functions](#functions)
    * [Types](#types)
    * [Lists](#lists)
    * [Anonymous functions](#anonymous-functions)
    * [Higher-order functions](#higher-order-functions)
    * [More notes](#more-notes)
* [Haskell More Basics](#haskell-more-basics)
    * [Blocks](#blocks)
    * [Conditions](#conditions)
    * [`case` statement](#case-statement)
* [Reduction, Functions and Lists](#reduction-functions-and-lists)
    * [Reduction](#reduction)
        * [The Church-Rosser theorem](#the-church-rosser-theorem)
    * [Functions](#functions-1)
    * [Lists](#lists-1)
* [Try Haskell online](#try-haskell-online)
* [Install Haskell](#install-haskell)
* [Recommended reading](#recommended-reading)


## Haskell Basics
### Expressions
* Haskell has no statements, only expressions!
* Pure functional programming languages don’t have any statements — no assignments, no jumps.
* Instead, all computation is performed by evaluating expressions.

### Functions
* There are no parentheses or any special keywords / operators.
* Arguments are given after the function, separated by whitespace.
* Syntax is fairly simple:

    ```haskell
    function_name arguments = function_body
    ```

* Example function:

    ```haskell
    hello name = "Hello, " ++ name
    ```

### Types
* Haskell types are more powerful than C.
* Function definition follows the function type declaration.
* Type declaration is indicated by `::` and function arguments are separated by `->`.
* Syntax is fairly simple:

    ```haskell
    function_name :: arg1_type -> arg2_type -> argn_type -> return_type
    function_name arguments = function_body
    ```
* Example function:
    ```haskell
    f :: Int -> Int -> Int
    f x y =  x*y+x+y
    ```

* More info on the example function:
    * In this example, `f` is the function name.
    * Function arguments are of type `Int` and `Int`; while the return type is `Int`.
    * `x` and `y` are function arguments and `x*y+x+y` is the function body.

### Lists
* Python and Haskell have the same syntax for Lists.

    ```haskell
    lst = [ "A", "list", "of", "strings"]
    ```
* To join lists, syntax in Haskell is:

    ```haskell
    lst = [1,2] ++ [3,4]
    ```

### Anonymous functions
* Anonymous functions are called _lambda functions_ in Haskell, which form the basis of the language.
* Example syntax:

    ```haskell
    f = \x y -> x*y+x+y
    ```

### Higher-order functions
* Higher-order functions are functions that operate on functions.
* HOFs take other functions as arguments and may also return other functions.

    ```haskell
    map (\x -> x*2) [1..10]
    [2,4,6,8,10,12,14,16,18,20]
    ```

* More info on the example Higher-order function:
    * `map` function here is a typical example for HOF.
    * The initial input list is immutable. Output of this statement is a new list is  created after iterating / processing all the elements of the input list.
    * In this example, each element in the input list is doubled and returned as an element of another new list.

### More notes
* Precedence of function application: Function application binds tighter than anything else.
* So `f x + 3` means `(f x) + 3` and not `f (x+3)`
    * Similarly, `sqrt 16+9` = `13` which is deciphered by `sqrt(16) + 9`.
    * This should be written as `sqrt (16+9)` for getting `5` as result.
* If an argument to a function is an expression, it should be put in parentheses.
* Equations are not assignments
    * A name can be given only one value.
    * Names are often called "variables", but they do not vary.
    * In Haskell variables are constant!
    * Once a value is given to a name, it can never be changed!
    * This is part of the meaning of "pure" and "no side effects".

    ```haskell
    n = 1       -- just fine!
    x = 3 * n   -- fine
    n = x       -- Wrong: can have only one definition of n
    ```

* It is valid to write `n = n + 1`, it is termed as an equation and not as an assignment.
    * Haskell tries and fails to compute the result due to the recursive definition of `n` that has the property that `n = n + 1`.
* Think of an assignment statement as doing three things:
    * It evaluates the right hand side: computing a useful value.
    * It discards the value of the variable on the left hand side: destroying a value that might or might not be useful.
    * It saves the useful value of the RHS into the variable.
* In a pure functional language
    * Old values are never destroyed.
    * New useful ones just computed.
    * If the old value was truly useless, the garbage collector will reclaim its storage.
* `4+-3` will fail as Haskell thinks you wanted to use a special operation '+-', so it should be written as `4+(-3)`.
    * Same is the case with `abs (-3)`; this should not be written as `abs -3`.


## Haskell More Basics
### Blocks
* Example code block:
    ```haskell
    roots a b c =
        let
            det2 = b*b-4*a*c;
            det  = sqrt(det2);
            rootp = (-b + det)/a/2;
            rootm = (-b - det)/a/2;
        in
            [rootm,rootp]
    ```

* `let ... in ...` construct is an expression, so it returns a value. And there is no need for a return keyword.

### Conditions
* Every `if` should have `then` and its corresponding `else` clause.
* Again the `if ... then ... else ...` construct is an expression, so it returns a value.

    ```haskell
    max x y =
        if x > y
            then x
            else y
    ```

### `case` statement
* A `case` statement is useful for conditions with more than two choices.
* Can't have guards in `case` expressions.

    ```haskell
    data Color = Red | Blue | Yellow

    color = set_color
    action = case color of
        Red     -> action1
        Blue    -> action2
        Yellow  -> action3


    double zs   = case zs of
        []      -> []
        (x:xs)  -> (2 * x) : (double xs)
    ```


## Reduction, Functions and Lists
### Reduction
* The mechanism for executing functional programs is reduction.
* Reduction is the process of converting an expression to a simpler form.
    * Conceptually, an expression is reduced by simplifying one reducible expression (called "redex") at a time.
    * Each step is called a reduction.
* Reduction is the sole means of execution of a functional program.
* There are no statements, as in imperative languages; all computation is achieved purely by reducing expressions.

#### The Church-Rosser theorem
* Every terminating reduction path gives the same result
    * Correctness doesn’t depend on order of evaluation.
    * The compiler (or programmer) can change the order freely to improve performance, without affecting the result.
    * Different expressions can be evaluated in parallel, without affecting the result.
        * As a result, functional languages are leading contenders for programming future parallel systems.
* For more info, please check [Wiki page of The Church-Rosser theorem](https://en.wikipedia.org/wiki/Church%E2%80%93Rosser_theorem).

### Functions
* Haskell is a functional language so the function concept is essential to the language.
* There are two fundamental operations on functions:
    * function definition &raquo; creating a function and
    * function application &raquo; using a function to compute a result.

### Lists
* A list is a single value that contains several other values _of the **same data type**_.
* Syntax: the elements are written in square parentheses, separated by commas.

    ```haskell
    ['3', '5']
    ['x', 'y', 'z']
    [2.718, 50.0, -1.0]
    ```
* Return multiple values: Lists are useful to return multiple results from a function. `minmax` function below  returns both the smaller and the larger of two numbers:

    ```haskell
    minmax = \x y -> [min x y, max x y]
    minmax 3 8  == [3,8]
    minmax 8 3  == [3,8]
    ```
* Lazy evaluation: Elements / expressions are evaluated lazily. As long as the expression is not accessed, it is not evaluated.

    ```haskell
    let xs = [0..]      -- doesn’t throw out of memory
    xs !! 100 == 100    -- we can access any element in the list defined
    tail xs             -- This will continue to generate the numbers..........
    ```

* Constructing lists:
    * `++`: to concat two lists

        ```haskell
        [23, 29] ++ [48, 41, 44] == [23, 29, 48, 41, 44]
        ```

        * If `xs` is a list, then

            ```haskell
            [] ++ xs == xs
            xs ++ [] == xs
            ```
    * `..`: sequence of items `[0..5]` gives `[0,1,2,3,4,5]`
        * Sequences are not just limited to numbers. `['a'..'e'] == ['a','b','c','d','e']` which is actually same as `"abcde"` as any String in Haskell is basically a list of characters.
        * Elements can start from any digit / character and consecutive elements can be incremented or decremented.

            ```haskell
            [4,7..20]       == [4,7,10,13,16,19]        -- each subsequent element is incremented by 3
            [10,7..(-13)]   == [10,7,4,1,-2,-5,-8,-11]  -- each subsequent element is decremented by 3
            ['p','s'..'z']  == "psvy"                   -- for alphabets
            ['x','s'..'m']  == "xsn"                    -- alphabets decrementing
            ['$'..'*']      == "$%&'()*"                -- Even for special characters
            [(-6)..2]       == [-6,-5,-4,-3,-2,-1,0,1,2]
            ```

    * List comprehensions in Haskell were inspired by the mathematical notation set comprehension.

        ```haskell
        [3*x | x <- [1..10]] == [3,6,9,12,15,18,21,24,27,30]
        ```

* Operating on lists
    * `!!`: index a list by numbering the elements, starting with 0.
        * value at a specific index `['a'..'z'] !! 13 == n`
    * `head`: first element of list

        ```haskell
        head [1..10] == 1
        ```
    * `tail`: entire list except for the first element

        ```haskell
        tail [1..10]    == [2,3,4,5,6,7,8,9,10]
        tail ['m'..'r'] == "nopqr"
        ```
    * `init`: entire list except for the last element

        ```haskell
        init [1..10] == [1,2,3,4,5,6,7,8,9]
        ```
    * `last`: last element of the list

        ```haskell
        last [1..10]        == 10
        last ['x','s'..'m'] == 'm'
        ```


## Try Haskell online
* Haskell can be tried in the browser at [https://www.haskellmooc.co.uk](https://www.haskellmooc.co.uk).
* This website was actually created by extending the excellent "Try Haskell" developed by Chris Done: [https://tryhaskell.org/](https://tryhaskell.org/).


## Install Haskell
* Haskell compiler / interpreter can be installed using [Haskell Platform](https://www.haskell.org/platform).

>> Note: Though this course advices to install Haskell Platform, it is better to install [`Stack`](http://www.haskellstack.org/). Please look for the installation instructions and documentation on [Stack website](https://docs.haskellstack.org/en/stable/README/#how-to-install).


## Recommended reading
* Please check [`Haskell Learning Resources`](Haskell_Learning_Resources.md) for detailed list of resources for learning Haskell.

