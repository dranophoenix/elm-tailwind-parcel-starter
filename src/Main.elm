module Main exposing (main)

import Browser
import Html exposing (Html, div, img, option, select, span, text)
import Html.Attributes exposing (class, src, value)
import Html.Events exposing (onInput)
import Http
import Json.Decode exposing (Decoder, field, int, list, map2, map5, string, succeed)
import Json.Decode.Pipeline exposing (required)


clientId =
    "632WPbpNGm3zBzgCXEio2rhbbAn5sNlGZlPNH0cbBd8"


appendClientId : String -> String
appendClientId uri =
    uri ++ "&client_id=" ++ clientId


initCount =
    2


appendCount : Int -> String -> String
appendCount count uri =
    uri ++ "&count=" ++ String.fromInt count


usRandomPhotoUri : String -> String
usRandomPhotoUri uri =
    uri ++ "photos/random?"


usApiUri : String
usApiUri =
    "https://api.unsplash.com/"


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


type alias RandomPhotos =
    List RandomPhoto


type alias Model =
    { randomPhotos : Maybe RandomPhotos
    , count : Int
    }


fetchFeed : Cmd Msg
fetchFeed =
    Http.get
        { url = usApiUri |> usRandomPhotoUri |> appendClientId |> appendCount initCount
        , expect = Http.expectJson LoadFeed (list smallRandomPhotoDecoder)
        }


initialModel : Model
initialModel =
    { randomPhotos = Nothing
    , count = initCount
    }


init : () -> ( Model, Cmd Msg )
init () =
    ( initialModel, fetchFeed )


type Msg
    = LoadFeed (Result Http.Error RandomPhotos)
    | ChangeAmount String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeAmount amount ->
            case String.toInt amount of
                Just selectedAmount ->
                    ( { model | count = selectedAmount }, fetchFeed )

                Nothing ->
                    ( model, Cmd.none )

        LoadFeed (Ok randomPhotos) ->
            ( { model | randomPhotos = Just randomPhotos }, Cmd.none )

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


viewPhoto : RandomPhoto -> Html Msg
viewPhoto randomPhoto =
    div []
        [ div []
            [ text randomPhoto.user.username ]
        , span
            []
            [ img [ src randomPhoto.urls.small ] [] ]
        ]


viewFeed : Maybe RandomPhotos -> Html Msg
viewFeed maybeRandomPhotos =
    case maybeRandomPhotos of
        Just randomPhotos ->
            div [] (List.map viewPhoto randomPhotos)

        Nothing ->
            div [] [ text "Loading...." ]


durationOption : Int -> Html Msg
durationOption amount =
    option [ value (String.fromInt amount) ] [ text (String.fromInt amount) ]


viewPhotoCountInput : Int -> Html Msg
viewPhotoCountInput count =
    select
        [ onInput ChangeAmount, class "bg-blue-200" ]
        (List.map durationOption (List.range 1 3))


view : Model -> Html Msg
view model =
    div []
        [ viewPhotoCountInput model.count
        , viewFeed model.randomPhotos
        ]


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
