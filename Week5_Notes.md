# Week5 Notes of "Hardcore Haskell" -- "Functional Programming in Haskell" MOOC


## Contents
* [Laziness and Infinite Data Structures](#laziness-and-infinite-data-structures)
    * [Lazy evaluation](#lazy-evaluation)
    * [Infinite Data Structures](#infinite-data-structures)
* [Types, lambda functions and type classes](#types-lambda-functions-and-type-classes)
    * [Function types](#function-types)
    * [Lambda expressions](#lambda-expressions)
        * [Monomorphic functions](#monomorphic-functions)
        * [Polymorphic functions](#polymorphic-functions)
    * [Currying](#currying)
        * [Partial Application](#partial-application)
    * [Polymorphism](#polymorphism)
        * [Parametric polymorphism](#parametric-polymorphism)
        * [Ad hoc polymorphism](#ad-hoc-polymorphism)
    * [Type inference](#type-inference)
        * [Type inference rules](#type-inference-rules)
* [Haskell in the Real World](#haskell-in-the-real-world)

------

## Laziness and Infinite Data Structures
### Lazy evaluation

| **Lazy evaluation** | **Eager evaluation** |
|---|---|
| Haskell | Java |
| .NET System.Lazy<T> | Python |
| Miranda | ML |

* Haskell is a _lazy_ language.
    * Evaluation of expressions is delayed until their values are actually needed.
    * If computations are not needed, then they won't be evaluated. Or in other words: Only evaluate what is needed.
    * We can have inifinite data structures.
* In a lazy language, if a parameter value is never needed then the parameter is never evaluated.
* Take an example of `f(1 + 1)`:
    * In an eager language, the calculation is done when the function is invoked: _call by value_.
    * In a lazy language, the calculation is only done when the parameter value is used in the function body: _call by need_.
* Simplest non-terminating value is called bottom, written in mathematical notation `⊥` [ie `_` symbol below `\` symbol; also called `falsum`].
    * A function is strict in its argument if when we supply bottom as that argument the function fails to terminate.

```haskell
let ones = 1 : ones
head ones           -- > 1
tail ones           -- > [1,1,1,.........]  -- does n't fail; but an infinite list
ones                -- > [1,1,1,.........]  -- does n't fail; but an infinite list
```

### Infinite Data Structures
* We can compute with infinite data structures so long as we don't traverse the structure infinitely.
    * `take n xs`: gets only the specified number of elements from the list.
    * `drop n xs`: drops the specified number of elements from the list and returns the rest of the list.
    * `repeat a`: generates infinite list of elements [of item: `a`, which can be a number, char, etc]
* Haskell can process infinite lists as it evaluates the lists in a lazy fashion — ie it only evaluates list elements as they are needed.


```haskell
[1..]               -- > [1,2,3,4,........]     -- an infinite list
take 3 ones         -- > [1,1,1]                -- a simple finite list
drop 3 ones         -- > [1,1,1,1,........]     -- does n't fail; but again an infinite list
repeat 1            -- > [1,1,1,1,........]     -- an infinite list

-- Fibonacci sequence
let fibs = 1:1:(zipWith (+) fibs (tail fibs))   -- > 1, 1, 2, 3, 5, 8, 13, 21, ...


-- To calculate an infinite list of prime numbers.
properfactors :: Int -> [Int]
properfactors x = filter (\y->(x `mod` y == 0)) [2..(x-1)]

numproperfactors :: Int -> Int
numproperfactors x = length (properfactors x)

primes :: [Int]
primes = filter (\x-> (numproperfactors x == 0)) [2..]
```

------

## Types, lambda functions and type classes
### Function types
* Functions have types containing an arrow, e.g. `Int -> String`.
* Ordinary data types are for:
    * primitive data (like `Int` and `Char`) and
    * basic data structures (like `[Int]` and `[Char]`).
* Algebraic data types are types that combine other types either as:
    * records (`products`) or
    * variants (`sums`)

```haskell
-- records / products
data Pair = Pair Int Double

-- variants / sums
data Bool = False | True
```

### Lambda expressions
* A lambda expression `\x -> e` contains:
    * An explicit statement that the formal parameter is `x`, and
    * The expression `e` that defines the value of the function.
* Since functions are "first class", they are ubiquitous, and it’s often useful to denote a function anonymously using _lambda expressions_.
* The following lambda expression is read as: "lambda x arrow x+1".

```haskell
\x -> x + 1
```

* Lambda expressions are most useful when they appear inside larger expressions.

```haskell
map (\x -> 2 * x) xs    -- > each element of the list is doubled.
```

#### Monomorphic functions
* Monomorphic functions: having one form.

```haskell
f :: Int -> Char
f i = "abcdefghijklmnopqrstuvwxyz" !! i

x :: Int
x = 3

f x :: Char
f x -- > 'd'
```

#### Polymorphic functions
* Polymorphic functions: having many forms.

```haskell
fst :: (a,b) -> a
fst (x,y) = x

snd :: (a,b) -> b
snd (x,y) = y
```

### Currying
* Currying is in the honor of Haskell Curry; but concept was actually proposed originally by another logician, Moses Schönfinkel.
* Currying is a technique of rewriting a function of multiple arguments into a sequence of functions with a single argument.
* Functions can be restricted to have just one argument, _without losing any expressiveness_.
    * The technique makes essential use of higher order functions.
    * It has many advantages, both practical and theoretical.

```haskell
f :: Int -> Int -> Int
f x y = 2*x + y

f :: Int -> (Int -> Int)
f 5 :: Int -> Int

f 3 4 = (f 3) 4

g :: Int -> Int
g = f 3
g 10            -- > (f 3) 10 -- > 2*3 + 10
```

* The arrow operator takes two types: `a -> b`, and gives the type of a function with argument type `a` and result type `b`.
* Arrows group to the right, and application groups to the left.

```haskell
f :: a -> b -> c -> d
f :: a -> (b -> (c -> d))

f x y z = ((f x) y) z
```

#### Partial Application
* Currying means rewriting a function of more than one argument to a sequence of functions, each with a single argument.
* The arrow `->` is right-associative, so the following 2 function signatures are exactly same.
    * In the second function signature, `f` is a function with a single argument of type `X` which returns a function of type `Y -> Z -> A`.

```haskell
f :: X -> Y -> Z -> A
f :: X -> (Y -> (Z -> A))
```

* Partial application means that we don’t need to provide all arguments to a function.

```haskell
sq x y = x * x + y * y
-- the above function can also be written as:
sq x y = (sq x) y

sq4 = sq 4      -- > \y -> 16 + y * y
sq4 3           -- > (sq 4) 3 = sq 4 3 = 25
```

### Polymorphism
#### Parametric polymorphism
* A polymorphic type that can be instantiated to _any type_.
* Represented by a type variable. It is conventional to use `a`, `b`, `c`, ...
* `length :: [a] -> Int` can take the length of a list whose elements could have any type.

#### Ad hoc polymorphism
* A polymorphic type that can be instantiated to _any type chosen from a set, called a "type class"_.
* Represented by a type variable that is constrained using the `=>` notation.
* `(+) :: Num a => a -> a -> a` says that `(+)` can add values of any type `a`, provided that `a` is an element of the type class `Num`.


### Type inference
* Many functional languages feature type inference.
* Type classes allow restrictions to be imposed on polymorphic type variables.
    * Type classes express that e.g. a type represents a number, or something that can be ordered.
* Type inference is the process by which Haskell 'guesses' the types for variables and functions, without the need to specify these types explicitly.
* Type checking takes a type declaration and some code, and determines whether the code actually has the type declared.
* Type inference is the analysis of code in order to infer its type.
* Type inference works by:
    * Using a set of type inference rules that generate typings based on the program text.
    * Combining all the information obtained from the rules to produce the types.

#### Type inference rules
* Type inference is analysis of code in order to infer its type based on type inference rules:
    * Context
    * Type of constant
    * Type of application
    * Type of lambda expression

------

## Haskell in the Real World
Functional programming is used by a growing number of companies today. For a small list, please check Future Learn FP MOOC page for this topic.
[https://www.futurelearn.com/courses/functional-programming-haskell/1/steps/108928](https://www.futurelearn.com/courses/functional-programming-haskell/1/steps/108928)