module Main exposing ( main )

-- Core Dependencies
import Html exposing
  ( Html
  , br
  , button
  , div
  , p
  , text
  )
import Html.Events exposing ( onClick )

-- Package Dependencies
import History exposing ( History )
import Navigation exposing ( Location )
import Task


-- Model/Msg Types
type alias Base =
  { route : String
  }

type alias Model = History Base

type Msg
  = GoBack
  | Navigate   String
  | Restored   Model
  | Saved      Int
  | UrlChange  Location


-- Update Function
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    GoBack ->
      History.back model Restored

    Navigate url ->
      History.push model url Saved

    Restored backup ->
      let
        yeah = Debug.log "restore succeeded" backup
      in
        backup ! [ Cmd.none ]

    Saved key ->
      let
        yeah = Debug.log "save succeeded" key
      in
        model ! [ Cmd.none ]

    UrlChange _ ->
      model ! [ Cmd.none ]


-- View Functions
buttons : List String
buttons =
  [ "/home"
  , "/about"
  , "/contact"
  , "/portfolio"
  , "/transition"
  , "/notfound"
  ]

renderButton : String -> Html Msg
renderButton button_text =
  button
    [ onClick ( Navigate button_text ) ]
    [ text <| String.dropLeft 1 button_text ]

renderHistory : Model -> Html Msg
renderHistory model =
  div [] [ text <| toString model ]

renderHistoryItem : Base -> Html Msg
renderHistoryItem m =
  p [] [ text <| toString m ]

view : Model -> Html Msg
view model =
  div
    []
    [ div
        []
        ( ( button
            [ onClick GoBack ]
            [ text "Go Back" ]
        ) :: ( List.map renderButton buttons ) )
    , br [] []
    , renderHistory model
    ]


-- Init Function
init : Location -> ( Model, Cmd Msg )
init location =
  ( initModel
  , Cmd.none
  )

initModel : Model
initModel =
  { route = "/"
  , local_history = ( 0, [] )
  }

-- Elm Main
main : Program Never Model Msg
main =
  Navigation.program UrlChange
    { init          = init
    , subscriptions = (\ _ -> Sub.none )
    , update        = update
    , view          = view
    }
