module Main exposing (main)

import Browser
import Html exposing (Html, button, div, img)
import Html.Attributes exposing (src)
import Http
import Json.Decode exposing (Decoder, field, string)



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


type alias RandomPhoto =
    { id : String
    , urls :
        { small : String
        }
    , user :
        { id : String
        , username : String
        }
    , view : Int
    }


fetchFeed : Cmd Msg
fetchFeed =
    Http.get
        { url = String ++ "/photos/random" ++ "?client_id=632WPbpNGm3zBzgCXEio2rhbbAn5sNlGZlPNH0cbBd8"
        , expect = Http.expectJson LoadFeed smallRandomPhotoDecoder
        }


initialModel : RandomPhoto
initialModel =
    { photo = randomPhotoLink }


init : () -> ( RandomPhoto, Cmd Msg )
init () =
    ( initialModel, fetchFeed )


type Msg
    = LoadFeed (Result Http.Error RandomPhoto)


update : Msg -> RandomPhoto -> RandomPhoto
update msg randomPhoto =
    case msg of
        LoadFeed _ ->
            ( randomPhoto, Cmd.none )


smallRandomPhotoDecoder : Decoder RandomPhoto
smallRandomPhotoDecoder =
    Decode.succeed RandomPhoto
        |> required "id" string
        |> required "urls" (required "small" string)
        |> required "user" (required "id" string)
        |> required "user" (required "username" string)
        |> required "view" int


view : RandomPhoto -> Html Msg
view model =
    div []
        [ img [ src model.photo ] []
        ]


subscriptions : RandomPhoto -> Sub Msg
subscriptions randomPhoto =
    Sub.none


main : Program () RandomPhoto Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
