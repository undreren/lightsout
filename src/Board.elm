module Board exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Light
import Table exposing (Table)
import Helpers exposing (transpose)


--MODEL


type alias Model =
    { cols : Int
    , rows : Int
    , lights : Table Light.Model
    }


init : Int -> Int -> Model
init cols rows =
    { cols = cols
    , rows = rows
    , lights = Table.initialize cols rows (Light.init Light.Off)
    }



--UPDATE


type Msg
    = Click ( Int, Int )


update : Msg -> Model -> Model
update msg model =
    case msg of
        Click ( c, r ) ->
            model
                |> switchLight ( c, r )
                |> switchLight ( c + 1, r )
                |> switchLight ( c - 1, r )
                |> switchLight ( c, r + 1 )
                |> switchLight ( c, r - 1 )


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
    Light.view (Click ( c, r )) light
