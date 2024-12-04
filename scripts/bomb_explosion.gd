extends Node3D

var time = 0.0
var mat_rims : Material
var mat_blast : Material

# Called when the node enters the scene tree for the first time.
func _ready():
	time = 0
	
	mat_rims = $rims.material_override
	mat_rims = mat_rims.duplicate()
	$rims.material_override = mat_rims
	$rims.scale = Vector3(0,0,0)
	
	mat_blast = $blast.material_override
	mat_blast = mat_blast.duplicate()
	$blast.material_override = mat_blast
	$blast.scale = Vector3(0,0,0)
	$blast.global_rotation = Vector3(0,0,0)
	
	$smoke.emitting = true
	$rays.emitting = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	$light.light_energy = 25*clamp(pow(2.0*(0.5-time),5.0),0,1)
	
	$rims.scale = Vector3(1,1,1)*clamp(pow(time*5.0,0.5),0,1)
	mat_rims.set("shader_parameter/time",clamp(pow(time*5.0,0.125),0,1));
	mat_rims.set("shader_parameter/brightness",10.0*clamp(pow(time*5.0,0.125),0,1));
	
	$blast.scale = Vector3(1,1,1)*clamp(pow(time*3.0,0.125),0,1)*2.5
	$blast.global_rotation = Vector3(0,0,0)
	mat_blast.set("shader_parameter/time",clamp(pow(time*3.0,0.125),0,1));
	
	if time > 2.5:
		queue_free()


func _area_enter(area):
	if area.get_parent().get_parent() is Creature:
		var vec = (area.global_position-global_position)
		area.get_parent().get_parent().die(vec.normalized()*3.0*(10-vec.length()))
