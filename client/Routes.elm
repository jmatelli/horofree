module Routes exposing (..)

import Navigation
import String exposing (split)


type Location
    = Home
    | Setup
    | Clients
    | NewClient
    | ShowClient Int
    | EditClient Int



-- | Projects
-- | NewProject
-- | ShowProject Int
-- | EditProject Int
-- | Stopwatches
-- | NewStopwatch
-- | ShowStopwatch Int
-- | EditStopwatch Int


type alias Model =
    Maybe Location


init : Maybe Location -> Model
init location =
    location


urlFor : Location -> String
urlFor location =
    let
        url =
            case location of
                Home ->
                    "/"

                Setup ->
                    "/setup"

                Clients ->
                    "/clients"

                NewClient ->
                    "/clients/new"

                ShowClient id ->
                    "/clients/" ++ (toString id)

                EditClient id ->
                    "/clients/" ++ (toString id) ++ "/edit"

        -- Projects ->
        --     "/projects"
        -- NewProject ->
        --     "/projects/new"
        -- ShowProject id ->
        --     "/projects/" ++ (toString id)
        -- EditProject id ->
        --     "/projects/" ++ (toString id) ++ "/edit"
        -- Stopwatches ->
        --     "/stopwatches"
        -- NewStopwatch ->
        --     "/stopwatches/new"
        -- ShowStopwatch id ->
        --     "/stopwatches/" ++ (toString id)
        -- EditStopwatch id ->
        --     "/stopwatches/" ++ (toString id) ++ "/edit"
    in
        "#" ++ url


locFor : Navigation.Location -> Maybe Location
locFor path =
    let
        segments =
            path.hash
                |> split "/"
                |> List.filter (\seg -> seg /= "" && seg /= "#")
    in
        case segments of
            [] ->
                Just Home

            [ "setup" ] ->
                Just Setup

            [ "clients" ] ->
                Just Clients

            [ "clients", "new" ] ->
                Just NewClient

            [ "clients", stringId ] ->
                case String.toInt stringId of
                    Ok id ->
                        Just (ShowClient id)

                    Err _ ->
                        Nothing

            [ "clients", stringId, "edit" ] ->
                String.toInt stringId
                    |> Result.toMaybe
                    |> Maybe.map EditClient

            -- [ "projects" ] ->
            --     Just Projects
            -- [ "projects", "new" ] ->
            --     Just NewProject
            -- [ "projects", stringId ] ->
            --     case String.toInt stringId of
            --         Ok id ->
            --             Just (ShowProject id)
            --         Err _ ->
            --             Nothing
            -- [ "projects", stringId, "edit" ] ->
            --     String.toInt stringId
            --         |> Result.toMaybe
            --         |> Maybe.map EditProject
            -- [ "stopwatches" ] ->
            --     Just Stopwatches
            -- [ "stopwatches", "new" ] ->
            --     Just NewStopwatch
            -- [ "stopwatches", stringId ] ->
            --     case String.toInt stringId of
            --         Ok id ->
            --             Just (ShowStopwatch id)
            --         Err _ ->
            --             Nothing
            -- [ "stopwatches", stringId, "edit" ] ->
            --     String.toInt stringId
            --         |> Result.toMaybe
            --         |> Maybe.map EditStopwatch
            _ ->
                Nothing
