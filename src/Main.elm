module Main exposing (main)

import Browser
import Html exposing (Html, button, div, img)
import Html.Attributes exposing (src)
import Html.Events exposing (onClick)



-- access key or client_id 632WPbpNGm3zBzgCXEio2rhbbAn5sNlGZlPNH0cbBd8


usApiUri : String
usApiUri =
    "https://api.unsplash.com/"


usAuthUri : String
usAuthUri =
    "https://unsplash.com/oauth/"


usRedirectUri : String
usRedirectUri =
    "urn:ietf:wg:oauth:2.0:oob"


randomPhotoLink : String
randomPhotoLink =
    "https://images.unsplash.com/profile-1584195344340-d978874b82c9image?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=32&w=32"


type alias Model =
    { photo : String }


initialModel : Model
initialModel =
    { photo = randomPhotoLink }


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model

        Decrement ->
            model


view : Model -> Html Msg
view model =
    div []
        [ img [ src model.photo ] []
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
