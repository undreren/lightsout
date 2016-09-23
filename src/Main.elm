module Main exposing (..)

import Html exposing (text, Html)
import Html.App as App
import Board


main =
    App.beginnerProgram
        { model = Board.init 10 10
        , update = Board.update
        , view = Board.view
        }
