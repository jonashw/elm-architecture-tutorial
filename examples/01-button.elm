import Browser
import Html exposing (Html, button, div, text, span)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)


main =
  Browser.sandbox { init = init, update = update, view = view }


-- MODEL

type alias Model = {count: Int, presses: Int}

init : Model
init =
  {count = 0, presses = 0}


-- UPDATE

type Msg = Increment | Decrement | Reset

update : Msg -> Model -> Model
update msg model =
  let presses = model.presses + 1 in
  case msg of
    Increment -> {count = model.count + 1, presses = presses }
    Decrement -> {count = model.count - 1, presses = presses }
    Reset     -> {count = 0              , presses = 0 }

-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , span [style "padding" "1em"] 
      [ span [] [ text ("Count: " ++ (String.fromInt model.count)) ]
      , span [style "padding-left" "0.66em"] [ text ("Presses: " ++ (String.fromInt model.presses)) ]
      ]
    , button [ onClick Increment ] [ text "+" ]
    , div [style "padding-top" "1em"] 
      [ button [ onClick Reset ] [ text "reset" ] ]
    ]