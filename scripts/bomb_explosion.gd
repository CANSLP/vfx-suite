extends Node3D

var time = 0.0
var mat_rims : Material

# Called when the node enters the scene tree for the first time.
func _ready():
	time = 0
	mat_rims = $rims.material_override
	mat_rims = mat_rims.duplicate()
	$rims.material_override = mat_rims
	$rims.scale = Vector3(0,0,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	$light.light_energy = 25*clamp(pow(2.0*(0.5-time),5.0),0,1)
	
	$rims.scale = Vector3(1,1,1)*clamp(pow(time*5.0,0.125),0,1)
	mat_rims.set("shader_parameter/time",clamp(pow(time*5.0,0.125),0,1));
	
	if time > 5.0:
		queue_free()
