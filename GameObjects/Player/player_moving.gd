extends PlayerState
class_name PlayerMoving


func enter() -> void:
	pass


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	if !player.is_on_floor():
		transition_requested.emit(self, PlayerState.State.JUMPING)
		
	if Input.get_vector("left", "right", "up", "down") == Vector2.ZERO:
		transition_requested.emit(self, PlayerState.State.IDLE)
	
	player.handle_movement(delta)
