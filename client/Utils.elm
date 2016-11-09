module Utils exposing (updateIncome, toStopwatch, formatCurrency)

import Models exposing (..)
import String exposing (split, toInt)
import Array exposing (fromList, get)
import Regex exposing (..)


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
