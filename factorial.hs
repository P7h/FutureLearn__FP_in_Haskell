
-- Factorial [tail recursion] in Haskell
-- Prashanth Babu V V :: 02nd Dec, 2016.

factorial :: Integer -> Integer
factorial n = tailrecFact n 1


tailrecFact :: Integer -> Integer -> Integer
tailrecFact n acc   | n == 1    = acc
                    | otherwise = tailrecFact (n-1) (acc * n)



-- ghci factorial
    -- factorial 12       -- > 479001600 
    -- factorial 10       -- > 3628800
