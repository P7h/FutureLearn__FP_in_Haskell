
-- Reverse factorial in Haskell
-- Prashanth Babu V V :: 02nd Dec, 2016.

reverseFact :: Integer -> Maybe Integer
reverseFact m = revFact m 2

revFact :: Integer -> Integer -> Maybe Integer
revFact m n     | rem m n /= 0  = Nothing
                | factor == 1   = Just m
                | otherwise     = revFact factor (n+1)
                where factor    = div m n



-- ghci reverseFactorial
    -- reverseFact 479001600    -- > Just 12
    -- reverseFact 3628800      -- > Just 10
    -- reverseFact 18           -- > Nothing
