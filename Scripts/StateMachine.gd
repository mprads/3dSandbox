extends Node
class_name StateMachine

@export var initial_state: PlayerState

var states := {}
var current_state: PlayerState


func init(player: Player) -> void:
	for child in get_children():
		print(child)
		if child is PlayerState:
			states[child.state] = child
			child.transition_requested.connect(_on_transition_requested)
			child.player = player

	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)


func _on_transition_requested(from: PlayerState, to: PlayerState.State) -> void:
	if from != current_state:
		return
		
	var new_state: PlayerState = states[to]
	if !new_state:
		return
		
	if current_state:
		current_state.exit()
		
	new_state.enter()
	current_state = new_state
