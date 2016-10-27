module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.App
import String exposing (..)
import Time exposing (..)
import Json.Decode as Json


-- Model


type alias Model =
    { time : Float
    , rate : Float
    , rateType : RateType
    , money : Float
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
    , money = 0
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


mainStyle : Attribute msg
mainStyle =
    style
        [ ( "height", "100%" )
        , ( "background", "#f5f5f5" )
        , ( "padding-top", "150px" )
        ]


headerStyle : Attribute msg
headerStyle =
    style
        [ ( "background", "#353535" )
        , ( "border-bottom", "1px solid black" )
        , ( "margin", "0 0 20px" )
        , ( "padding", "20px" )
        , ( "color", "white" )
        ]


h1Style : Attribute msg
h1Style =
    style
        [ ( "margin", "0" )
        , ( "text-align", "center" )
        ]


formStyle : Attribute msg
formStyle =
    style
        [ ( "text-align", "center" )
        ]


inputBlockStyle : Attribute msg
inputBlockStyle =
    style
        [ ( "margin-bottom", "20px" ) ]


inputStyle : Attribute msg
inputStyle =
    style
        [ ( "padding", "10px 20px" )
        , ( "border-radius", "0" )
        , ( "border", "1px solid grey" )
        , ( "line-height", "50px" )
        , ( "height", "52px" )
        ]


spanInputStyle : Attribute msg
spanInputStyle =
    style
        [ ( "background", "lightgrey" )
        , ( "border", "1px solid grey" )
        , ( "border-left", "none" )
        , ( "font-weight", "bold" )
        , ( "line-height", "50px" )
        , ( "height", "52px" )
        , ( "width", "50px" )
        , ( "text-align", "center" )
        , ( "display", "inline-block" )
        ]


stopwatchStyle : Attribute msg
stopwatchStyle =
    style
        [ ( "font-size", "3rem" )
        , ( "font-weight", "bold" )
        , ( "text-align", "center" )
        , ( "margin", "50px 0" )
        ]


moneyStyle : Attribute msg
moneyStyle =
    style
        [ ( "font-size", "5rem" )
        , ( "background", "#DCDCDC" )
        , ( "margin", "50px 0" )
        , ( "font-weight", "bold" )
        , ( "color", "limegreen" )
        , ( "text-align", "center" )
        ]


btnContainerStyle : Attribute msg
btnContainerStyle =
    style
        [ ( "text-align", "center" )
        ]


view : Model -> Html Msg
view model =
    main' [ mainStyle ]
        [ header [ headerStyle, class "fixed top-0 left-0 right-0" ] [ h1 [ h1Style ] [ text "Horofree" ] ]
        , div [ formStyle ]
            [ div [ inputBlockStyle ]
                [ input [ inputStyle, type' "text", onInput UpdateRate, placeholder "Your daily/hourly rate" ] []
                  -- , span [ spanInputStyle ] [ text "€" ]
                , selectCurrency model
                ]
            , div [ inputBlockStyle ]
                [ input [ inputStyle, type' "text", onInput UpdateNbHours, value (toString model.nbHours), placeholder "Number of hours per day" ] []
                , span [ spanInputStyle ] [ text "H" ]
                ]
            , div [ inputBlockStyle ]
                [ radio "Per days" PerDays (UpdateRateType PerDays) model
                , radio "Per hours" PerHours (UpdateRateType PerHours) model
                ]
            ]
        , div [ stopwatchStyle ] [ text (toStopwatch model.time) ]
        , div [ moneyStyle ] [ text ((toString model.money) ++ model.currency) ]
          -- , div [] [ text (toString model) ]
        , div [ btnContainerStyle ]
            [ button [ class "btn btn-outline mx1", onClick Start, disabled (model.rate == 0 || model.hasStarted) ] [ i [ class "fa fa-play" ] [] ]
            , button [ class "btn btn-outline mx1", onClick Pause, disabled (model.rate == 0 || model.hasPaused || not model.hasStarted) ] [ i [ class "fa fa-pause" ] [] ]
            , button [ class "btn btn-outline mx1", onClick Stop, disabled (model.rate == 0 || model.hasStopped) ] [ i [ class "fa fa-stop" ] [] ]
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
    select [ spanInputStyle, on "change" (Json.map UpdateCurrency targetValue) ]
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
                , money = updateMoney model.rate model.time model.nbHours model.rateType
              }
            , Cmd.none
            )

        UpdateRate newValue ->
            ( { model
                | rate = String.toFloat newValue |> Result.toMaybe |> Maybe.withDefault 0
                , time = 0
                , money = 0
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
                , money = 0
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
                , money = 0
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


updateMoney : Float -> Float -> Float -> RateType -> Float
updateMoney rate time nbHours rateType =
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
