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
zip xs ys =
    case xs of
        [] ->
            []

        x :: xs' ->
            case ys of
                [] ->
                    []

                y :: ys' ->
                    ( x, y ) :: zip xs' ys'


allIndices : Int -> Int -> List ( Int, Int )
allIndices cols rows =
    List.concat <|
        List.indexedMap (\i row -> List.map ((,) i) row) <|
            List.repeat cols [0..rows - 1]
