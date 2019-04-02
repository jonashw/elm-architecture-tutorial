import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)

-- MAIN
main =
  Browser.sandbox { init = init, update = update, view = view }

-- MODEL
type Status = Empty | UnmatchedPasswords | OK
type alias Model =
  { name : String
  , password : String
  , passwordAgain : String
  , status: Status
  }

init : Model
init =
  Model "" "" "" Empty

-- UPDATE
type Msg
  = Name String
  | Password String
  | PasswordAgain String

update : Msg -> Model -> Model
update msg model =
  let 
    updated = 
      case msg of
        Name name              -> { model | name = name }
        Password password      -> { model | password = password }
        PasswordAgain password -> { model | passwordAgain = password }
    status = 
      case (updated.name, updated.password, updated.passwordAgain) of
      ("",_,_) -> Empty
      (_,"",_) -> Empty
      (_,_,"") -> Empty
      (_,p,pa) ->
        if p == pa
        then OK
        else UnmatchedPasswords
  in {updated | status = status}

-- VIEW

view : Model -> Html Msg
view model =
  Html.form []
    [
      div []
        [ viewInput "text" "Name" model.name Name
        , viewInput "password" "Password" model.password Password
        , viewInput "password" "Re-enter Password" model.passwordAgain PasswordAgain
        , viewValidation model
        ]
    ]

viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
  let 
    extraAttr = 
      if t == "password"
      then [Html.Attributes.autocomplete False]
      else []
  in input ([ type_ t, placeholder p, value v, onInput toMsg ] ++ extraAttr) []

viewValidation : Model -> Html msg
viewValidation model =
  case model.status of
  Empty              -> div [ style "color" "red" ] [ text "All fields required" ]
  UnmatchedPasswords -> div [ style "color" "red" ] [ text "Passwords do not match!" ]
  OK                 -> div [ style "color" "green" ] [ text "OK" ]