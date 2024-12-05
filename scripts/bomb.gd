extends RigidBody3D
class_name Bomb

@export var fuse : float = 2.0
var max_fuse : float = 3.0
var charge : float = 0.0

var mat_seam : Material

var pk_fx : PackedScene = preload("uid://8emqxmwg8tar")
var pk_char : PackedScene = preload("uid://cxh6lrc0xbdt1")

var on_ground = false

# Called when the node enters the scene tree for the first time.
func _ready():
	max_fuse = fuse
	mat_seam = $mesh/seam_fx.material_override
	mat_seam = mat_seam.duplicate()
	$mesh/seam_fx.material_override = mat_seam

func _integrate_forces(state):
	on_ground = false
	if state.get_contact_count() > 0:
		for contact in range(state.get_contact_count()):
			var collider = state.get_contact_collider_object(contact)
			if collider:
				var clayer = collider.get_collision_layer()
				if clayer != 128:
					on_ground = true
	if on_ground:
		state.linear_velocity *= Vector3(0.95,1.0,0.95)

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
		var char = pk_char.instantiate()
		char.global_transform = global_transform
		get_parent().add_child(char)
		queue_free()
