module Main exposing (main)

import Html.App as App
import Game


main =
    App.program
        { init = Game.init 7 7 0 ! []
        , update = \msg model -> Game.update msg model ! []
        , view = Game.view
        , subscriptions = Game.subscriptions
        }
