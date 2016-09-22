module Light exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


-- MODEL


type LightState
    = On
    | Off


switch : LightState -> LightState
switch state =
    case state of
        On ->
            Off

        Off ->
            On


type alias Model =
    { state : LightState }


init : Model
init =
    { state = Off }



-- UPDATE


type Msg
    = Switch
    | SetLightState LightState


update : Msg -> Model -> Model
update msg model =
    case msg of
        Switch ->
            { model | state = switch model.state }

        SetLightState state ->
            { model | state = state }



-- VIEW


view : Model -> Html Msg
view model =
    div [ lightClass model, onClick Switch ] []


lightClass : Model -> Attribute Msg
lightClass model =
    case model.state of
        On ->
            class "light-bulb on"

        Off ->
            class "light-bulb off"
