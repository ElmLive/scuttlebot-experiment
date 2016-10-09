-- module Scuttlebot exposing (..)
--
--
-- save : Json.Value -> Cmd msg
--
--
-- subscribe : (Json.Value -> msg) -> Sub msg


module Main exposing (..)

import Html.App
import Html exposing (Html)
import WebSocket
import Vote
import Json.Decode


type alias Model =
    { votes : Vote.Model }


initialModel : Model
initialModel =
    { votes = Vote.initialModel }


type Msg
    = FromWebsocket String
    | AppMessage Vote.Msg


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        FromWebsocket string ->
            case Debug.log "decoded" (Json.Decode.decodeString Vote.decodeMsg string) of
                Err msg ->
                    ( model, Cmd.none )

                Ok voteMsg ->
                    ( { model | votes = Vote.update voteMsg model.votes }, Cmd.none )

        AppMessage localVoteMsg ->
            -- TODO: persiste the new message to scuttlebot
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    Html.App.map AppMessage (Vote.view model.votes)


main =
    Html.App.program
        { init = ( initialModel, Cmd.none )
        , update = update
        , subscriptions =
            \_ ->
                WebSocket.listen "ws://localhost:8080" FromWebsocket
        , view = view
        }
