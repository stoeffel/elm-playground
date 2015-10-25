module Undoable where

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Counter as Component
import Signal

-- MODEL

type alias Model =
  { past : List ( Component.Model )
  , present : Component.Model
  , future : List ( Component.Model )
  }

initialModel : Model
initialModel =
  { past = []
  , present = Component.initialModel
  , future = []
  }

-- UPDATE

type Action
  = NoOp
  | Update Component.Action
  | Undo
  | Redo


update : Action -> Model -> Model
update action model =
  let
    historyHead l =
      case l of
        (h :: t) -> h
        list -> 0

    historyTail l =
      case l of
        (h :: t) -> t
        list -> list

  in
    case action of
      NoOp -> model
      Update act ->
        { model |
            past <- model.present :: model.past
          , present <- Component.update act model.present
          , future <- []
        }
      Undo ->
        if List.length model.past > 0 then
          { model |
              past <- historyTail model.past
            , present <- historyHead model.past
            , future <- model.present :: model.future
          }
        else model
      Redo ->
        if List.length model.future > 0 then
          { model |
              past <- model.present :: model.past
            , present <- historyHead model.future
            , future <- historyTail model.future
          }
        else model

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  let
    pastLength = toString (List.length model.past)
    futureLength = toString (List.length model.future)
  in
    div []
      [ button [ onClick address Undo ] [ text ( "undo " ++ pastLength ) ]
      , button [ onClick address Redo ] [ text ( "redo " ++ futureLength ) ]
      , Component.view (Signal.forwardTo address Update) model.present
      ]

