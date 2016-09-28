module Menu exposing (Model, view, init)

import Html exposing (Html, button, div, text, br)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)


-- MODEL


type alias Model msg =
    { buttons : List ( String, msg ) }


init : List ( String, msg ) -> Model msg
init list =
    { buttons = list }



-- VIEW


view : Model msg -> Html msg
view model =
    List.map toButton model.buttons
        |> List.intersperse (br [] [])
        |> div [ class "menu-box" ]


toButton : ( String, msg ) -> Html msg
toButton ( label, msg ) =
    button [ class "menu-button", onClick msg ] [ text label ]
