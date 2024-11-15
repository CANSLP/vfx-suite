extends Node3D
class_name Wand

var time : float
var ani_time : float
var up : float
var shooting : bool
var hit : bool

var shoot_target : Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	time = 0
	ani_time = 0
	up = 0
	shooting = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	
	position = lerp(Vector3(0,0,0),Vector3(0,0.1,-0.1),up)
	
	if shooting:
		up = lerp(up,1.0,delta*15)
		if shoot_target != null:
			look_at(shoot_target,Vector3(0,1,0))
			$beam.visible = true
			$beam.scale.z = ($beam.global_position-shoot_target).length()/scale.z
			if hit:
				$indicator.visible = true
				$indicator.global_position = shoot_target
			else:
				$indicator.visible = false
	else:
		up = lerp(up,0.0,delta*15)
		rotation_degrees = lerp(rotation_degrees,Vector3(90,0,0),delta*15)
		$indicator.visible = false
		$beam.visible = false

	
	ani_time += delta*(1.0+up*5.0)
	$crystal.rotation.z = ani_time
	$crystal.position.z = sin(time*5.0)*0.005
	$hilt.rotation.z = -ani_time
	$ring.rotation.z = -ani_time
