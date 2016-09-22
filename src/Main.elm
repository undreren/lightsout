module Main exposing (..)

import Html exposing (text, Html)
import Html.App as App
import Light


main =
    App.beginnerProgram
        { model = Light.init
        , update = Light.update
        , view = Light.view
        }
