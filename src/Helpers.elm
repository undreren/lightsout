module Helpers exposing (..)


transpose : List (List a) -> List (List a)
transpose xs =
    case xs of
        [] ->
            []

        _ ->
            let
                heads =
                    List.filterMap List.head xs

                tails =
                    List.filterMap List.tail xs
            in
                heads :: transpose tails


zip : List a -> List b -> List ( a, b )
zip =
    zipWith (,)


zipWith : (a -> b -> c) -> List a -> List b -> List c
zipWith f xs ys =
    case ( xs, ys ) of
        ( x :: xs', y :: ys' ) ->
            f x y :: zipWith f xs' ys'

        _ ->
            []


allIndices : Int -> Int -> List ( Int, Int )
allIndices cols rows =
    List.repeat rows [0..cols - 1]
        |> List.indexedMap (\i xs -> List.map ((,) i) xs)
        |> List.concat
