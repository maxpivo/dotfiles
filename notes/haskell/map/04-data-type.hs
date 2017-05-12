-- Data Type in Haskell

-- alternative 1

type Pair = (String, String)
pair :: (String, String)
pair = ("key", "value")

-- note: no constructor, give error
-- data Pair = (String, String)

-- alternative 2
data Duo = Duo (String, String)

duo :: Duo
duo = Duo ("key", "value")

-- alternative 3
data Couple = Couple String String

couple :: Couple
couple = Couple "key" "value"

-- alternative 4
data Record = Record { key :: String, value :: String }

record :: Record
record = Record { key = "key", value = "value" }

main = do return ()    
