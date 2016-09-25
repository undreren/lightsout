module Board exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Light
import Table exposing (Table)
import Helpers exposing (transpose, zip, allIndices)
import Random exposing (Generator, andThen)


-- MODEL


type alias Model =
    { cols : Int
    , rows : Int
    , moves : Int
    , lights : Table Light.Model
    }


init : Int -> Int -> Model
init cols rows =
    { cols = cols
    , rows = rows
    , moves = 0
    , lights = Table.initialize cols rows (Light.init Light.Off)
    }



-- UPDATE


type Msg
    = Click Bool ( Int, Int )
    | ResetMoves
    | BatchClick (List ( Int, Int ))


update : Msg -> Model -> Model
update msg model =
    case msg of
        Click userClick ( c, r ) ->
            { model
                | moves =
                    if userClick then
                        model.moves + 1
                    else
                        model.moves
            }
                |> switchLight ( c, r )
                |> switchLight ( c + 1, r )
                |> switchLight ( c - 1, r )
                |> switchLight ( c, r + 1 )
                |> switchLight ( c, r - 1 )

        ResetMoves ->
            { model | moves = 0 }

        BatchClick indices ->
            List.foldl (\idx m -> update (Click False idx) m) model indices


switchLight : ( Int, Int ) -> Model -> Model
switchLight ( c, r ) model =
    { model | lights = Table.modify ( c, r ) (Light.update Light.Switch) model.lights }



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "board" ] <|
        List.indexedMap viewRow <|
            transpose <|
                Table.toList model.lights


viewRow : Int -> List Light.Model -> Html Msg
viewRow r lights =
    div [ class "light-row" ] <|
        List.indexedMap (flip viewSingleLight r) lights


viewSingleLight : Int -> Int -> Light.Model -> Html Msg
viewSingleLight c r light =
    Light.view (Click True ( c, r )) light



-- RANDOM


chance : Float -> Generator Bool
chance pct =
    Random.map ((<=) pct) <| Random.float 0 1


randomizeBoard : Int -> Int -> Float -> Cmd Msg
randomizeBoard cols rows pct =
    Random.list (cols * rows) (chance pct)
        |> Random.map (\bs -> zip bs (allIndices cols rows))
        |> Random.map (List.filter fst)
        |> Random.map (List.map snd)
        |> Random.generate BatchClick
