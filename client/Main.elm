module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.CssHelpers exposing (withNamespace)
import Styles exposing (..)


{ class } =
    withNamespace ""



-- MODEL


rate : Float
rate =
    450


nbHours : Float
nbHours =
    7



-- MESSAGES
-- VIEW
-- UPDATE
-- SUBSCRIPTIONS
-- MAIN


headerView =
    header [ class [ Header ] ]
        [ h1 [ style [ ( "z-index", "1030" ) ] ] [ text "Horofree" ] ]


main =
    headerView
