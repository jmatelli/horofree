module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.CssHelpers exposing (withNamespace)
import Styles exposing (..)
import Models exposing (..)
import Messages exposing (..)
import Routes exposing (..)


-- import Utils exposing (..)


{ id, class, classList } =
    withNamespace ""



-- View


view : Models.Model -> Html Msg
view model =
    main' []
        [ headerView model
          -- , listStopwatchesView model
          -- , stopwatchView model
          -- , setupView model
        , body model
        ]


headerView : Models.Model -> Html Msg
headerView model =
    header [ class [ Header ] ]
        [ h1 [ style [ ( "z-index", "1030" ) ] ] [ text "Horofree" ]
        , nav []
            [ a [ onClick (NavigateTo (Just Clients)) ]
                [ text "Clients" ]
            ]
        ]


body : Models.Model -> Html Msg
body model =
    case model.route of
        Just (Routes.Home) ->
            homeView model

        Just (Routes.Setup) ->
            setupView model

        Just (Routes.Clients) ->
            clientsView model

        Just (Routes.NewClient) ->
            newClientView model

        Just (Routes.ShowClient id) ->
            showClientView model id

        Just (Routes.EditClient id) ->
            editClientView model id

        Nothing ->
            text "404"


homeView : Models.Model -> Html Msg
homeView model =
    div []
        [ h2 [] [ text "Home" ] ]


setupView : Models.Model -> Html Msg
setupView model =
    div []
        [ h2 [] [ text "Setup" ] ]


clientsView : Models.Model -> Html Msg
clientsView model =
    div []
        [ h2 [] [ text "Clients" ] ]


newClientView : Models.Model -> Html Msg
newClientView model =
    div []
        [ h2 [] [ text "New Clients" ] ]


showClientView : Models.Model -> Int -> Html Msg
showClientView model id =
    div []
        [ h2 [] [ text "Show Clients" ] ]


editClientView : Models.Model -> Int -> Html Msg
editClientView model id =
    div []
        [ h2 [] [ text "Edit Clients" ] ]



-- listStopwatchesView : Model -> Html Msg
-- listStopwatchesView model =
--     let
--         listClass =
--             if model.listOpened then
--                 [ ListStopwatches, ListOpened ]
--             else
--                 [ ListStopwatches, ListClosed ]
--     in
--         model.stopwatches
--             |> List.sortBy (\( n, s ) -> n)
--             |> List.map (listItem model)
--             |> div [ class listClass ]
-- listItem : Model -> Stopwatch -> Html Msg
-- listItem model stopwatch =
--     let
--         ( id, sw ) =
--             stopwatch
--     in
--         div [ class [ ListItem ] ]
--             [ a [ class [ ListItemDetails ] ]
--                 [ span [] [ text ((toString id) ++ ".") ]
--                 , span []
--                     [ text (toStopwatch sw.time)
--                     , br [] []
--                     , text ((toString (roundTo 2 (sw.income))) ++ model.setup.currency)
--                     ]
--                 ]
--             , div
--                 [ class [ Styles.RemoveStopwatch ]
--                 ]
--                 [ a [ onClick (Messages.RemoveStopwatch id) ]
--                     [ i [ class [ "fa", "fa-times" ] ] [] ]
--                 , a [ onClick (Messages.ChangeStopwatch id) ]
--                     [ i [ class [ "fa", "fa-chevron-right" ] ] [] ]
--                 ]
--             ]
-- setupView : Model -> Html Msg
-- setupView model =
--     let
--         setupClass =
--             if model.setupOpened then
--                 [ Styles.Setup ]
--             else
--                 [ Styles.Setup, Hidden ]
--         inputHoursClass =
--             if model.inputRateType == PerHours then
--                 [ Hidden ]
--             else
--                 []
--     in
--         div [ class setupClass, style [ ( "z-index", "1010" ) ] ]
--             [ Html.form [ class [ SetupContainer ], onSubmit Messages.SaveSetup ]
--                 [ h2 [] [ text "Setup" ]
--                 , div []
--                     [ label [ class [ LabelSetup ] ] [ text "Your daily/hourly rate" ]
--                     , div []
--                         [ input
--                             [ class [ InputText ]
--                             , type' "text"
--                             , onInput InputRate
--                             , value model.inputRate
--                             ]
--                             []
--                         , selectCurrency model
--                         ]
--                     ]
--                 , div [ class inputHoursClass ]
--                     [ label [ class [ LabelSetup ] ] [ text "Number of hours per day" ]
--                     , div []
--                         [ input
--                             [ class [ InputText, Styles.InputHours ]
--                             , type' "text"
--                             , onInput Messages.InputHours
--                             , value model.inputHours
--                             ]
--                             []
--                         ]
--                     ]
--                 , div []
--                     [ radio "Per days" PerDays (InputRateType PerDays) model
--                     , radio "Per hours" PerHours (InputRateType PerHours) model
--                     ]
--                 , div []
--                     [ button [ class [ Styles.SaveSetup ], type' "submit" ] [ text "Save" ]
--                     , button [ class [ Styles.CancelSetup ], onClick Messages.CancelSetup ] [ text "Cancel" ]
--                     ]
--                 ]
--             ]
-- radio : String -> RateType -> msg -> Model -> Html msg
-- radio value rateType msg model =
--     let
--         labelClass =
--             if model.inputRateType == rateType then
--                 [ Styles.RateType, RateTypeSelected ]
--             else
--                 [ Styles.RateType ]
--     in
--         label [ class labelClass ]
--             [ input [ type' "radio", name "rate-type", onClick msg, checked (model.inputRateType == rateType) ] []
--             , text value
--             ]
-- currencies : List String
-- currencies =
--     [ "€", "$", "£", "¥" ]
-- selectCurrency : Model -> Html Msg
-- selectCurrency model =
--     select [ class [ SpanInput ], on "change" (Json.map InputCurrency targetValue) ]
--         (List.map (currencyItem model) currencies)
-- currencyItem : Model -> String -> Html msg
-- currencyItem model currency =
--     option [ selected (model.inputCurrency == currency), value currency ] [ text currency ]
-- stopwatchView : Model -> Html Msg
-- stopwatchView model =
--     let
--         ( id, sw ) =
--             model.stopwatch
--     in
--         div []
--             [ div [ class [ Styles.Stopwatch ] ] [ text (toStopwatch sw.time) ]
--             , div [ class [ Income ] ] [ text (formatCurrency (roundTo 2 (sw.income)) model) ]
--             , div [ class [ BtnContainer ] ]
--                 [ button
--                     [ class [ BtnControl ]
--                     , onClick Start
--                     , disabled (model.setup.rate == Nothing || sw.hasStarted)
--                     ]
--                     [ i [ class [ "fa", "fa-play" ] ] [] ]
--                 , button
--                     [ class [ BtnControl ]
--                     , onClick Pause
--                     , disabled (model.setup.rate == Nothing || sw.hasPaused || not sw.hasStarted)
--                     ]
--                     [ i [ class [ "fa", "fa-pause" ] ] [] ]
--                 , button
--                     [ class [ BtnControl ]
--                     , onClick Stop
--                     , disabled (model.setup.rate == Nothing || sw.hasStopped)
--                     ]
--                     [ i [ class [ "fa", "fa-stop" ] ] [] ]
--                 ]
--             , div [ class [ BtnContainer ] ]
--                 [ button
--                     [ class [ BtnSave ]
--                     , onClick SaveStopwatch
--                     , disabled (not sw.hasPaused || sw.time == 0)
--                     ]
--                     [ text "save" ]
--                 ]
--             ]
