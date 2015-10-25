module Counter where

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)


-- MODEL

type alias Model = Int

initialModel : Model
initialModel = 0

-- UPDATE

type Action = NoOp | Increment | Decrement

update : Action -> Model -> Model
update action model =
  case action of
    NoOp -> model
    Increment -> model + 1
    Decrement -> model - 1


-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
    div []
      [ button [ onClick address Decrement ] [ text "-" ]
      , div [ countStyle ] [ text (toString model) ]
      , button [ onClick address Increment ] [ text "+" ]
      ]


countStyle : Attribute
countStyle =
  style
    [ ("font-size", "20px")
    , ("font-family", "monospace")
    , ("display", "inline-block")
    , ("width", "50px")
    , ("text-align", "center")
    ]
