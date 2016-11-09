module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.App
import Html.CssHelpers exposing (withNamespace)
import Time exposing (..)
import Exts.Float exposing (roundTo)
import Styles exposing (..)


{ id, class, classList } =
    withNamespace ""



-- Model


type alias Model =
    { time : Float
    , income : Float
    , rate : Float
    , hasStarted : Bool
    , hasPaused : Bool
    , hasStopped : Bool
    }


initialModel : Model
initialModel =
    { time = 0
    , income = 0
    , rate = 750
    , hasStarted = False
    , hasPaused = False
    , hasStopped = True
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )



-- Messages


type Msg
    = UpdateStopwatch Time
    | Start
    | Pause
    | Stop
    | NoOp



-- View


view : Model -> Html Msg
view model =
    main' []
        [ headerView
        , stopwatchView model
        ]


headerView : Html Msg
headerView =
    header [ class [ Header ] ]
        [ h1 [ style [ ( "z-index", "1030" ) ] ] [ text "Horofree" ] ]


stopwatchView : Model -> Html Msg
stopwatchView model =
    div []
        [ div [ class [ Styles.Stopwatch ] ] [ text (toStopwatch model.time) ]
        , div [ class [ Income ] ] [ text (toString (roundTo 2 model.income)) ]
        , div [ class [ BtnContainer ] ]
            [ button
                [ class [ BtnControl ]
                , onClick Start
                , disabled model.hasStarted
                ]
                [ i [ class [ "fa", "fa-play" ] ] [] ]
            , button
                [ class [ BtnControl ]
                , onClick Pause
                , disabled (model.hasPaused || not model.hasStarted)
                ]
                [ i [ class [ "fa", "fa-pause" ] ] [] ]
            , button
                [ class [ BtnControl ]
                , onClick Stop
                , disabled model.hasStopped
                ]
                [ i [ class [ "fa", "fa-stop" ] ] [] ]
            ]
        ]



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateStopwatch time ->
            let
                newTime =
                    model.time + 1

                newIncome =
                    updateIncome model.rate newTime 7
            in
                ( { model | time = newTime, income = newIncome }, Cmd.none )

        Start ->
            ( { model
                | hasStarted = True
                , hasPaused = False
                , hasStopped = False
              }
            , Cmd.none
            )

        Pause ->
            ( { model
                | hasStarted = False
                , hasPaused = True
                , hasStopped = False
              }
            , Cmd.none
            )

        Stop ->
            ( { model
                | time = 0
                , income = 0
                , hasStarted = False
                , hasPaused = False
                , hasStopped = True
              }
            , Cmd.none
            )

        NoOp ->
            ( model, Cmd.none )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.hasStarted && not model.hasStopped then
        every second UpdateStopwatch
    else
        Sub.none



-- Functions


updateIncome : Float -> Float -> Float -> Float
updateIncome rate time nbHours =
    (rate / nbHours) / 3600 * time


toStopwatch : Float -> String
toStopwatch time =
    let
        seconds =
            if time < 60 then
                round time
            else
                (round time) % 60

        minutes =
            (floor (time / 60)) % 60

        hours =
            floor (time / 3600)

        toStrSeconds =
            if seconds < 10 then
                "0" ++ toString seconds
            else
                toString seconds

        toStrMinutes =
            if minutes < 10 then
                "0" ++ toString minutes
            else
                toString minutes

        toStrHours =
            toString hours
    in
        toStrHours ++ "h" ++ toStrMinutes ++ "m" ++ toStrSeconds ++ "s"



-- Main


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
