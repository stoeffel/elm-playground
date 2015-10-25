import Undoable exposing (update, view)
import Signal

inbox : Signal.Mailbox Undoable.Action
inbox =
  Signal.mailbox Undoable.NoOp

actions : Signal Undoable.Action
actions =
  inbox.signal

model : Signal Undoable.Model
model =
  Signal.foldp update Undoable.initialModel actions

main = Signal.map (view inbox.address) model
