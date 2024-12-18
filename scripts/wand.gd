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
var mat_corona : Material

# Called when the node enters the scene tree for the first time.
func _ready():
	time = 0
	ani_time = 0
	up = 0
	power = 0
	shooting = false
	
	mat_shell = $beam/shell.material_override
	mat_corona = $corona.material_override
	$impact/rays.emitting = false
	$impact/sfx_impact.volume_db = -80
	$sfx_laser.volume_db = -80


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	position = lerp(Vector3(position.x,-0.3,-0.4),Vector3(position.x,-0.2,-0.5),up)
	
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
				$impact/rays.emitting = true
			else:
				$impact/rays.emitting = false
	else:
		up = lerp(up,0.0,delta*15)
		power = lerp(power,0.0,delta*5)
		rotation_degrees = lerp(rotation_degrees,Vector3(75,0,0),delta*15)
		$beam.visible = false
		$impact/rays.emitting = false
		var beam_osc = (1.0+(sin(time*5.0)+1)*0.5)*up
		$impact/ball.scale = Vector3(1,1,1)*beam_osc*5.0
		$impact/light.light_energy = beam_osc*3.0
	mat_shell.set("shader_parameter/power",power)
	
	mat_corona.set("shader_parameter/power",power)
	
	ani_time += delta*(1.0+up*5.0)
	$crystal.rotation.z = ani_time
	$crystal.position.z = sin(time*5.0)*0.005
	$hilt.rotation.z = -ani_time
	$ring.rotation.z = -ani_time
	
	if shoot_target != null:
		$impact.global_position = shoot_target
	
	if $impact/rays.emitting:
		$impact/sfx_impact.volume_db = lerp($impact/sfx_impact.volume_db,-10.0,delta*30)
	else:
		$impact/sfx_impact.volume_db = lerp($impact/sfx_impact.volume_db,-80.0,delta*5)
	if !$impact/sfx_impact.is_playing():
		$impact/sfx_impact.play()
	
	if shooting:
		$sfx_laser.volume_db = -15
	else:
		$sfx_laser.volume_db = lerp($sfx_laser.volume_db,-80.0,delta*5)
	if !$sfx_laser.is_playing():
		$sfx_laser.play()
