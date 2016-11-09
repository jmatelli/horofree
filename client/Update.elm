module Update exposing (..)

import Models exposing (..)
import Messages exposing (..)
import Routes exposing (Location(..))
import Navigation


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NavigateTo maybeLocation ->
            case maybeLocation of
                Nothing ->
                    ( model, Cmd.none )

                Just location ->
                    ( model, Navigation.newUrl (Routes.urlFor location) )

        ClientMsg' msg ->
            let
                ( clientsModel, cmd ) =
                    updateClientMsg model msg model.clients
            in
                ( { model | clients = clientsModel }, cmd )

        NoOp ->
            ( model, Cmd.none )


updateClientMsg : Model -> ClientMsg -> ClientsModel -> ( ClientsModel, Cmd Msg )
updateClientMsg model msg clientsModel =
    case msg of
        CreateClient name ->
            let
                lastClient =
                    clientsModel.clients
                        |> List.sortBy .id
                        |> List.reverse
                        |> List.head
            in
                case lastClient of
                    Just client ->
                        let
                            oldClients =
                                clientsModel.clients

                            newClient =
                                { id = client.id + 1
                                , name = name
                                }
                        in
                            ( { clientsModel | clients = newClient :: oldClients }, Navigation.newUrl (Routes.urlFor Clients) )

                    Nothing ->
                        ( clientsModel, Cmd.none )

        Messages.ShowClient id ->
            let
                shownClient =
                    clientsModel.clients
                        |> List.filter (\client -> client.id == id)
                        |> List.head
            in
                case shownClient of
                    Just client ->
                        ( { clientsModel | shownClient = shownClient }, Navigation.newUrl (Routes.urlFor (Routes.ShowClient id)) )

                    Nothing ->
                        ( clientsModel, Cmd.none )

        Messages.DeleteClient id ->
            let
                newClients =
                    clientsModel.clients
                        |> List.filter (\client -> client.id /= id)
            in
                ( { clientsModel | clients = newClients }, Cmd.none )

        Messages.UpdateClient id name ->
            let
                clientToUpdate =
                    clientsModel.clients
                        |> List.filter (\client -> client.id == id)
                        |> List.head
            in
                case clientToUpdate of
                    Just client ->
                        let
                            newClients =
                                clientsModel.clients
                                    |> List.filter (\client -> client.id /= id)

                            updatedClient =
                                { client | name = name }
                        in
                            ( { clientsModel | clients = updatedClient :: newClients }, Cmd.none )

                    Nothing ->
                        ( clientsModel, Cmd.none )
