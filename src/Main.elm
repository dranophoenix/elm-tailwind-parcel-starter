module Main exposing (main)

import Browser
import Html exposing (Html, button, div, img, text)
import Html.Attributes exposing (src)
import Http
import Json.Decode exposing (Decoder, field, int, map2, map5, string, succeed)
import Json.Decode.Pipeline exposing (required)


clientId =
    "632WPbpNGm3zBzgCXEio2rhbbAn5sNlGZlPNH0cbBd8"


appendClientId : String -> String
appendClientId uri =
    uri ++ "?client_id=" ++ clientId


usRandomPhotoUri : String -> String
usRandomPhotoUri uri =
    uri ++ "photos/random"


usApiUri : String
usApiUri =
    "https://api.unsplash.com/"


usRedirectUri : String
usRedirectUri =
    "urn:ietf:wg:oauth:2.0:oob"


type alias RandomPhoto =
    { id : String
    , urls : UrlsAttrs
    , user : UserAttrs
    , view : Int
    }


type alias UserAttrs =
    { id : String
    , username : String
    }


type alias UrlsAttrs =
    { raw : String
    , full : String
    , regular : String
    , small : String
    , thumb : String
    }


type alias Model =
    { randomPhoto : Maybe RandomPhoto }


fetchFeed : Cmd Msg
fetchFeed =
    Http.get
        { url = usApiUri |> usRandomPhotoUri |> appendClientId
        , expect = Http.expectJson LoadFeed smallRandomPhotoDecoder
        }


initialModel : Model
initialModel =
    { randomPhoto = Nothing }


init : () -> ( Model, Cmd Msg )
init () =
    ( initialModel, fetchFeed )


type Msg
    = LoadFeed (Result Http.Error RandomPhoto)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadFeed (Ok randomPhoto) ->
            ( { model | randomPhoto = Just randomPhoto }, Cmd.none )

        LoadFeed (Err _) ->
            ( model, Cmd.none )


userAttrsDecoder : Decoder UserAttrs
userAttrsDecoder =
    map2 UserAttrs
        (field "id" string)
        (field "username" string)


urlsAttrsDecoder : Decoder UrlsAttrs
urlsAttrsDecoder =
    map5 UrlsAttrs
        (field "raw" string)
        (field "full" string)
        (field "regular" string)
        (field "small" string)
        (field "thumb" string)


smallRandomPhotoDecoder : Decoder RandomPhoto
smallRandomPhotoDecoder =
    succeed RandomPhoto
        |> required "id" string
        |> required "urls" urlsAttrsDecoder
        |> required "user" userAttrsDecoder
        |> required "views" int


viewFeed : Maybe RandomPhoto -> Html Msg
viewFeed maybeRandomPhoto =
    case maybeRandomPhoto of
        Just randomPhoto ->
            img [ src randomPhoto.urls.small ] []

        Nothing ->
            div [] [ text "Loading...." ]


view : Model -> Html Msg
view model =
    div []
        [ viewFeed model.randomPhoto ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
