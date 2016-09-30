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
        { level : Maybe Level
        , currentView : View
        , seed : Seed
        }


init : ( Model, Cmd Msg )
init =
    Model
        { level = Nothing
        , seed = initialSeed 0
        , currentView = mainMenuView
        }
        ! [ int minInt maxInt
                |> generate (SetSeed << initialSeed)
          ]



--UPDATE


type Msg
    = LevelMsg Level.Msg
    | SwitchView View
    | Tick Time
    | NewGame
    | GoToMenu
    | GoToLevel Level
    | SetSeed Seed


update : Msg -> Model -> Model
update msg (Model model) =
    case msg of
        LevelMsg lMsg ->
            case model.level of
                Nothing ->
                    Model model

                Just level ->
                    let
                        newLevel =
                            Level.update lMsg level
                    in
                        Model
                            { model
                                | level = Just newLevel
                                , currentView = gameView newLevel
                            }

        Tick t ->
            if Maybe.withDefault True <| Maybe.map (.paused) model.level then
                Model model
            else
                update (LevelMsg <| Level.Tick t) (Model model)

        SwitchView newView ->
            Model { model | currentView = newView }

        SetSeed seed ->
            Model { model | seed = seed }

        GoToMenu ->
            Model
                { model
                    | level = Maybe.map (Level.update (Level.Paused True)) model.level
                    , currentView = mainMenuView
                }

        GoToLevel level ->
            Model
                { model
                    | level = Just <| Level.update (Level.Paused False) level
                    , currentView = gameView level
                }

        NewGame ->
            let
                newLevel =
                    Level.init 7 7 0
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
        , button [ onClick GoToMenu ] [ text "Main Menu" ]
        , App.map LevelMsg (Level.view level)
        , br [] []
        , text <| "Moves: " ++ toString (List.length level.history)
        , br [] []
        , text <| "Time: " ++ toString (floor << Time.inSeconds <| level.elapsedTime)
        ]


mainMenuView : Model -> Html Msg
mainMenuView model =
    div [ class "game-box" ]
        [ h1 [] [ text "Lights Out" ]
        , generateMenu model
        ]


generateMenu : Model -> Html Msg
generateMenu (Model model) =
    case model.level of
        Just level ->
            menuWithResume level (Model model)

        Nothing ->
            menuWithOutResume (Model model)


menuWithResume : Level -> Model -> Html Msg
menuWithResume level (Model model) =
    Menu.view <|
        Menu.init
            [ ( "New Game", NewGame )
            , ( "Resume", GoToLevel level )
            ]


menuWithOutResume : Model -> Html Msg
menuWithOutResume _ =
    Menu.view <|
        Menu.init
            [ ( "New Game", NewGame ) ]
