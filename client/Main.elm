module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.App
import Html.CssHelpers exposing (withNamespace)
import String exposing (..)
import Array exposing (..)
import Dict exposing (..)
import Regex exposing (..)
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


type alias Setup =
    { rate : Maybe Float
    , rateType : RateType
    , currency : String
    , nbHours : Maybe Float
    }


type alias Model =
    { stopwatch : Stopwatch
    , stopwatches : List Stopwatch
    , listOpened : Bool
    , setupOpened : Bool
    , setup : Setup
    , inputRate : String
    , inputHours : String
    , inputCurrency : String
    , inputRateType : RateType
    }


type RateType
    = PerHours
    | PerDays


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


initialSetup : Setup
initialSetup =
    { rate = Nothing
    , rateType = PerDays
    , currency = "€"
    , nbHours = Nothing
    }


initialModel : Model
initialModel =
    { stopwatch = initialStopwatch
    , stopwatches = []
    , listOpened = False
    , setupOpened = False
    , setup = initialSetup
    , inputRate = ""
    , inputHours = ""
    , inputCurrency = "€"
    , inputRateType = PerDays
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )



-- Messages


type Msg
    = AddStopwatch
    | RemoveStopwatch Int
    | ChangeStopwatch Int
    | OpenList
    | CloseList
    | OpenSetup
    | CloseSetup
    | InputRate String
    | InputCurrency String
    | InputRateType RateType
    | InputHours String
    | SaveSetup
    | CancelSetup
    | UpdateStopwatch Time
    | Start
    | Pause
    | Stop
    | SaveStopwatch
    | NoOp



-- View


view : Model -> Html Msg
view model =
    main' []
        [ headerView model
        , listStopwatchesView model
        , stopwatchView model
        , setupView model
        ]


headerView : Model -> Html Msg
headerView model =
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
        header [ class [ Header ] ]
            [ a
                [ class [ AddLink ]
                , style [ ( "z-index", "1000" ) ]
                , onClick AddStopwatch
                ]
                [ i [ class [ "fa", "fa-plus" ] ] [] ]
            , a
                [ class closeBtnClass
                , onClick CloseList
                ]
                [ i [ class [ "fa", "fa-times" ] ] [] ]
            , a
                [ class openBtnClass
                , onClick OpenList
                ]
                [ i [ class [ "fa", "fa-chevron-right" ] ] [] ]
            , h1 [ style [ ( "z-index", "1030" ) ] ] [ text "Horofree" ]
            , a
                [ class closeSetupBtnClass
                , style [ ( "z-index", "1020" ) ]
                , onClick CloseSetup
                ]
                [ i [ class [ "fa", "fa-times" ] ] [] ]
            , a
                [ class openSetupBtnClass
                , onClick OpenSetup
                ]
                [ i [ class [ "fa", "fa-gear" ] ] [] ]
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
        model.stopwatches
            |> List.sortBy (\( n, s ) -> n)
            |> List.map (listItem model)
            |> div [ class listClass ]


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
                    , text ((toString (roundTo 2 (sw.income))) ++ model.setup.currency)
                    ]
                ]
            , div
                [ class [ Styles.RemoveStopwatch ]
                ]
                [ a [ onClick (RemoveStopwatch id) ]
                    [ i [ class [ "fa", "fa-times" ] ] [] ]
                , a [ onClick (ChangeStopwatch id) ]
                    [ i [ class [ "fa", "fa-chevron-right" ] ] [] ]
                ]
            ]


setupView : Model -> Html Msg
setupView model =
    let
        setupClass =
            if model.setupOpened then
                [ Styles.Setup ]
            else
                [ Styles.Setup, Hidden ]

        inputHoursClass =
            if model.inputRateType == PerHours then
                [ Hidden ]
            else
                []
    in
        div [ class setupClass, style [ ( "z-index", "1010" ) ] ]
            [ Html.form [ class [ SetupContainer ], onSubmit SaveSetup ]
                [ h2 [] [ text "Setup" ]
                , div []
                    [ label [ class [ LabelSetup ] ] [ text "Your daily/hourly rate" ]
                    , div []
                        [ input
                            [ class [ InputText ]
                            , type' "text"
                            , onInput InputRate
                            , value model.inputRate
                            ]
                            []
                        , selectCurrency model
                        ]
                    ]
                , div [ class inputHoursClass ]
                    [ label [ class [ LabelSetup ] ] [ text "Number of hours per day" ]
                    , div []
                        [ input
                            [ class [ InputText, Styles.InputHours ]
                            , type' "text"
                            , onInput InputHours
                            , value model.inputHours
                            ]
                            []
                        ]
                    ]
                , div []
                    [ radio "Per days" PerDays (InputRateType PerDays) model
                    , radio "Per hours" PerHours (InputRateType PerHours) model
                    ]
                , div []
                    [ button [ class [ Styles.SaveSetup ], type' "submit" ] [ text "Save" ]
                    , button [ class [ Styles.CancelSetup ], onClick CancelSetup ] [ text "Cancel" ]
                    ]
                ]
            ]


radio : String -> RateType -> msg -> Model -> Html msg
radio value rateType msg model =
    let
        labelClass =
            if model.inputRateType == rateType then
                [ Styles.RateType, RateTypeSelected ]
            else
                [ Styles.RateType ]
    in
        label [ class labelClass ]
            [ input [ type' "radio", name "rate-type", onClick msg, checked (model.inputRateType == rateType) ] []
            , text value
            ]


currencies : List String
currencies =
    [ "€", "$", "£", "¥" ]


selectCurrency : Model -> Html Msg
selectCurrency model =
    select [ class [ SpanInput ], on "change" (Json.map InputCurrency targetValue) ]
        (List.map (currencyItem model) currencies)


currencyItem : Model -> String -> Html msg
currencyItem model currency =
    option [ selected (model.inputCurrency == currency), value currency ] [ text currency ]


stopwatchView : Model -> Html Msg
stopwatchView model =
    let
        ( id, sw ) =
            model.stopwatch
    in
        div []
            [ div [ class [ Styles.Stopwatch ] ] [ text (toStopwatch sw.time) ]
            , div [ class [ Income ] ] [ text (formatCurrency (roundTo 2 (sw.income)) model) ]
            , div [ class [ BtnContainer ] ]
                [ button
                    [ class [ BtnControl ]
                    , onClick Start
                    , disabled (model.setup.rate == Nothing || sw.hasStarted)
                    ]
                    [ i [ class [ "fa", "fa-play" ] ] [] ]
                , button
                    [ class [ BtnControl ]
                    , onClick Pause
                    , disabled (model.setup.rate == Nothing || sw.hasPaused || not sw.hasStarted)
                    ]
                    [ i [ class [ "fa", "fa-pause" ] ] [] ]
                , button
                    [ class [ BtnControl ]
                    , onClick Stop
                    , disabled (model.setup.rate == Nothing || sw.hasStopped)
                    ]
                    [ i [ class [ "fa", "fa-stop" ] ] [] ]
                ]
            , div [ class [ BtnContainer ] ]
                [ button
                    [ class [ BtnSave ]
                    , onClick SaveStopwatch
                    , disabled (not sw.hasPaused || sw.time == 0)
                    ]
                    [ text "save" ]
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

                ( initId, initSw ) =
                    initialStopwatch
            in
                ( { model
                    | stopwatch = ( newId, initSw )
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
                    List.filter (matchingId id) model.stopwatches
            in
                ( { model | stopwatches = newList }, Cmd.none )

        ChangeStopwatch id ->
            let
                ( initId, initSw ) =
                    initialStopwatch

                matchingId a x =
                    let
                        ( i, sw ) =
                            x
                    in
                        a == i

                newSw =
                    model.stopwatches
                        |> List.filter (matchingId id)
                        |> Array.fromList
                        |> Array.get 0
                        |> Maybe.withDefault ( 0, initSw )
            in
                ( { model | stopwatch = newSw }, Cmd.none )

        OpenList ->
            ( { model | listOpened = True }, Cmd.none )

        CloseList ->
            ( { model | listOpened = False }, Cmd.none )

        OpenSetup ->
            ( { model | setupOpened = True }, Cmd.none )

        CloseSetup ->
            ( { model | setupOpened = False }, Cmd.none )

        InputRate rate ->
            ( { model | inputRate = rate }, Cmd.none )

        InputCurrency currency ->
            ( { model | inputCurrency = currency }, Cmd.none )

        InputRateType rateType ->
            ( { model | inputRateType = rateType }, Cmd.none )

        InputHours hours ->
            ( { model | inputHours = hours }, Cmd.none )

        SaveSetup ->
            let
                oldSetup =
                    model.setup

                inputRate =
                    case String.toFloat model.inputRate of
                        Ok value ->
                            if value == 0 then
                                Nothing
                            else
                                Just value

                        Err err ->
                            Nothing

                inputHours =
                    case String.toFloat model.inputHours of
                        Ok value ->
                            if value == 0 || model.inputRateType == PerHours then
                                Nothing
                            else
                                Just value

                        Err err ->
                            Nothing

                newSetup =
                    { oldSetup | rate = inputRate, currency = model.inputCurrency, rateType = model.inputRateType, nbHours = inputHours }
            in
                ( { model | setup = newSetup, setupOpened = False }, Cmd.none )

        CancelSetup ->
            ( { model | inputRate = "", inputCurrency = "€", inputRateType = PerDays, inputHours = "" }, Cmd.none )

        UpdateStopwatch time ->
            let
                ( id, oldStopwatch ) =
                    model.stopwatch

                newTime =
                    oldStopwatch.time + 1

                newIncome =
                    updateIncome model.setup.rate newTime model.setup.nbHours model.setup.rateType

                newStopwatch =
                    { oldStopwatch
                        | time = newTime
                        , income = newIncome
                    }
            in
                ( { model | stopwatch = ( id, newStopwatch ) }, Cmd.none )

        Start ->
            let
                ( id, oldStopwatch ) =
                    model.stopwatch

                newStopwatch =
                    { oldStopwatch
                        | hasStarted = True
                        , hasPaused = False
                        , hasStopped = False
                    }
            in
                case model.setup.rate of
                    Just value ->
                        ( { model | stopwatch = ( id, newStopwatch ) }, Cmd.none )

                    Nothing ->
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

        SaveStopwatch ->
            let
                ( newId, newSw ) =
                    model.stopwatch

                newList =
                    if Dict.member newId (Dict.fromList model.stopwatches) then
                        Dict.toList (Dict.insert newId newSw (Dict.fromList model.stopwatches))
                    else
                        model.stopwatch :: model.stopwatches
            in
                ( { model | stopwatches = newList, listOpened = True }, Cmd.none )

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


updateIncome : Maybe Float -> Float -> Maybe Float -> RateType -> Float
updateIncome rate time nbHours rateType =
    case rate of
        Just rateVal ->
            case nbHours of
                Just nbHoursVal ->
                    (rateVal / nbHoursVal) / 3600 * time

                Nothing ->
                    rateVal / 3600 * time

        Nothing ->
            0


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


formatCurrency : Float -> Model -> String
formatCurrency income model =
    let
        str =
            toString income

        decimals =
            String.split "." str
                |> Array.fromList
                |> Array.get 1
                |> Maybe.withDefault "0"
                |> (\n ->
                        case String.toInt n of
                            Ok i ->
                                if (i % 10) == 0 then
                                    n ++ "0"
                                else
                                    n

                            Err err ->
                                n
                   )

        beforeDecimal =
            String.split "." str
                |> Array.fromList
                |> Array.get 0
                |> Maybe.withDefault "0"
                |> Regex.split All (regex "(?=(?:...)*$)")

        formatedIncome =
            case model.setup.currency of
                "€" ->
                    let
                        delimiter =
                            " "

                        decimal =
                            ","

                        income' =
                            beforeDecimal
                                |> String.join delimiter
                    in
                        [ (String.join decimal [ income', decimals ]), model.setup.currency ]
                            |> String.join ""

                _ ->
                    let
                        delimiter =
                            ","

                        decimal =
                            "."

                        income' =
                            beforeDecimal
                                |> String.join delimiter
                    in
                        [ model.setup.currency, (String.join decimal [ income', decimals ]) ]
                            |> String.join ""
    in
        formatedIncome



-- Main


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
