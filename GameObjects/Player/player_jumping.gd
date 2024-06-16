extends PlayerState
class_name PlayerJumping


func enter() -> void:
	pass


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	if player.is_on_floor():
		transition_requested.emit(self, PlayerState.State.MOVING)
		
	if player.check_mantle() && player.velocity.y <=0:
		transition_requested.emit(self, PlayerState.State.HANGING)
	
	player.handle_movement(delta)
