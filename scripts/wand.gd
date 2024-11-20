extends Node3D
class_name Wand

var time : float
var ani_time : float
var up : float
var power : float
var shooting : bool
var hit : bool

var shoot_target : Vector3

var mat_shell : Material

# Called when the node enters the scene tree for the first time.
func _ready():
	time = 0
	ani_time = 0
	up = 0
	power = 0
	shooting = false
	
	mat_shell = $beam/shell.material_override


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	
	position = lerp(Vector3(0,0,0),Vector3(0,0.1,-0.1),up)
	
	if shooting:
		up = lerp(up,1.0,delta*15)
		power = lerp(power,1.0,delta*5)
		if shoot_target != null:
			look_at(shoot_target,Vector3(0,1,0))
			var beam_length = ($beam.global_position-shoot_target).length()/scale.z
			$beam.visible = true
			$beam.scale.z = beam_length
			var beam_osc = (1.0+(sin(time*5.0)+1)*0.5)*power
			$beam.scale.x = beam_osc*0.1
			$beam.scale.y = beam_osc*0.1
			$impact/ball.scale = Vector3(1,1,1)*beam_osc*5.0
			$impact/light.light_energy = beam_osc*3.0
			mat_shell.set("shader_parameter/beam_length",beam_length)
			if hit:
				$impact.visible = true
				$impact.global_position = shoot_target
			else:
				$impact.visible = false
	else:
		up = lerp(up,0.0,delta*15)
		power = lerp(power,0.0,delta*5)
		rotation_degrees = lerp(rotation_degrees,Vector3(90,0,0),delta*15)
		$impact.visible = false
		$beam.visible = false
	mat_shell.set("shader_parameter/power",power)
	
	
	ani_time += delta*(1.0+up*5.0)
	$crystal.rotation.z = ani_time
	$crystal.position.z = sin(time*5.0)*0.005
	$hilt.rotation.z = -ani_time
	$ring.rotation.z = -ani_time
