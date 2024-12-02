class_name Sword extends Node3D

var swipe_time : float = 0
var swipe_speed : float = 1
var target_height : float = 60
@export var start_angle : float = -70
var target_angle : float
@export var reach_min = -0.2
@export var reach_max = -0.35
var return_height = 45

var target_side : float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	swipe_time = 0.0
	target_angle = start_angle
	rotation_degrees.z = target_height
	$arm.rotation_degrees.y = start_angle

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if swipe_time > 0:
		swipe_time -= delta*swipe_speed
		rotation_degrees.z = lerp(rotation_degrees.z,target_height,delta*30)
	else:
		target_height = return_height
		rotation_degrees.z = lerp(rotation_degrees.z,target_height,delta*10)
	swipe_time = clamp(swipe_time,0,1)
	$arm.rotation_degrees.y = lerp(target_angle,start_angle,swipe_time)
	$arm/model.position.z = lerp(reach_max,reach_min,pow(2*swipe_time-1,2))
	position.y = lerp(-0.25,-0.35,pow(2*swipe_time-1,2))
	position.x = lerp(position.x,target_side,delta*15)

func swipe_to(height : float,angle : float,duration : float,up_height : float,side : float):
	swipe_time = 1.0
	swipe_speed = 1.0/duration
	start_angle = target_angle
	target_angle = angle
	target_height = height
	return_height = up_height
	target_side = side
