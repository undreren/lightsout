module Game exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import Html.App as App
import Board
import Time exposing (Time)
import Task


--MODEL


type alias Model =
    { board : Board.Model
    , memo : Board.Model
    , startTime : Time
    , elapsedTime : Time
    }


init : ( Model, Cmd Msg )
init =
    let
        board =
            Board.init 10 10
    in
        ( { board = board
          , memo = board
          , startTime = 0
          , elapsedTime = 0
          }
        , Cmd.batch
            [ Task.perform SetStartTime SetStartTime Time.now
            , Task.perform identity identity (Task.succeed NewBoard)
            ]
        )



--UPDATE


type Msg
    = BoardMsg Board.Msg
    | NewBoard
    | MemoBoard
    | RevertBoard
    | Tick Time
    | AndThen Msg Msg
    | SetStartTime Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        BoardMsg bMsg ->
            { model | board = Board.update bMsg model.board } ! []

        Tick t ->
            { model | elapsedTime = t - model.startTime } ! []

        SetStartTime t ->
            { model | startTime = t } ! []

        NewBoard ->
            model
                ! [ Cmd.map (\msg -> AndThen (BoardMsg msg) MemoBoard)
                        (Board.randomizeBoard 10 10 0.15)
                  ]

        RevertBoard ->
            { model | board = Board.update Board.ResetMoves model.memo }
                ! [ Task.perform SetStartTime SetStartTime Time.now ]

        MemoBoard ->
            { model | memo = model.board } ! []

        AndThen msg1 msg2 ->
            let
                ( model', cmd1 ) =
                    update msg1 model

                ( model'', cmd2 ) =
                    update msg2 model'
            in
                model'' ! [ cmd1, cmd2 ]



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
        , br [] []
        , button [ onClick RevertBoard ] [ text "Retry" ]
        , button [ onClick NewBoard ] [ text "New" ]
        ]
