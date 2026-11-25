@abstract class_name Rules
extends RefCounted

## A game's rules. They answer five questions about a state and keep no state of their own,
## so they run the same in play, in tests, in bots and in replays. A step never moves a node,
## never waits and never plays a sound.

## The new state and its events after one intent.
@abstract func step(state: GameState, intent: Intent) -> StepResult

## Every intent a seat may make now.
@abstract func legal(state: GameState, seat: StringName) -> Array[Intent]

## What an intent would do, without committing it.
@abstract func preview(state: GameState, intent: Intent) -> StepResult

## The state as one seat may see it.
@abstract func view(state: GameState, seat: StringName) -> GameState

## The state in plain words, for debugging and traces.
@abstract func describe(state: GameState) -> String
