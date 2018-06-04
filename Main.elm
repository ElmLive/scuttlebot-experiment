-- module Scuttlebot exposing (..)
--
--
-- save : Json.Value -> Cmd msg
--
--
-- subscribe : (Json.Value -> msg) -> Sub msg


module Main exposing (..)

import Html exposing (Html)
import WebSocket
import Vote
import Json.Decode
import Json.Encode


wsUrl =
    "ws://localhost:8080"


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
            ( model
            , WebSocket.send wsUrl
                (Json.Encode.encode 0 (Vote.encodeMsg localVoteMsg))
            )


view : Model -> Html Msg
view model =
    Html.map AppMessage (Vote.view model.votes)


main =
    Html.program
        { init = ( initialModel, Cmd.none )
        , update = update
        , subscriptions =
            \_ ->
                WebSocket.listen wsUrl FromWebsocket
        , view = view
        }
