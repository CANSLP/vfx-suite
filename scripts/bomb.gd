extends RigidBody3D
class_name Bomb

@export var fuse : float = 3.0
var max_fuse : float = 3.0
var charge : float = 0.0

var mat_seam : Material

var pk_fx : PackedScene = preload("uid://8emqxmwg8tar")


# Called when the node enters the scene tree for the first time.
func _ready():
	max_fuse = fuse
	mat_seam = $mesh/seam_fx.material_override
	mat_seam = mat_seam.duplicate()
	$mesh/seam_fx.material_override = mat_seam


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fuse -= delta
	var curve = 5.0
	charge = clamp(0.5+(pow(2.0,curve-1))*pow(0.5-fuse,curve),0,1)
	mat_seam.set("shader_parameter/power",charge);
	mat_seam.set("shader_parameter/brightness",charge*5.0);
	if fuse <= 0:
		var fx = pk_fx.instantiate()
		fx.global_transform = global_transform
		get_parent().add_child(fx)
		queue_free()
