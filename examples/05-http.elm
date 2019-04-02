import Browser
import Html exposing (Html, text, pre, button, div)
import Html.Events exposing (onClick)
import Http

-- MAIN
main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = \model -> Sub.none
    , view = view
    }

-- MODEL
type Model
  = 
    Ready
  | Failure
  | Loading
  | Success String

init : () -> (Model, Cmd Msg)
init _ = ( Ready , Cmd.none)

type Msg = GetText | GotText (Result Http.Error String)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GetText ->
      (model,Http.get
        { url = "https://elm-lang.org/assets/public-opinion.txt"
        , expect = Http.expectString GotText
        })
    GotText result ->
      case result of
        Ok fullText -> (Success fullText, Cmd.none)
        Err _ -> (Failure, Cmd.none)

view : Model -> Html Msg
view model =
  case model of
    Ready -> 
      button [onClick GetText] [text "Load book"]
    Failure -> 
      div []
      [ div [] [text "I was unable to load your book."]
      , button [onClick GetText] [text "Try again"]
      ]
    Loading -> text "Loading..."
    Success fullText -> pre [] [ text fullText ]