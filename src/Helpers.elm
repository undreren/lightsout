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
