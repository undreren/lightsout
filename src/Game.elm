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
    , moves : Int
    , startTime : Time
    , elapsedTime : Time
    }


init : ( Model, Cmd Msg )
init =
    ( { board = Board.init 10 10
      , moves = 0
      , startTime = 0
      , elapsedTime = 0
      }
    , Task.perform SetStartTime SetStartTime Time.now
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
            ( { model
                | board = Board.update bMsg model.board
                , moves = model.moves + 1
              }
            , Cmd.none
            )

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
        , text <| "Moves: " ++ toString model.moves
        , br [] []
        , text <| "Time: " ++ toString (Time.inSeconds model.elapsedTime)
        ]
