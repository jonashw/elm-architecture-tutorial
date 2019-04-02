import Browser
import Html
import Html.Attributes
import Task
import Time
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Debug 

main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = \model -> Time.every 1000 Tick
    }

type alias Model =
  { zone : Time.Zone
  , time : Time.Posix
  }

init : () -> (Model, Cmd Msg)
init _ =
  ( Model Time.utc (Time.millisToPosix 0)
  , Task.perform AdjustTimeZone Time.here
  )

type Msg
  = Tick Time.Posix
  | AdjustTimeZone Time.Zone

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      ( { model | time = newTime }
      , Cmd.none
      )

    AdjustTimeZone newZone ->
      ( { model | zone = newZone }
      , Cmd.none
      )


view : Model -> Html.Html Msg
view model =
  let
    h      = (Time.toHour   model.zone model.time)
    m      = (Time.toMinute model.zone model.time)
    s      = (Time.toSecond model.zone model.time)
    hour   = String.fromInt h
    minute = String.fromInt m
    second = String.fromInt s
  in
  Html.h1 [] 
  [ Html.div [] [ Html.text (hour ++ ":" ++ minute ++ ":" ++ second) ]
  , svg 
      [ width "350", height "350", viewBox "0 0 150 150", fill "white", stroke "black", strokeWidth "3", Svg.Attributes.style "padding-left: 20px" ]
      (svgView h m s)
  ]

svgView : Int -> Int -> Int -> List (Svg Msg)
svgView h m s = 
  let radius = 35.0 
      hRadius = radius - 7.0
      rad = radius |> String.fromFloat
      htheta = (toFloat (h |> modBy 12) / 12.0) |> degrees
      hx = hRadius * sin htheta
      hy = hRadius * cos htheta
  in
  [ circle
      [ cx (radius |> String.fromFloat)
      , cy (radius |> String.fromFloat)
      , r "30"
      , strokeWidth "1px"
      , stroke "black"
      ]
      []
  , hand (radius,radius) "black" "3px" (radius*0.55) (toFloat (h |> modBy 12) / 12.0)
  , hand (radius,radius) "black" "2px" (radius*0.65) (toFloat m / 60)
  , hand (radius,radius) "red"   "1px" (radius*0.80) (toFloat s / 60)
  , circle
      [ cx (radius |> String.fromFloat)
      , cy (radius |> String.fromFloat)
      , r "1"
      , fill "black"
      ]
      []
  ]

hand : (Float,Float) -> String -> String -> Float -> Float -> Svg Msg
hand (centerX, centerY) color strokeWidth_ radius percent =
  let
      theta = Debug.log "theta" (2*pi*percent)
      x = Debug.log "x" (radius * sin theta)
      y = Debug.log "y" (radius * cos (pi+theta))
  in
    line 
      [ x1 (String.fromFloat centerX)
      , y1 (String.fromFloat centerY)
      , x2 (String.fromFloat (centerX + x))
      , y2 (String.fromFloat (centerY + y))
      , strokeWidth strokeWidth_
      , stroke color
      ]
      []