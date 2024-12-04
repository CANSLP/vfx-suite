extends Node3D

var time = 0.0
var mat_blast : Material

# Called when the node enters the scene tree for the first time.
func _ready():
	time = 0
	
	mat_blast = $blast.material_override
	mat_blast = mat_blast.duplicate()
	$blast.material_override = mat_blast
	
	$blast.scale = Vector3(0,0,0)
	$blast.global_rotation = Vector3(0,0,0)
	$rays.emitting = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	$light.light_energy = 25*clamp(pow(2.0*(0.5-time),5.0),0,1)
	
	
	$blast.scale = Vector3(1,1,1)*(1.0+clamp(pow(time*3.0,0.125),0,1)*5.0)
	$blast.global_rotation = Vector3(0,0,0)
	mat_blast.set("shader_parameter/power",clamp(pow(time*3.0,0.25),0,1))
	
	if time > 2.5:
		queue_free()
