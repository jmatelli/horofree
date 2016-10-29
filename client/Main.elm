module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.App
import Html.CssHelpers exposing (withNamespace)
import String exposing (..)
import Array exposing (..)
import Time exposing (..)
import Json.Decode as Json
import Exts.Float exposing (roundTo)
import Styles exposing (..)


{ id, class, classList } =
    withNamespace ""



-- Model


type alias Stopwatch =
    ( Int
    , { time : Float
      , rate : Float
      , rateType : RateType
      , income : Float
      , currency : String
      , nbHours : Float
      , hasStarted : Bool
      , hasPaused : Bool
      , hasStopped : Bool
      }
    )


type RateType
    = PerHours
    | PerDays


type alias Model =
    { stopwatch : Stopwatch
    , stopwatches : List Stopwatch
    , listOpened : Bool
    }


initialStopwatch : Stopwatch
initialStopwatch =
    ( 1
    , { time = 0
      , rate = 0
      , rateType = PerDays
      , income = 0
      , currency = "€"
      , nbHours = 7
      , hasStarted = False
      , hasPaused = False
      , hasStopped = True
      }
    )


initialModel : Model
initialModel =
    { stopwatch = initialStopwatch
    , stopwatches = [ initialStopwatch ]
    , listOpened = False
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )



-- Messages


type Msg
    = AddStopwatch
    | RemoveStopwatch Int
    | ChangeStopwatch
    | OpenList
    | CloseList
    | UpdateStopwatch Time
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
    let
        closeBtnClass =
            if model.listOpened then
                [ Styles.CloseList ]
            else
                [ Styles.CloseList, Hidden ]

        openBtnClass =
            if not model.listOpened then
                [ Styles.OpenList ]
            else
                [ Styles.OpenList, Hidden ]
    in
        main' []
            [ header [ class [ Header ] ]
                [ a [ class [ AddLink ], style [ ( "z-index", "1000" ) ], onClick AddStopwatch ] [ i [ class [ "fa", "fa-plus" ] ] [] ]
                , a [ class closeBtnClass, onClick CloseList ] [ i [ class [ "fa", "fa-times" ] ] [] ]
                , a [ class openBtnClass, onClick OpenList ] [ i [ class [ "fa", "fa-arrow-right" ] ] [] ]
                , h1 [] [ text "Horofree" ]
                ]
            , listStopwatchesView model.stopwatches model.listOpened
            , stopwatchView model.stopwatch
            ]


listStopwatchesView : List Stopwatch -> Bool -> Html Msg
listStopwatchesView stopwatches isOpen =
    let
        listClass =
            if isOpen then
                [ ListStopwatches, ListOpened ]
            else
                [ ListStopwatches, ListClosed ]
    in
        div [ class listClass ]
            (List.map listItem stopwatches)


listItem : Stopwatch -> Html Msg
listItem stopwatch =
    let
        ( id, sw ) =
            stopwatch
    in
        div [ class [ ListItem ] ]
            [ a [ class [ ListItemDetails ] ]
                [ span [] [ text ((toString id) ++ ".") ]
                , span []
                    [ text (toStopwatch sw.time)
                    , br [] []
                    , text ((toString (roundTo 2 (sw.income))) ++ sw.currency)
                    ]
                ]
            , a
                [ class [ Styles.RemoveStopwatch ]
                , onClick (RemoveStopwatch id)
                ]
                [ i [ class [ "fa", "fa-times" ], style [ ( "width", "100%" ) ] ] [] ]
            ]


stopwatchView : Stopwatch -> Html Msg
stopwatchView stopwatch =
    let
        ( id, sw ) =
            stopwatch
    in
        div []
            [ div [ class [ Setup ] ]
                [ div []
                    [ label [ class [ LabelSetup ] ] [ text "Your daily/hourly rate" ]
                    , div []
                        [ input [ class [ InputText ], type' "text", onInput UpdateRate ] []
                        , selectCurrency stopwatch
                        ]
                    ]
                , div []
                    [ label [ class [ LabelSetup ] ] [ text "Number of hours per day" ]
                    , div []
                        [ input [ class [ InputText, InputHours ], type' "text", onInput UpdateNbHours, value (toString sw.nbHours), placeholder "Number of hours per day" ] []
                        ]
                    ]
                , div []
                    [ radio "Per days" PerDays (UpdateRateType PerDays) stopwatch
                    , radio "Per hours" PerHours (UpdateRateType PerHours) stopwatch
                    ]
                ]
            , div [ class [ Styles.Stopwatch ] ] [ text (toStopwatch sw.time) ]
            , div [ class [ Income ] ] [ text ((toString (roundTo 2 (sw.income))) ++ sw.currency) ]
            , div [ class [ BtnContainer ] ]
                [ button
                    [ class [ "btn", "btn-outline", "mx1" ]
                    , onClick Start
                    , disabled (sw.rate == 0 || sw.hasStarted)
                    ]
                    [ i [ class [ "fa", "fa-play" ] ] [] ]
                , button
                    [ class [ "btn", "btn-outline", "mx1" ]
                    , onClick Pause
                    , disabled (sw.rate == 0 || sw.hasPaused || not sw.hasStarted)
                    ]
                    [ i [ class [ "fa", "fa-pause" ] ] [] ]
                , button
                    [ class [ "btn", "btn-outline", "mx1" ]
                    , onClick Stop
                    , disabled (sw.rate == 0 || sw.hasStopped)
                    ]
                    [ i [ class [ "fa", "fa-stop" ] ] [] ]
                ]
            ]


radio : String -> RateType -> msg -> Stopwatch -> Html msg
radio value rateType msg stopwatch =
    let
        ( id, sw ) =
            stopwatch

        labelClass =
            if sw.rateType == rateType then
                [ Styles.RateType, RateTypeSelected ]
            else
                [ Styles.RateType ]
    in
        label [ class labelClass ]
            [ input [ type' "radio", name "rate-type", onClick msg, checked (sw.rateType == rateType) ] []
            , text value
            ]


currencies : List String
currencies =
    [ "€", "$", "£", "¥", "฿" ]


selectCurrency : Stopwatch -> Html Msg
selectCurrency stopwatch =
    select [ class [ SpanInput ], on "change" (Json.map UpdateCurrency targetValue) ]
        (List.map (currencyItem stopwatch) currencies)


currencyItem : Stopwatch -> String -> Html msg
currencyItem stopwatch currency =
    let
        ( id, sw ) =
            stopwatch
    in
        option [ selected (sw.currency == currency), value currency ] [ text currency ]



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddStopwatch ->
            let
                ( id, oldStopwatch ) =
                    model.stopwatch

                newId =
                    id + 1
            in
                ( { model
                    | stopwatch = ( newId, oldStopwatch )
                    , stopwatches = List.append model.stopwatches [ ( newId, oldStopwatch ) ]
                    , listOpened = True
                  }
                , Cmd.none
                )

        RemoveStopwatch id ->
            let
                matchingId a x =
                    let
                        ( i, sw ) =
                            x
                    in
                        a /= i

                newList =
                    Array.filter (matchingId id) (Array.fromList model.stopwatches)
            in
                ( { model | stopwatches = Array.toList newList }, Cmd.none )

        ChangeStopwatch ->
            ( model, Cmd.none )

        OpenList ->
            ( { model | listOpened = True }, Cmd.none )

        CloseList ->
            ( { model | listOpened = False }, Cmd.none )

        UpdateStopwatch time ->
            let
                ( id, oldStopwatch ) =
                    model.stopwatch

                newStopwatch =
                    { oldStopwatch
                        | time = oldStopwatch.time + 1
                        , income = updateIncome oldStopwatch.rate oldStopwatch.time oldStopwatch.nbHours oldStopwatch.rateType
                    }
            in
                ( { model | stopwatch = ( id, newStopwatch ) }, Cmd.none )

        UpdateRate newValue ->
            let
                ( id, oldStopwatch ) =
                    model.stopwatch

                newStopwatch =
                    { oldStopwatch
                        | rate = String.toFloat newValue |> Result.toMaybe |> Maybe.withDefault 0
                        , time = 0
                        , income = 0
                    }
            in
                ( { model | stopwatch = ( id, newStopwatch ) }, Cmd.none )

        UpdateRateType newRateType ->
            let
                ( id, oldStopwatch ) =
                    model.stopwatch

                newStopwatch =
                    { oldStopwatch | rateType = newRateType }
            in
                ( { model | stopwatch = ( id, newStopwatch ) }, Cmd.none )

        UpdateCurrency newCurrency ->
            let
                ( id, oldStopwatch ) =
                    model.stopwatch

                newStopwatch =
                    { oldStopwatch | currency = newCurrency }
            in
                ( { model | stopwatch = ( id, newStopwatch ) }, Cmd.none )

        UpdateNbHours newValue ->
            let
                ( id, oldStopwatch ) =
                    model.stopwatch

                newStopwatch =
                    { oldStopwatch
                        | nbHours = String.toFloat newValue |> Result.toMaybe |> Maybe.withDefault 0
                        , time = 0
                        , income = 0
                    }
            in
                ( { model | stopwatch = ( id, newStopwatch ) }, Cmd.none )

        Start ->
            let
                ( id, oldStopwatch ) =
                    model.stopwatch

                rate =
                    oldStopwatch.rate

                newStopwatch =
                    { oldStopwatch
                        | hasStarted = True
                        , hasPaused = False
                        , hasStopped = False
                    }
            in
                if rate /= 0 then
                    ( { model | stopwatch = ( id, newStopwatch ) }, Cmd.none )
                else
                    ( model, Cmd.none )

        Pause ->
            let
                ( id, oldStopwatch ) =
                    model.stopwatch

                newStopwatch =
                    { oldStopwatch
                        | hasStarted = False
                        , hasPaused = True
                        , hasStopped = False
                    }
            in
                ( { model | stopwatch = ( id, newStopwatch ) }, Cmd.none )

        Stop ->
            let
                ( id, oldStopwatch ) =
                    model.stopwatch

                newStopwatch =
                    { oldStopwatch
                        | time = 0
                        , income = 0
                        , hasStarted = False
                        , hasPaused = False
                        , hasStopped = True
                    }
            in
                ( { model | stopwatch = ( id, newStopwatch ) }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        ( id, sw ) =
            model.stopwatch
    in
        if sw.hasStarted && not sw.hasStopped then
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
