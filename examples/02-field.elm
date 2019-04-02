import Browser
import Html exposing (Html, Attribute, div, input, text, table, tr, th, td)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)

main =
  Browser.sandbox { init = init, update = update, view = view }


type alias Model = { content : String }


init : Model
init = { content = "" }


type Msg = Change String

update : Msg -> Model -> Model
update msg model =
  case msg of
    Change newContent ->
      { model | content = newContent }


view : Model -> Html Msg
view model =
  div []
    [ input [ placeholder "Text to reverse", value model.content, onInput Change ] []
    , table [style "border" "1px solid blue", style "border-collapse" "collapse"] 
      [
        tr [] 
          [ th [] [text "x"]
          , th [] [text "Original order"]
          , th [] [text "Reversed"]
          ]
      , tr []
        [ th [] [text "Original case"]
        , td [] [text (model.content |> identity       |> identity)]
        , td [] [text (model.content |> String.reverse |> identity)]
        ]
      , tr []
        [ th [] [text "lower case"]
        , td [] [text (model.content |> identity       |> String.toLower)]
        , td [] [text (model.content |> String.reverse |> String.toLower)]
        ]
      , tr []
        [ th [] [text "UPPER case"]
        , td [] [text (model.content |> identity       |> String.toUpper)]
        , td [] [text (model.content |> String.reverse |> String.toUpper)]
        ]
      ]
    ]