class_name Sword extends Node3D

var swipe_time : float = 0
var swipe_speed : float = 1
var target_height : float = 60
@export var start_angle : float = -70
var target_angle : float
@export var reach_min = -0.2
@export var reach_max = -0.35
var return_height = 60

var target_side : int = 1

var mat_sweep : Material

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	swipe_time = 0.0
	target_angle = start_angle
	rotation_degrees.z = target_height
	$arm.rotation_degrees.y = start_angle
	
	mat_sweep = $arm/model/sweep_plane.material_override

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
	position.x = lerp(position.x,target_side*0.15,delta*15)
	$arm/model/sweep_plane.position.x = -10*target_side
	$arm/model/sweep_plane.scale.x = -target_side
	
	mat_sweep.set("shader_parameter/power",1-pow(2*swipe_time-1,2))

func swipe_to(height : float,angle : float,duration : float,up_height : float,side : int):
	swipe_time = 1.0
	swipe_speed = 1.0/duration
	start_angle = target_angle
	target_angle = angle
	target_height = height
	return_height = up_height
	target_side = side
