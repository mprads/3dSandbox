extends CharacterBody3D
class_name Player

@export var mouse_sensitivity := 0.007

@export_category("Movement Parameters")
@export var jump_peak_time := 0.5
@export var jump_fall_time := 0.5
@export var jump_height := 2.0
@export var jump_distance := 4.0

@onready var camera_pivot: Node3D = $CameraPivot
@onready var smooth_camera: SmoothCamera = %SmoothCamera
@onready var head_raycast: RayCast3D = %HeadRaycast
@onready var hip_raycast: RayCast3D = %HipRaycast
@onready var new_position_raycast: RayCast3D = %NewPositionRaycast

@onready var state_machine: StateMachine = $StateMachine
@onready var state_label: Label = %StateLabel

var jump_gravity := 9.8
var fall_gravity := 5.0
var speed := 5.0
var jump_velocity := 5.0
var mouse_motion := Vector2.ZERO

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	state_machine.init(self)
	_calculate_movement_parameters()


func _physics_process(delta: float) -> void:
	_handle_camera_rotation()
	state_label.text = str(state_machine.current_state)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			mouse_motion = -event.relative * mouse_sensitivity

	if event.is_action_pressed("escape"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func apply_gravity(delta: float) -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	if not is_on_floor():
		if velocity.y >= 0:
			velocity.y -= jump_gravity * delta
		else:
			velocity.y -= fall_gravity * delta 


func handle_movement(delta: float) -> void:
	apply_gravity(delta)
	
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()


func _check_mantle() -> void:
	if head_raycast.is_colliding() && new_position_raycast.is_colliding() && !hip_raycast:
		pass

func _handle_camera_rotation() -> void:
	rotate_y(mouse_motion.x)
	camera_pivot.rotate_x(mouse_motion.y)
	camera_pivot.rotation_degrees.x = clampf(camera_pivot.rotation_degrees.x, -90, 90)
	mouse_motion = Vector2.ZERO


func _calculate_movement_parameters() -> void:
	jump_gravity = (2 * jump_height) / pow(jump_peak_time,2)
	fall_gravity = (2 * jump_height) / pow(jump_fall_time,2)
	jump_velocity = jump_gravity * jump_peak_time
	speed = jump_distance / (jump_peak_time + jump_fall_time)
