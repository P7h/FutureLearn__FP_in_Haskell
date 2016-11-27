
-- FizzBuzz in Haskell
-- Prashanth Babu V V :: 26th Nov, 2016.


fizzbuzz :: Int -> String
fizzbuzz n = if fb /= ""
             then fb
             else show n
             where fb = fizz n ++ buzz n


fizz:: Int -> String
fizz n  | n `mod` 3 == 0 = "Fizz"
        | otherwise      = ""


buzz:: Int -> String
buzz n  | n `mod` 5 == 0 = "Buzz"
        | otherwise      = ""


main = do
    mapM_ (putStrLn) [fizzbuzz x | x <- [1..100]]


-- ghc fizzbuzz.hs
-- fizzbuzz.exe