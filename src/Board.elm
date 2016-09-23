module Board exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as App
import Light exposing (Msg(..))


--MODEL


type alias Model =
    { cols : Int
    , rows : Int
    , lights : List (List Light.Model)
    }


init : Int -> Int -> Model
init cols rows =
    { cols = cols
    , rows = rows
    , lights = List.repeat rows << List.repeat cols <| Light.init
    }



--UPDATE


type Msg
    = Click ( Int, Int )


update : Msg -> Model -> Model
update msg model =
    case msg of
        Click ( r, c ) ->
            { model | lights = click r c model.lights }


click : Int -> Int -> List (List Light.Model) -> List (List Light.Model)
click r c lights =
    flip List.indexedMap lights <|
        \r' row ->
            flip List.indexedMap row <|
                \c' light ->
                    if
                        ((r' == r) && (List.member c' [c - 1..c + 1]))
                            || ((c' == c) && (List.member r' [r - 1..r + 1]))
                    then
                        Light.update Switch light
                    else
                        light



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "board" ] <|
        List.indexedMap viewRow model.lights


viewRow : Int -> List Light.Model -> Html Msg
viewRow r lights =
    div [ class "light-row" ] <|
        List.indexedMap (viewSingleLight r) lights


viewSingleLight : Int -> Int -> Light.Model -> Html Msg
viewSingleLight r c light =
    App.map (\_ -> Click ( r, c )) (Light.view light)
