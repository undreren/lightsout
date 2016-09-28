module Game exposing (Model, init, Msg(..), update, view, subscriptions)

import Html exposing (Html, div, text, br, h1, button)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import Html.App as App
import Time exposing (Time)
import Random exposing (Seed)
import Level
import Menu


-- SYNONYMS


type alias Level =
    Level.Model


type alias Menu a =
    Menu.Model a



--MODEL


type View
    = GameView
    | MainMenu


type alias Model =
    { level : Level
    , mainMenu : Menu Msg
    , currentView : View
    , levelSeed : Seed
    }


init : Int -> Int -> Int -> Model
init cols rows seed =
    { level = Level.init cols rows 0
    , levelSeed = Random.initialSeed seed
    , currentView = MainMenu
    , mainMenu =
        Menu.init
            [ ( "New Game", NewGame )
            , ( "Resume Game", Switch GameView )
            ]
    }



--UPDATE


type Msg
    = LevelMsg Level.Msg
    | Tick Time
    | Switch View
    | NewGame


update : Msg -> Model -> Model
update msg model =
    case msg of
        LevelMsg lMsg ->
            { model | level = Level.update lMsg model.level }

        Tick t ->
            { model | level = Level.update (Level.Tick t) model.level }

        Switch view ->
            { model | currentView = view }

        NewGame ->
            let
                newLevel =
                    Level.init (model.level.board.cols)
                        (model.level.board.rows)
                        0
            in
                { model | level = newLevel, currentView = GameView }



--SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every (10 * Time.millisecond) Tick



--VIEW


view : Model -> Html Msg
view model =
    case model.currentView of
        GameView ->
            gameView model

        MainMenu ->
            mainMenuView model


gameView : Model -> Html Msg
gameView model =
    div [ class "game-box" ]
        [ h1 [] [ text "Lights Out" ]
        , button [ onClick (Switch MainMenu) ] [ text "Main Menu" ]
        , App.map LevelMsg (Level.view model.level)
        , br [] []
        , text <| "Moves: " ++ toString (List.length model.level.history)
        , br [] []
        , text <| "Time: " ++ toString (floor << Time.inSeconds <| model.level.elapsedTime)
        ]


mainMenuView : Model -> Html Msg
mainMenuView model =
    div [ class "game-box" ]
        [ h1 [] [ text "Lights Out" ]
        , Menu.view model.mainMenu
        ]
