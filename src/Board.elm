module Board exposing (Model, init, Msg(..), update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Light exposing (Model, LightState(..))
import Table exposing (Table)
import Helpers exposing (transpose, zip, allIndices)


-- SYNONYMS


type alias Light =
    Light.Model



-- MODEL


type alias Model =
    { cols : Int
    , rows : Int
    , lights : Table Light
    }


init : Int -> Int -> Model
init cols rows =
    { cols = cols
    , rows = rows
    , lights = Table.initialize cols rows (Light.init Off)
    }



-- UPDATE


type Msg
    = Click Int Int


update : Msg -> Model -> Model
update msg model =
    case msg of
        Click c r ->
            model
                |> switchLight ( c, r )
                |> switchLight ( c + 1, r )
                |> switchLight ( c - 1, r )
                |> switchLight ( c, r + 1 )
                |> switchLight ( c, r - 1 )


switchLight : ( Int, Int ) -> Model -> Model
switchLight ( c, r ) model =
    { model
        | lights =
            Table.modify ( c, r ) (Light.update Light.Switch) model.lights
    }



-- VIEW


view : Model -> Html Msg
view model =
    model.lights
        |> Table.toList
        |> transpose
        |> List.indexedMap viewRow
        |> div [ class "board" ]


viewRow : Int -> List Light -> Html Msg
viewRow r =
    div []
        << List.indexedMap (flip viewSingleLight r)


viewSingleLight : Int -> Int -> Light -> Html Msg
viewSingleLight c r =
    Light.view (Click c r)
