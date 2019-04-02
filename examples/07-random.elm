import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Random

main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }

type alias Model =
  { dieFace : Int, history: List Int }

init : () -> (Model, Cmd Msg)
init _ = ( Model 1 [1], Cmd.none)


type Msg = Roll | NewFace Int

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll            -> ( model         , Random.generate NewFace (Random.int 1 6))
    NewFace newFace -> ( Model newFace (newFace :: model.history), Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

average : List Int -> Float
average xs =
  case List.length xs of
  0 -> 0.0
  n -> (xs |> List.sum |> toFloat) / (toFloat n)

view : Model -> Html Msg
view model =
  div []
    [ h1 [] [ text (String.fromInt model.dieFace) ]
    , div [] [ text ("History: " ++ (model.history |> List.map String.fromInt |> List.intersperse ", " |> String.concat))]
    , div [] [ text ("Average: " ++ (average model.history |> String.fromFloat))]
    , button [ onClick Roll ] [ text "Roll" ]
    ]