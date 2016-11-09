module Main exposing (..)

import Navigation


-- import Time exposing (..)
-- import Json.Decode as Json
-- import Exts.Float exposing (roundTo)

import Models exposing (Stopwatch, Setup, Model, RateType(PerDays, PerHours), initialModel)
import Messages exposing (..)
import Update exposing (..)
import Routes exposing (..)
import View exposing (..)


-- init
-- init : ( Model, Cmd Msg )
-- init =
--     ( initialModel, Cmd.none )
-- Update
-- update : Msg -> Model -> ( Model, Cmd Msg )
-- update msg model =
--     case msg of
--         AddStopwatch ->
--             let
--                 ( id, oldStopwatch ) =
--                     model.stopwatch
--                 newId =
--                     id + 1
--                 ( initId, initSw ) =
--                     initialStopwatch
--             in
--                 ( { model
--                     | stopwatch = ( newId, initSw )
--                     , listOpened = True
--                   }
--                 , Cmd.none
--                 )
--         Messages.RemoveStopwatch id ->
--             let
--                 matchingId a x =
--                     let
--                         ( i, sw ) =
--                             x
--                     in
--                         a /= i
--                 newList =
--                     List.filter (matchingId id) model.stopwatches
--             in
--                 ( { model | stopwatches = newList }, Cmd.none )
--         ChangeStopwatch id ->
--             let
--                 ( initId, initSw ) =
--                     initialStopwatch
--                 matchingId a x =
--                     let
--                         ( i, sw ) =
--                             x
--                     in
--                         a == i
--                 newSw =
--                     model.stopwatches
--                         |> List.filter (matchingId id)
--                         |> Array.fromList
--                         |> Array.get 0
--                         |> Maybe.withDefault ( 0, initSw )
--             in
--                 ( { model | stopwatch = newSw }, Cmd.none )
--         Messages.SaveSetup ->
--             let
--                 oldSetup =
--                     model.setup
--                 inputRate =
--                     case String.toFloat model.inputRate of
--                         Ok value ->
--                             if value == 0 then
--                                 Nothing
--                             else
--                                 Just value
--                         Err err ->
--                             Nothing
--                 inputHours =
--                     case String.toFloat model.inputHours of
--                         Ok value ->
--                             if value == 0 || model.inputRateType == PerHours then
--                                 Nothing
--                             else
--                                 Just value
--                         Err err ->
--                             Nothing
--                 newSetup =
--                     { oldSetup | rate = inputRate, currency = model.inputCurrency, rateType = model.inputRateType, nbHours = inputHours }
--             in
--                 ( { model | setup = newSetup, setupOpened = False }, Cmd.none )
--         UpdateStopwatch time ->
--             let
--                 ( id, oldStopwatch ) =
--                     model.stopwatch
--                 newTime =
--                     oldStopwatch.time + 1
--                 newIncome =
--                     updateIncome model.setup.rate newTime model.setup.nbHours model.setup.rateType
--                 newStopwatch =
--                     { oldStopwatch
--                         | time = newTime
--                         , income = newIncome
--                     }
--             in
--                 ( { model | stopwatch = ( id, newStopwatch ) }, Cmd.none )
--         Start ->
--             let
--                 ( id, oldStopwatch ) =
--                     model.stopwatch
--                 newStopwatch =
--                     { oldStopwatch
--                         | hasStarted = True
--                         , hasPaused = False
--                         , hasStopped = False
--                     }
--             in
--                 case model.setup.rate of
--                     Just value ->
--                         ( { model | stopwatch = ( id, newStopwatch ) }, Cmd.none )
--                     Nothing ->
--                         ( model, Cmd.none )
--         Pause ->
--             let
--                 ( id, oldStopwatch ) =
--                     model.stopwatch
--                 newStopwatch =
--                     { oldStopwatch
--                         | hasStarted = False
--                         , hasPaused = True
--                         , hasStopped = False
--                     }
--             in
--                 ( { model | stopwatch = ( id, newStopwatch ) }, Cmd.none )
--         Stop ->
--             let
--                 ( id, oldStopwatch ) =
--                     model.stopwatch
--                 newStopwatch =
--                     { oldStopwatch
--                         | time = 0
--                         , income = 0
--                         , hasStarted = False
--                         , hasPaused = False
--                         , hasStopped = True
--                     }
--             in
--                 ( { model | stopwatch = ( id, newStopwatch ) }, Cmd.none )
--         SaveStopwatch ->
--             let
--                 ( newId, newSw ) =
--                     model.stopwatch
--                 newList =
--                     if Dict.member newId (Dict.fromList model.stopwatches) then
--                         Dict.toList (Dict.insert newId newSw (Dict.fromList model.stopwatches))
--                     else
--                         model.stopwatch :: model.stopwatches
--             in
--                 ( { model | stopwatches = newList, listOpened = True }, Cmd.none )
--         NoOp ->
--             ( model, Cmd.none )
-- Subscriptions
-- subscriptions : Model -> Sub Msg
-- subscriptions model =
--     let
--         ( id, sw ) =
--             model.stopwatch
--     in
--         if sw.hasStarted && not sw.hasStopped then
--             every second UpdateStopwatch
--         else
--             Sub.none
-- Main


subscriptions : Models.Model -> Sub Msg
subscriptions model =
    Sub.none


urlUpdate : Maybe Routes.Location -> Models.Model -> ( Models.Model, Cmd Msg )
urlUpdate location oldModel =
    let
        newModel =
            { oldModel | route = location }
    in
        ( newModel, Cmd.none )


init : Maybe Routes.Location -> ( Models.Model, Cmd Msg )
init location =
    let
        initialModel =
            Models.initialModel location
    in
        urlUpdate location initialModel


main : Program Never
main =
    Navigation.program (Navigation.makeParser Routes.locFor)
        { init = init
        , view = view
        , update = update
        , urlUpdate = urlUpdate
        , subscriptions = subscriptions
        }
