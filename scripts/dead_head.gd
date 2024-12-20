extends RigidBody3D

var last_pos : Vector3

var timer = 0.0
var smashed = false
var last_vel : Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	$smoke.emitting = true
	last_pos = global_position
	last_vel = linear_velocity

func _process(delta):
	if smashed:
		timer += delta
		if timer > 5.0:
			queue_free()
	if global_position.y < -10:
		smashed = true

func _integrate_forces(state):
	if state.get_contact_count() > 0:
		for contact in range(state.get_contact_count()):
			var cpos = state.get_contact_collider_position(contact)-last_pos
			var clayer = state.get_contact_collider_object(contact).get_collision_layer()
			if clayer != 128:
				smash(state.get_contact_collider_position(contact),last_vel,-cpos.normalized())
	last_pos = global_position
	last_vel = linear_velocity

func smash(point : Vector3,vel : Vector3,normal : Vector3):
	$head.visible = false
	$smoke.emitting = false
	freeze = true
	$collision.queue_free()
	$smash_fx.global_position = point
	$smash_fx.look_at((normal)+(point))
	#$smash_fx.initial_velocity_max = vel.length()*1.5
	$smash_fx.emitting = true
	smashed = true
	$sfx_smash.pitch_scale = randf_range(0.9,1.25)
	$sfx_smash.play()
