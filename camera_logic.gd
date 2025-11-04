extends Node3D


@onready var rotation_x = $CameraRotation
@onready var zoom_pivot = $CameraRotation/CameraZoomPivot
@onready var camera = $CameraRotation/CameraZoomPivot/Camera3D

@export var move_speed = 0.4
@export var rotation_speed = 1.5
@export var zoom_speed = 3.0
@export var zoom_max = -20.0
@export var zoom_min = 20.0
@export var mouse_sensitivity = 0.2
@export var mouse_rotation_min = -90
@export var mouse_rotation_max = -10

var zoomt_target: float
var move_target: Vector3
var rotate_target: float
var zoom_target:float

func _unhandled_input(event: InputEvent) -> void:
	#TODO: if not build mode??
	if event is InputEventMouseMotion and Input.is_action_pressed("mouse_rotate"):
		rotate_target -= event.relative.x * mouse_sensitivity
		rotation_x.rotation_degrees.x -= event.relative.y * mouse_sensitivity
		rotation_x.rotation_degrees.x = clamp(rotation_x.rotation_degrees.x, mouse_rotation_min, mouse_rotation_max)

	
func _ready() -> void:
	move_target = position
	rotate_target = rotation_degrees.y
	zoom_target = camera.position.z
	
func _process(delta: float) -> void:
	var input_direction = Input.get_vector("move_camera_left", "move_camera_right", "move_camera_forward", "move_camera_backward")
	var movement_direction = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	var rotate_camera = Input.get_axis("turn_camera_left","turn_camera_right")
	var zoom_direction: int
	#if zoom in with mouse in menu,
	# zoom_direction = Input.get_axis("zoom_camera_out","zoom_camera_in")
	zoom_direction = (int (Input.is_action_just_released("zoom_camera_out")) - int (Input.is_action_just_released("zoom_camera_in")))
	
	
	move_target += move_speed * movement_direction
	rotate_target += rotate_camera * rotation_speed
	zoom_target += zoom_direction *zoom_speed
	zoom_target = clamp(zoom_target, zoom_max, zoom_min)
	
	position = lerp(position, move_target, 0.05)
	rotation_degrees.y = lerp(rotation_degrees.y, rotate_target, 0.05)
	camera.position.z = lerp(camera.position.z, zoom_target, 0.10)
	
