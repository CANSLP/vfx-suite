class_name Creature extends RigidBody3D

var heat : float = 0.0
var head_mat : Material

var shot = false

# Called when the node enters the scene tree for the first time.
func _ready():
	head_mat = $head/Icosphere.material_override
	head_mat = head_mat.duplicate()
	$head/Icosphere.material_override = head_mat


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shot:
		shot = false
		heat += delta
	else:
		heat -= delta*0.5
	heat = clamp(heat,0,1)
	$head/Icosphere.set_blend_shape_value(0,heat)
	$head/Icosphere.scale = Vector3(1,1,1)*(1+0.25*pow(heat,5.0))
	head_mat.set("shader_parameter/glow",pow(heat,3.0))
	$head/light.light_energy = pow(heat,5.0)*2.5

func shoot():
	shot = true
