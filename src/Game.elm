module Game exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.App as App
import Board
import Time exposing (Time)
import Task


--MODEL


type alias Model =
    { board : Board.Model
    , startTime : Time
    , elapsedTime : Time
    }


init : ( Model, Cmd Msg )
init =
    ( { board = Board.init 10 10
      , startTime = 0
      , elapsedTime = 0
      }
    , Cmd.batch
        [ Task.perform SetStartTime SetStartTime Time.now
        , Cmd.map (BoardMsg) (Board.randomizeBoard 10 10 0.15)
        ]
    )



--UPDATE


type Msg
    = BoardMsg Board.Msg
    | Tick Time
    | SetStartTime Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        BoardMsg bMsg ->
            { model | board = Board.update bMsg model.board } ! []

        Tick t ->
            ( { model | elapsedTime = t - model.startTime }
            , Cmd.none
            )

        SetStartTime t ->
            ( { model | startTime = t }, Cmd.none )



--SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every (10 * Time.millisecond) Tick



--VIEW


view : Model -> Html Msg
view model =
    div [ class "game-box" ]
        [ h1 [] [ text "Lights Out" ]
        , App.map BoardMsg (Board.view model.board)
        , br [] []
        , text <| "Moves: " ++ toString model.board.moves
        , br [] []
        , text <| "Time: " ++ toString (floor << Time.inSeconds <| model.elapsedTime)
        ]
