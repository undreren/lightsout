module Game exposing (Model, init, Msg(..), update, view, subscriptions)

import Html exposing (Html, div, text, br, h1, button)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import Html.App as App
import Time exposing (Time)
import Random exposing (Seed, int, initialSeed, generate, minInt, maxInt)
import Level
import Menu


-- SYNONYMS


type alias View =
    Model -> Html Msg


type alias Level =
    Level.Model


type alias Menu a =
    Menu.Model a



--MODEL


type Model
    = Model
        { currentView : View
        , seed : Seed
        , now : Time
        }


init : ( Model, Cmd Msg )
init =
    Model
        { seed = initialSeed 0
        , currentView = mainMenuView menuWithOutResume
        , now = 0
        }
        ! [ int minInt maxInt
                |> generate (SetSeed << initialSeed)
          ]



--UPDATE


type Msg
    = LevelMsg Level Level.Msg
    | SwitchView View
    | Tick Time
    | NewGame
    | GoToMenu (Menu Msg)
    | GoToLevel Level
    | SetSeed Seed


update : Msg -> Model -> Model
update msg (Model model) =
    case msg of
        LevelMsg level lMsg ->
            let
                newLevel =
                    Level.update lMsg level
            in
                Model { model | currentView = gameView newLevel }

        Tick t ->
            Model { model | now = t }

        SwitchView newView ->
            Model { model | currentView = newView }

        SetSeed seed ->
            Model { model | seed = seed }

        GoToMenu menu ->
            Model
                { model | currentView = mainMenuView menu }

        GoToLevel level ->
            Model
                { model | currentView = gameView level }

        NewGame ->
            let
                newLevel =
                    Level.init 7 7 model.now
            in
                update (GoToLevel newLevel) (Model model)



--SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every (Time.second / 60) Tick



--VIEW


view : Model -> Html Msg
view (Model model) =
    model.currentView (Model model)


gameView : Level -> Model -> Html Msg
gameView level (Model model) =
    div [ class "game-box" ]
        [ h1 [] [ text "Lights Out" ]
        , button [ onClick <| GoToMenu (menuWithResume level) ] [ text "Main Menu" ]
        , App.map (LevelMsg level) (Level.view level)
        , br [] []
        , text <| "Moves: " ++ toString (List.length level.history)
        , br [] []
        , text <| "Time: " ++ toString (floor << Time.inSeconds <| model.now - level.startTime)
        ]


mainMenuView : Menu Msg -> Model -> Html Msg
mainMenuView menu _ =
    div [ class "game-box" ]
        [ h1 [] [ text "Lights Out" ]
        , Menu.view menu
        ]


menuWithResume : Level -> Menu Msg
menuWithResume level =
    Menu.init
        [ ( "New Game", NewGame )
        , ( "Resume", GoToLevel level )
        ]


menuWithOutResume : Menu Msg
menuWithOutResume =
    Menu.init
        [ ( "New Game", NewGame ) ]
