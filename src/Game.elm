module Game exposing (Model, init, Msg(..), update, view, subscriptions)

import Html exposing (Html, div, text, br, h1)
import Html.Attributes exposing (class)
import Html.App as App
import Time exposing (Time)
import Level


--MODEL


type alias Level =
    Level.Model


type alias Model =
    { level : Level
    }


init : Int -> Int -> Model
init cols rows =
    { level = Level.init cols rows 0
    }



--UPDATE


type Msg
    = LevelMsg Level.Msg
    | Tick Time


update : Msg -> Model -> Model
update msg model =
    case msg of
        LevelMsg lMsg ->
            { model | level = Level.update lMsg model.level }

        Tick t ->
            { model | level = Level.update (Level.Tick t) model.level }



--SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every (10 * Time.millisecond) Tick



--VIEW


view : Model -> Html Msg
view model =
    div [ class "game-box" ]
        [ h1 [] [ text "Lights Out" ]
        , App.map LevelMsg (Level.view model.level)
        , br [] []
        , text <| "Moves: " ++ toString (List.length model.level.history)
        , br [] []
        , text <| "Time: " ++ toString (floor << Time.inSeconds <| model.level.elapsedTime)
        ]
