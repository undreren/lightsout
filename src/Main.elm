module Main exposing (..)

import Html.App as App
import Game


main =
    App.program
        { init = Game.init
        , update = Game.update
        , view = Game.view
        , subscriptions = Game.subscriptions
        }
