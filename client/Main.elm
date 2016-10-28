module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.App
import Html.CssHelpers exposing (withNamespace)
import String exposing (..)
import Time exposing (..)
import Json.Decode as Json
import Exts.Float exposing (roundTo)
import Styles exposing (..)


{ id, class, classList } =
    withNamespace ""



-- Model


type alias Model =
    { time : Float
    , rate : Float
    , rateType : RateType
    , income : Float
    , currency : String
    , nbHours : Float
    , hasStarted : Bool
    , hasPaused : Bool
    , hasStopped : Bool
    }


type RateType
    = PerHours
    | PerDays


initialModel : Model
initialModel =
    { time = 0
    , rate = 0
    , rateType = PerDays
    , income = 0
    , currency = "€"
    , nbHours = 7
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
    | UpdateRate String
    | UpdateRateType RateType
    | UpdateCurrency String
    | UpdateNbHours String
    | Start
    | Pause
    | Stop
    | NoOp



-- View


view : Model -> Html Msg
view model =
    main' []
        [ header [ class [ Header ] ] [ h1 [] [ text "Horofree" ] ]
        , div [ class [ Setup ] ]
            [ div []
                [ input [ class [ InputText ], type' "text", onInput UpdateRate, placeholder "Your daily/hourly rate" ] []
                , selectCurrency model
                ]
            , div []
                [ input [ class [ InputText ], type' "text", onInput UpdateNbHours, value (toString model.nbHours), placeholder "Number of hours per day" ] []
                , span [ class [ SpanInput ] ] [ text "H" ]
                ]
            , div []
                [ radio "Per days" PerDays (UpdateRateType PerDays) model
                , radio "Per hours" PerHours (UpdateRateType PerHours) model
                ]
            ]
        , div [ class [ Stopwatch ] ] [ text (toStopwatch model.time) ]
        , div [ class [ Income ] ] [ text ((toString (roundTo 2 (model.income))) ++ model.currency) ]
        , div [ class [ BtnContainer ] ]
            [ button [ class [ "btn", "btn-outline", "mx1" ], onClick Start, disabled (model.rate == 0 || model.hasStarted) ] [ i [ class [ "fa", "fa-play" ] ] [] ]
            , button [ class [ "btn", "btn-outline", "mx1" ], onClick Pause, disabled (model.rate == 0 || model.hasPaused || not model.hasStarted) ] [ i [ class [ "fa", "fa-pause" ] ] [] ]
            , button [ class [ "btn", "btn-outline", "mx1" ], onClick Stop, disabled (model.rate == 0 || model.hasStopped) ] [ i [ class [ "fa", "fa-stop" ] ] [] ]
            ]
        ]


radio : String -> RateType -> msg -> Model -> Html msg
radio value rateType msg model =
    label []
        [ input [ type' "radio", name "rate-type", onClick msg, checked (model.rateType == rateType) ] []
        , text value
        ]


currencies : List String
currencies =
    [ "€", "$", "£", "¥", "฿" ]


selectCurrency : Model -> Html Msg
selectCurrency model =
    select [ class [ SpanInput ], on "change" (Json.map UpdateCurrency targetValue) ]
        (List.map (currencyItem model) currencies)


currencyItem : Model -> String -> Html msg
currencyItem model currency =
    option [ selected (model.currency == currency), value currency ] [ text currency ]



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateStopwatch time ->
            ( { model
                | time = model.time + 1
                , income = updateIncome model.rate model.time model.nbHours model.rateType
              }
            , Cmd.none
            )

        UpdateRate newValue ->
            ( { model
                | rate = String.toFloat newValue |> Result.toMaybe |> Maybe.withDefault 0
                , time = 0
                , income = 0
              }
            , Cmd.none
            )

        UpdateRateType newRateType ->
            ( { model | rateType = newRateType }, Cmd.none )

        UpdateCurrency newCurrency ->
            ( { model | currency = newCurrency }, Cmd.none )

        UpdateNbHours newValue ->
            ( { model
                | nbHours = String.toFloat newValue |> Result.toMaybe |> Maybe.withDefault 0
                , time = 0
                , income = 0
              }
            , Cmd.none
            )

        Start ->
            if model.rate /= 0 then
                ( { model
                    | hasStarted = True
                    , hasPaused = False
                    , hasStopped = False
                  }
                , Cmd.none
                )
            else
                ( model, Cmd.none )

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


updateIncome : Float -> Float -> Float -> RateType -> Float
updateIncome rate time nbHours rateType =
    if rateType == PerDays then
        (rate / nbHours) / 3600 * time
    else
        rate / 3600 * time


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
