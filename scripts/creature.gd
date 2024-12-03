class_name Creature extends RigidBody3D

var time = 0.0

@export var walk_speed = 0.05

var heat : float = 0.0
var head_mat : Material
var face_mat : Material

@export var tx_face_idle : Texture
@export var tx_face_hurt : Texture

var shot = false
var hurt = false

var pk_burst : PackedScene = preload("uid://8emqxmwg8tar")

var player : Player

# Called when the node enters the scene tree for the first time.
func _ready():
	var players = get_tree().get_nodes_in_group("player")
	if len(players) > 0:
		player = players[0]
	
	walk_speed *= remap(randf(),0,1,0.9,1.1)
	
	head_mat = $head/Icosphere.material_override
	head_mat = head_mat.duplicate()
	$head/Icosphere.material_override = head_mat
	
	face_mat = $head/face/tx.material_override
	face_mat = face_mat.duplicate()
	$head/face/tx.material_override = face_mat


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	
	if player != null:
		$head/face.look_at(player.global_position+Vector3(0,0.5,0),Vector3(0,1,0))
	
	if shot:
		hurt = true
		shot = false
		heat += delta
	else:
		hurt = false
		heat -= delta*0.5
	heat = clamp(heat,0,1)
	
	$head.position.y = 0.5+sin(time*2.5)*0.1
	$head/Icosphere.rotation += Vector3(1,1,0)*delta
	
	$head/Icosphere.set_blend_shape_value(0,heat)
	$head/Icosphere.scale = Vector3(1,1,1)*(1+0.25*pow(heat,5.0))
	head_mat.set("shader_parameter/glow",pow(heat,3.0))
	$head/light.light_energy = pow(heat,5.0)*2.5
	face_mat.set("shader_parameter/color",Vector3(0.5+heat,3,3))
	if hurt:
		face_mat.set("shader_parameter/mask",tx_face_hurt)
	else:
		face_mat.set("shader_parameter/mask",tx_face_idle)
	
	if heat == 1:
		var fx = pk_burst.instantiate()
		fx.global_transform = $head.global_transform
		get_parent().add_child(fx)
		queue_free()

func _integrate_forces(state):
	state.linear_velocity *= Vector3(0.99,1.0,0.99)
	if player != null:
		state.linear_velocity += ((player.global_position-global_position)*Vector3(1,0.25,1)).normalized()*walk_speed*(1-heat)
	

func shoot():
	shot = true
