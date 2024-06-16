extends Node
class_name PlayerState

signal transition_requested(from: PlayerState, to: State)

enum State {IDLE, MOVING, JUMPING, HANGING}

@export var state: State

var player: Player

func enter() -> void:
	pass


func exit() -> void:
	pass


func update(delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	pass
