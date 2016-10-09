module Scuttlebot exposing (..)


save : Json.Value -> Cmd msg


subscribe : (Json.Value -> msg) -> Sub msg
