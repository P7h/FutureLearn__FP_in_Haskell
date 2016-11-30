# Week3 Notes of "Data Structures And Types" -- "Functional Programming in Haskell" MOOC


## Contents
* [Functions on Lists](#functions-on-lists)
    * [Recursion and lists](#recursion-and-lists)
        * [`length` function](#length-function)
        * [`filter` function](#filter-function)
    * [Computations over lists](#computations-over-lists)
        * [Function composition](#function-composition)
    * [`map` function](#map-function)
    * [Folding a list (reduction)](#folding-a-list-reduction)
        * [Left fold: `foldl`](#left-fold-foldl)
        * [Right fold: `foldr`](#right-fold-foldr)
    * [Maps and Folds versus Loops](#maps-and-folds-versus-loops)
    * [Summary of Map and Folds](#summary-of-map-and-folds)
* [Custom Data Types](#custom-data-types)
    * [User defined data types](#user-defined-data-types)
        * [Sum Data Type](#sum-data-type)
        * [Record or Product Data Type](#record-or-product-data-type)
    * [Type Classes](#type-classes)
* [Haskell History](#haskell-history)

------

## Functions on Lists
### Recursion and lists
* Every list must be either
    * `[]` or
    * `(x:xs)` for some `x` (the `head` of the list) and `xs` (the `tail`) where `(x:xs)` is pronounced as ` x cons xs`.
* The recursive definition follows the structure of the data:
    * Base case of the recursion is `[]`.
    * Recursion (or induction) case is `(x:xs)`.

#### `length` function
* Recursive definition of `length`:

```haskell
length :: [a] -> Int
length []       = 0                 # base case
length (x:xs)   = 1 + length xs     # recursion case
```

* Example:

```haskell
length [1..10]      -- > 10
```

#### `filter` function
* `filter` is given a predicate (a function that gives a Boolean result) and a list, and returns a list of the elements that satisfy the predicate.

```haskell
filter :: (a->Bool) -> [a] -> [a]
```

* Example:

```haskell
filter (<5) [3,9,2,12,6,4]      -- > [3,2,4]
```

* Recursive definition of `filter`:

```haskell
filter :: (a -> Bool) -> [a] -> [a]
filter pred []          = []
filter pred (x:xs)
    | pred x            = x : filter pred xs
    | otherwise         = filter pred xs
```

### Computations over lists
* `for` / `while` loops in an imperative language are naturally expressed as list computations in a functional language.
    * Perform a computation on each element of a list: `map`
    * Iterate over a list:
        * from left to right: `foldl`;
        * from right to left: `foldr`


#### Function composition
* Express a large computation by "chaining together" a sequence of functions that perform smaller computations.
    * The entire computation (first `g`, then `f`) is written as `f ∘ g` (traditional mathematical notation).
    * In `f ∘ g`, the functions are used in right to left order.
    * Haskell uses `.` as the function composition operator.

```haskell
(.) :: (b->c) -> (a->b) -> a -> c
(f . g) x = f (g x)
```

### `map` function
* `map` applies a function to every element of a list.

```haskell
map f [x0,x1,x2]    -- > [f x0, f x1, f x2]
```

* Common style is to define a set of simple computations using `map`, and to compose them.

```haskell
map f (map g xs) = map (f . g) xs
```

* Recursive definition of `map`:

```haskell
map :: (a -> b) -> [a] -> [b]
map _ []     = []
map f (x:xs) = f x : map f xs
```


### Folding a list (reduction)
* An iteration over a list to produce a singleton value is called a `fold`.

#### Left fold: `foldl`
* `foldl` is fold from the left.
* Typical application is `foldl f z xs`
    * The `z::b` is an initial value [or can be treated as an accumulator].
    * The `xs::[a]` argument is a list of values which we combine systematically using the supplied function `f`.
* Recursive definition of `foldl`:

```haskell
foldl :: (b -> a -> b) -> b -> [a] -> b
foldl f z0 xs0 = lgo z0 xs0
             where
                lgo z []     =  z
                lgo z (x:xs) = lgo (f z x) xs
```

* Example of `foldl` function with `(+)` as infix function:

```haskell
foldl (+) z [x0,x1,x2]      -- > ((z + x0) + x1) + x2
```

* Or `foldl` function can be summarized as:

```haskell
foldl f z [x0,x1,x2]        -- > f (f (f z x0) x1) x2
```

#### Right fold: `foldr`
* Similar to `foldl`, but `foldr` is fold from the right to left.
* typical application is `foldr f z xs`
    * The `z::b` is an initial value [or can be treated as an accumulator].
    * The `xs::[a]` argument is a list of values which we combine systematically using the supplied function `f`.
* Recursive definition of `foldl`:

```haskell
foldr :: (a -> b -> b) -> b -> [a] -> b
foldr k z = go
          where
            go []     = z
            go (y:ys) = y `k` go ys
```

* Example of `foldr` function with `(+)` as infix function:

```haskell
foldr (+) z [x0,x1,x2]      -- > x0 + (x1 + (x2 + z))
```

* Or `foldr` function can be summarized as:

```haskell
foldr f z [x0,x1,x2]        -- > f x0 (f x1 (f x2 z))
```

* A list can be constructed with `foldr` as `foldr cons [] xs = xs`.

```haskell
foldr (:) [] [x0,x1,x2]     -- > x0 :  x1 : x2 : []
```

* Examples of `foldr`:

```haskell
sum xs      = foldr (+) 0 xs
product xs  = foldr (*) 1 xs
```

### Maps and Folds versus Loops
* For list operations, it is usually easier to use higher-order functions like:
    * `map` for performing an operation on every element of a list
    * `foldl` / `foldr` for reducing a list to a single value.
* Sometimes these functions are referred to as list combinators.

```haskell
-- a list
lst = [1.. 10]

-- map
f x = x * (x + 1)
lst_ = map f lst

-- foldl
g = (/)
accl = foldl g 1 lst    -- > ((((((((((1 / 1) / 2) / 3) / 4) / 5) / 6) / 7) / 8) / 9) / 10) = 2.7557319223985894e-7

-- foldr
g' = (/)
accr = foldr g' 1 lst   -- > 1 / (2 / (3 / (4 / (5 / (6 / (7 / (8 / (9 / (10 / 1))))))))) = 0.24609375

-- main
main = do
    print lst_          -- > [2.0,6.0,12.0,20.0,30.0,42.0,56.0,72.0,90.0,110.0]
    print accl          -- > 2.7557319223985894e-7
    print accr          -- > 0.24609375
```

#### Summary of Map and Folds
* `map`: loop over list element-by-element, append new element to new list.
* `foldl`: loop over list element-by-element, update accumulator using current accumulator and element.
* `foldr`: loop over reverse list element-by-element, update accumulator using current accumulator and element.

```haskell
map     :: (a -> b) -> [a] -> [b]
foldl   :: (b -> a -> b) -> b -> [a] -> b
foldr   :: (a -> b -> b) -> b -> [a] -> b
```

------

## Custom Data Types
### User defined data types
* Combining the basic types [like Int, Bool, etc] we can generate custom data types, using algebraic sums and products.
* Custom data types are called algebraic data types.
* Keyword `data` indicates we are defining a new type.
* The name of the type and the names of the values should start with capital letters.

#### Sum Data Type
* The alternative values are separated with a vertical bar character (`|`).
* The alternative values relate to algebraic sums.
* `deriving Show` is required for printing values of custom data types.

```haskell
data SimpleNum = One | Two | Many deriving Show

let convert 1 = One
    convert 2 = Two
    convert _ = Many

:t One                  -- > One :: SimpleNum
convert 1               -- > One
convert 50              -- > Many
map convert [1..5]      -- > [One, Two, Many, Many, Many]
```

#### Record or Product Data Type
* Stores portfolio of values.
* The record values relate to algebraic products.

```haskell
data CricketScore = Score [Char] Int Int deriving Show
let x = Score "England" 255 10

:t x                    -- > CricketScore
```

### Type Classes
* The type class constrains member types to provide functions that conform to certain type signatures effectively, API constraints.
* Type classes are like interfaces in Java.
    * Types in the type class are like concrete implementations of the interface.
* Type classes provide a neat mechanism to enable operator overloading in Haskell.
* A Type class is a generalized family of similar types.
    * `Num` is a type class, which specifies a family of types including integer and floating-point types.
    * With `Eq` type class, we can compare values of such types equality with the (`==`) operator.
    * With `Ord` type class, we can order values of such types with relational operators like less than (`<`) and greater than (`>`).
        * For strings, less than (`<`) implements a lexicographic ordering.
    * With `Show` type class, we can generate string values that represent values of such types, like `toString()` in Java.
    * With `Read` type class, we can generate values of such types from string values.


```haskell
data SimpleNum = One | Two | Many deriving (Eq, Ord, Show, Read)

-- Show
show One                    -- > "One"
show Many                   -- > "Many"

-- Read
read "One" :: SimpleNum     -- > One

-- Eq
One == One                  -- > True
One == Two                  -- > False

-- Ord
One <= Two                  -- > True

:t (+)                      -- > (+) :: Num a => a -> a -> a
:t (==)                     -- > (==) :: Eq a => a -> a -> Bool
:t (<)                      -- > (<) :: Ord a => a -> a -> Bool

```

------

## Haskell History
* Please check Future Learn FP MOOC page for a [brief history of Haskell](https://www.futurelearn.com/courses/functional-programming-haskell/1/steps/115453).

