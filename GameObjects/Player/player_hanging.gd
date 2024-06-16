extends PlayerState
class_name PlayerHanging


func enter() -> void:
	player.jump_gravity = 0
	player.fall_gravity = 0
	player.velocity = Vector3.ZERO
	player.disable_hanging_raycast()


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	if Input.is_action_pressed("jump") || Input.is_action_pressed("up"):
		player.handle_mantle(delta)
		transition_requested.emit(self, PlayerState.State.MOVING)
	elif Input.is_action_pressed("down"):
		player.handle_dismount(delta)
		transition_requested.emit(self, PlayerState.State.JUMPING)
