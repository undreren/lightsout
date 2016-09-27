module Level exposing (Model, init, Msg(..), update, view)

import Html exposing (Html, div, text, button, br)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import Html.App as App exposing (map)
import Time exposing (Time)
import Board


-- SYNONYMS


type alias Board =
    Board.Model



-- MODEL


type alias Model =
    { board : Board.Model
    , history : List Board.Model
    , future : List Board.Model
    , startTime : Time
    , elapsedTime : Time
    }


init : Int -> Int -> Time -> Model
init cols rows time =
    { board = Board.init cols rows
    , history = []
    , future = []
    , startTime = time
    , elapsedTime = 0
    }



-- UPDATE


type Msg
    = BoardMsg Board.Msg
    | Undo
    | Redo
    | Tick Time


update : Msg -> Model -> Model
update msg model =
    case msg of
        BoardMsg bMsg ->
            boardMsg bMsg model

        Undo ->
            undo model

        Redo ->
            redo model

        Tick t ->
            { model | elapsedTime = t - model.startTime }


undo : Model -> Model
undo model =
    case model.history of
        b :: bs ->
            { model
                | history = bs
                , board = b
                , future = model.board :: model.future
            }

        _ ->
            model


redo : Model -> Model
redo model =
    case model.future of
        b :: bs ->
            { model
                | history = model.board :: model.history
                , board = b
                , future = bs
            }

        _ ->
            model


boardMsg : Board.Msg -> Model -> Model
boardMsg msg model =
    case msg of
        Board.Click col row ->
            { model
                | board = Board.update msg model.board
                , history = model.board :: model.history
            }



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "level" ]
        [ App.map BoardMsg (Board.view model.board)
        , br [] []
        , button [ onClick Undo ] [ text "Undo" ]
        , button [ onClick Redo ] [ text "Redo" ]
        ]
