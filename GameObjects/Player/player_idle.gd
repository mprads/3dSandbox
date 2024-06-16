extends PlayerState
class_name PlayerIdle


func enter() -> void:
	pass


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	if Input.get_vector("left", "right", "up", "down"):
		transition_requested.emit(self, PlayerState.State.MOVING)
	elif Input.is_action_pressed("jump"):
		transition_requested.emit(self, PlayerState.State.JUMPING)

	player.apply_gravity(delta)
