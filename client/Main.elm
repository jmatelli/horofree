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
      , income : Float
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
    , setupOpened : Bool
    , rate : Float
    , rateType : RateType
    , currency : String
    , nbHours : Float
    }


initialStopwatch : Stopwatch
initialStopwatch =
    ( 1
    , { time = 0
      , income = 0
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
    , setupOpened = False
    , rate = 0
    , rateType = PerDays
    , currency = "€"
    , nbHours = 7
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
    | OpenSetup
    | CloseSetup
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

        closeSetupBtnClass =
            if model.setupOpened then
                [ Styles.CloseSetup ]
            else
                [ Styles.CloseSetup, Hidden ]

        openSetupBtnClass =
            if not model.setupOpened then
                [ Styles.OpenSetup ]
            else
                [ Styles.OpenSetup, Hidden ]
    in
        main' []
            [ header [ class [ Header ] ]
                [ a [ class [ AddLink ], style [ ( "z-index", "1000" ) ], onClick AddStopwatch ] [ i [ class [ "fa", "fa-plus" ] ] [] ]
                , a [ class closeBtnClass, onClick CloseList ] [ i [ class [ "fa", "fa-times" ] ] [] ]
                , a [ class openBtnClass, onClick OpenList ] [ i [ class [ "fa", "fa-arrow-right" ] ] [] ]
                , h1 [] [ text "Horofree" ]
                , a [ class closeSetupBtnClass, style [ ( "z-index", "1020" ) ], onClick CloseSetup ] [ i [ class [ "fa", "fa-times" ] ] [] ]
                , a [ class openSetupBtnClass, onClick OpenSetup ] [ i [ class [ "fa", "fa-gear" ] ] [] ]
                ]
            , listStopwatchesView model
            , stopwatchView model model.stopwatch
            , setupView model
            ]


listStopwatchesView : Model -> Html Msg
listStopwatchesView model =
    let
        listClass =
            if model.listOpened then
                [ ListStopwatches, ListOpened ]
            else
                [ ListStopwatches, ListClosed ]
    in
        div [ class listClass ]
            (List.map (listItem model) model.stopwatches)


listItem : Model -> Stopwatch -> Html Msg
listItem model stopwatch =
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
                    , text ((toString (roundTo 2 (sw.income))) ++ model.currency)
                    ]
                ]
            , a
                [ class [ Styles.RemoveStopwatch ]
                , onClick (RemoveStopwatch id)
                ]
                [ i [ class [ "fa", "fa-times" ], style [ ( "width", "100%" ) ] ] [] ]
            ]


setupView : Model -> Html Msg
setupView model =
    let
        setupClass =
            if model.setupOpened then
                [ Setup ]
            else
                [ Setup, Hidden ]
    in
        div [ class setupClass, style [ ( "z-index", "1010" ) ] ]
            [ div [ class [ SetupContainer ] ]
                [ div []
                    [ label [ class [ LabelSetup ] ] [ text "Your daily/hourly rate" ]
                    , div []
                        [ input [ class [ InputText ], type' "text", onInput UpdateRate ] []
                        , selectCurrency model
                        ]
                    ]
                , div []
                    [ label [ class [ LabelSetup ] ] [ text "Number of hours per day" ]
                    , div []
                        [ input [ class [ InputText, InputHours ], type' "text", onInput UpdateNbHours, value (toString model.nbHours), placeholder "Number of hours per day" ] []
                        ]
                    ]
                , div []
                    [ radio "Per days" PerDays (UpdateRateType PerDays) model
                    , radio "Per hours" PerHours (UpdateRateType PerHours) model
                    ]
                ]
            ]


radio : String -> RateType -> msg -> Model -> Html msg
radio value rateType msg model =
    let
        labelClass =
            if model.rateType == rateType then
                [ Styles.RateType, RateTypeSelected ]
            else
                [ Styles.RateType ]
    in
        label [ class labelClass ]
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


stopwatchView : Model -> Stopwatch -> Html Msg
stopwatchView model stopwatch =
    let
        ( id, sw ) =
            stopwatch
    in
        div []
            [ div [ class [ Styles.Stopwatch ] ] [ text (toStopwatch sw.time) ]
            , div [ class [ Income ] ] [ text ((toString (roundTo 2 (sw.income))) ++ model.currency) ]
            , div [ class [ BtnContainer ] ]
                [ button
                    [ class [ "btn", "btn-outline", "mx1" ]
                    , onClick Start
                    , disabled (model.rate == 0 || sw.hasStarted)
                    ]
                    [ i [ class [ "fa", "fa-play" ] ] [] ]
                , button
                    [ class [ "btn", "btn-outline", "mx1" ]
                    , onClick Pause
                    , disabled (model.rate == 0 || sw.hasPaused || not sw.hasStarted)
                    ]
                    [ i [ class [ "fa", "fa-pause" ] ] [] ]
                , button
                    [ class [ "btn", "btn-outline", "mx1" ]
                    , onClick Stop
                    , disabled (model.rate == 0 || sw.hasStopped)
                    ]
                    [ i [ class [ "fa", "fa-stop" ] ] [] ]
                ]
            ]



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

        OpenSetup ->
            ( { model | setupOpened = True }, Cmd.none )

        CloseSetup ->
            ( { model | setupOpened = False }, Cmd.none )

        UpdateStopwatch time ->
            let
                ( id, oldStopwatch ) =
                    model.stopwatch

                newStopwatch =
                    { oldStopwatch
                        | time = oldStopwatch.time + 1
                        , income = updateIncome model.rate oldStopwatch.time model.nbHours model.rateType
                    }
            in
                ( { model | stopwatch = ( id, newStopwatch ) }, Cmd.none )

        UpdateRate newRate ->
            let
                ( id, oldStopwatch ) =
                    model.stopwatch

                newStopwatch =
                    { oldStopwatch
                        | time = 0
                        , income = 0
                    }
            in
                ( { model
                    | rate = String.toFloat newRate |> Result.toMaybe |> Maybe.withDefault 0
                    , stopwatch = ( id, newStopwatch )
                  }
                , Cmd.none
                )

        UpdateRateType newRateType ->
            ( { model | rateType = newRateType }, Cmd.none )

        UpdateCurrency newCurrency ->
            ( { model | currency = newCurrency }, Cmd.none )

        UpdateNbHours newHours ->
            let
                ( id, oldStopwatch ) =
                    model.stopwatch

                newStopwatch =
                    { oldStopwatch
                        | time = 0
                        , income = 0
                    }
            in
                ( { model
                    | nbHours = String.toFloat newHours |> Result.toMaybe |> Maybe.withDefault 0
                    , stopwatch = ( id, newStopwatch )
                  }
                , Cmd.none
                )

        Start ->
            let
                ( id, oldStopwatch ) =
                    model.stopwatch

                rate =
                    model.rate

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
