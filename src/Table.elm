module Table
    exposing
        ( Table
        , initialize
        , generate
        , get
        , set
        , modify
        , rows
        , cols
        , toArray
        , toList
        , isEmpty
        , map
        )

import Array exposing (Array)


type Table a
    = Table (Array (Array a))


initialize : Int -> Int -> a -> Table a
initialize cols rows v =
    Table << Array.repeat cols << Array.repeat rows <| v


generate : Int -> Int -> (Int -> Int -> a) -> Table a
generate cols rows f =
    Table << Array.initialize cols <| \c -> Array.initialize rows (\r -> f c r)


get : ( Int, Int ) -> Table a -> Maybe a
get ( i, j ) (Table table) =
    case Array.get i table of
        Nothing ->
            Nothing

        Just col ->
            Array.get j col


set : ( Int, Int ) -> a -> Table a -> Table a
set ( i, j ) v (Table table) =
    let
        col =
            Array.get i table
    in
        case col of
            Nothing ->
                Table table

            Just arr ->
                Table <| Array.set i (Array.set j v arr) table


modify : ( Int, Int ) -> (a -> a) -> Table a -> Table a
modify idx f table =
    case get idx table of
        Just v ->
            set idx (f v) table

        Nothing ->
            table


rows : Table a -> Int
rows (Table table) =
    case Array.get 0 table of
        Just arr ->
            Array.length arr

        Nothing ->
            0


cols : Table a -> Int
cols (Table table) =
    if rows (Table table) > 0 then
        Array.length table
    else
        0


toArray : Table a -> Array (Array a)
toArray (Table table) =
    table


toList : Table a -> List (List a)
toList =
    List.map (Array.toList) << Array.toList << toArray


isEmpty : Table a -> Bool
isEmpty table =
    (cols table <= 0) || (rows table <= 0)


map : (a -> b) -> Table a -> Table b
map f (Table table) =
    Table <| Array.map (Array.map f) table
