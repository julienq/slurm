unit :: Int -> Char -> Char -> Char -> String
unit 0 _ _ _ = ""
unit 1 i _ _ = i:""
unit 2 i _ _ = i:i:""
unit 3 i _ _ = i:i:i:""
unit 4 i v _ = i:v:""
unit 5 _ v _ = v:""
unit 6 i v _ = v:i:""
unit 7 i v _ = v:i:i:""
unit 8 i v _ = v:i:i:i:""
unit 9 i _ x = i:x:""

thousands :: Int -> String
thousands 0 = ""
thousands n = 'm':(thousands $ n - 1)

roman :: Int -> String
roman n
  | n == 0 = "nulla"
  | n > 0 = (thousands (n `quot` 1000)) ++
            (unit ((n `rem` 1000) `quot` 100) 'c' 'd' 'm') ++
            (unit ((n `rem` 100) `quot` 10)   'x' 'l' 'c') ++
            (unit (n `rem` 10)                'i' 'v' 'x')

