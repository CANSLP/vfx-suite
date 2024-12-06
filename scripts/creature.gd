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

@export var pk_burst : PackedScene
@export var pk_head : PackedScene

var player : Player
var hunting = false
var hunt_range = 10.0

var seed : float

var target_position : Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	var players = get_tree().get_nodes_in_group("player")
	if len(players) > 0:
		player = players[0]
	
	seed = randf()
	walk_speed *= remap(randf(),0,1,0.75,1.125)
	
	head_mat = $head/Icosphere.material_override
	head_mat = head_mat.duplicate()
	$head/Icosphere.material_override = head_mat
	
	face_mat = $head/face/tx.material_override
	face_mat = face_mat.duplicate()
	$head/face/tx.material_override = face_mat
	
	$sfx_noise.pitch_scale = randf_range(0.75,1.25)
	$sfx_heat.volume_db = -80


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	
	if hunting and player != null:
		$head/face.look_at(player.get_node("camera").global_position,Vector3(0,1,0))
	
	if !hunting:
		look()
	
	if shot:
		hurt = true
		shot = false
		heat += delta
		hunting = true
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
	face_mat.set("shader_parameter/color",Vector3(1.0+heat,0.58+heat,heat))
	if hurt:
		face_mat.set("shader_parameter/mask",tx_face_hurt)
	else:
		face_mat.set("shader_parameter/mask",tx_face_idle)
	
	if heat == 1:
		var fx = pk_burst.instantiate()
		fx.global_transform = $head.global_transform
		get_parent().add_child(fx)
		queue_free()
	
	if !$sfx_noise.is_playing():
		$sfx_noise.play()
	
	if hurt:
		$sfx_heat.volume_db = lerp($sfx_heat.volume_db,lerp(-40.0,-10.0,heat),delta*30)
	else:
		$sfx_heat.volume_db = lerp($sfx_heat.volume_db,-80.0,delta*5)
	if !$sfx_heat.is_playing():
		$sfx_heat.play()
	
	if player != null:
		var dist = (global_position-player.global_position).length()
		if dist < 5.0:
			player.add_haunt(clamp((6-dist)/5.0,0,1))
	
	if global_position.y < -10:
		queue_free()

func _integrate_forces(state):
	state.linear_velocity *= Vector3(0.99,1.0,0.99)
	target_position = global_position
	if hunting:
		if player != null:
			target_position = player.global_position
			var sp = 1.0
			if seed < 0.5:
				sp = -sp
			var dist = (global_position-player.global_position).length()
			var noise = 1.5 + dist*0.1
			target_position += Vector3(sin((4.0*PI*seed)+time*sp)*noise,0,cos((4.0*PI*seed)+time*sp)*noise)
		state.linear_velocity += ((target_position-global_position)*Vector3(1,0.25,1)).normalized()*walk_speed*(1-heat)
	

func shoot():
	shot = true

func look():
	if player != null:
		if (global_position-player.global_position).length() <=hunt_range:
			var space = get_world_3d().direct_space_state
			var query = PhysicsRayQueryParameters3D.create($head.global_position, player.get_node("camera").global_position)
			query.collide_with_areas = false
			var collision = space.intersect_ray(query)
			if collision:
				var target = collision.collider
				if target is Player:
					hunting = true

func die(vel : Vector3):
	var dead_head = pk_head.instantiate()
	get_parent().add_child(dead_head)
	dead_head.global_position = $head.global_position
	dead_head.global_rotation = $head.global_rotation
	dead_head.get_node("head/face").rotation = $head/face.rotation
	dead_head.linear_velocity = vel
	queue_free()
