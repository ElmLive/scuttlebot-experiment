module Vote exposing (..)

import Html.App
import Html exposing (Html)
import Html.Events exposing (onClick)


type alias Model =
    { red : Int
    , green : Int
    , blue : Int
    }


initialModel =
    { red = 0, green = 0, blue = 0 }


type Msg
    = VoteRed
    | VoteGreen
    | VoteBlue


update : Msg -> Model -> Model
update msg model =
    case msg of
        VoteRed ->
            { model | red = model.red + 1 }

        VoteGreen ->
            { model | green = model.green + 1 }

        VoteBlue ->
            { model | blue = model.blue + 1 }


view : Model -> Html Msg
view model =
    Html.div []
        [ Html.ul []
            [ Html.li [] [ Html.text ("Red: " ++ toString model.red) ]
            , Html.li [] [ Html.text ("Green: " ++ toString model.green) ]
            , Html.li [] [ Html.text ("Blue: " ++ toString model.blue) ]
            ]
        , Html.button [ onClick VoteRed ] [ Html.text "Vote Red" ]
        , Html.button [ onClick VoteGreen ] [ Html.text "Vote Green" ]
        , Html.button [ onClick VoteBlue ] [ Html.text "Vote Blue" ]
        ]


main : Program Never
main =
    Html.App.beginnerProgram
        { model = initialModel
        , update = update
        , view = view
        }
