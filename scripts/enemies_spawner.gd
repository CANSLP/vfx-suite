extends Node3D

var spawning : bool = false

var spawn_count = 5.0

var timer : float

@export var spawn_delay = 5.0

@export var pk_creature : PackedScene

func _ready():
	spawning = false
	timer = spawn_delay


func _process(delta):
	var enemies = get_children()
	var count = len(enemies)
	#print(count)
	if spawning:
		if timer <= 0:
			if count < spawn_count:
				spawn()
				timer = spawn_delay
				if randf() < 0.25:
					spawn_count += 1
					#print(spawn_count)
	else:
		if count < 4:
			spawning = true
			timer = spawn_delay
			#print("start")
	timer -= delta

func spawn():
	print("spawn")
	var creature = pk_creature.instantiate()
	creature.get_node("head/smoke").emitting = false
	add_child(creature)
	creature.rotation.y = randf_range(0,2*PI)
	creature.global_position = Vector3(0,1,0)
	creature.global_position -= creature.global_basis.z * 25
	creature.hunting = true
	creature.get_node("head/smoke").emitting = true
	
