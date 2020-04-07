module Main exposing (main)

import Browser
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)



-- access key or client_id 632WPbpNGm3zBzgCXEio2rhbbAn5sNlGZlPNH0cbBd8


unsplashApiUri : String
unsplashApiUri =
    "https://api.unsplash.com/"


unsplashAuthUri : String
unsplashAuthUri =
    "https://unsplash.com/oauth/"


usRedirectUri : String
usRedirectUri =
    "urn:ietf:wg:oauth:2.0:oob"


type alias Model =
    { count : Int }


initialModel : Model
initialModel =
    { count = 0 }


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | count = model.count + 1 }

        Decrement ->
            { model | count = model.count - 1 }


view : Model -> Html Msg
view model =
    div []
        [ button
            [ onClick Increment
            , class "bg-blue-400 text-white font-bold px-4 py-2 rounded"
            ]
            [ text "+1" ]
        , div [] [ text <| String.fromInt model.count ]
        , button [ onClick Decrement ] [ text "-1" ]
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
