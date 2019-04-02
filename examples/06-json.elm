import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, field, string)

main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = \model -> Sub.none
    , view = view
    }

type Model
  = Failure String
  | Loading
  | Success String

init : () -> (Model, Cmd Msg)
init _ = (Loading, getRandomCatGif)

type Msg
  = MorePlease
  | GotGif (Result Http.Error String)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease -> (Loading, getRandomCatGif)
    GotGif result ->
      case result of
        Ok url -> (Success url, Cmd.none)
        Err e -> (Failure (httpErrorString e), Cmd.none)

httpErrorString : Http.Error -> String
httpErrorString error =
    case error of
        Http.BadUrl text ->
            "Bad Url: " ++ text
        Http.Timeout ->
            "Http Timeout"
        Http.NetworkError ->
            "Network Error"
        Http.BadStatus code ->
            "Bad Http Status: " ++ (String.fromInt code)
        Http.BadBody response ->
            "Bad Http Body: " ++ response

view : Model -> Html Msg
view model =
  div []
    [ h2 [] [ text "Random Cats" ]
    , viewGif model
    ]

viewGif : Model -> Html Msg
viewGif model =
  case model of
    Failure e ->
      div []
        [ text "I could not load a random cat for some reason: "
        , text e
        , button [ onClick MorePlease ] [ text "Try Again!" ]
        ]

    Loading ->
      text "Loading..."

    Success url ->
      div []
        [ button [ onClick MorePlease, style "display" "block" ] [ text "More Please!" ]
        , img [ src url ] []
        ]


getRandomCatGif : Cmd Msg
getRandomCatGif =
  Http.get
    { url = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=cat"
    , expect = Http.expectJson GotGif (field "data" (field "image_url" string))
    }