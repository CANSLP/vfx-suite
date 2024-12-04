extends Node3D

@export var pk_grass : PackedScene
@export var blade_count : int = 1500
@export var spawn_radius : float = 25.0

@export var mask_texture : Texture2D
var mask : Image


func _ready() -> void:
	mask = mask_texture.get_image()
	for i in range(blade_count):
		var blade = pk_grass.instantiate()
		var point : Vector3
		var flag = true
		while flag:
			var angle = randf_range(0,2*PI)
			var radius = randf_range(0,spawn_radius)
			point = Vector3(sin(angle)*radius,0,cos(angle)*radius)
			
			var weight = get_weight(point.x,point.z)
			if randf_range(0,1)>weight:
				flag = true
			else:
				var space = get_world_3d().direct_space_state
				var query = PhysicsRayQueryParameters3D.create(point + Vector3(0,1,0),point+Vector3(0,0.1,0))
				query.collide_with_areas = false
				var collision = space.intersect_ray(query)
				
				flag = false
				if collision != null:
					var collider = collision.get("collider")
					if collider:
						#print(collider.get_parent())
						flag = true
			
		add_child(blade)
		blade.global_position = point
		blade.rotation.y = randf_range(0,2*PI)
		blade.scale.y = randf_range(0.25,0.5)

func get_weight(x : float, z : float):
	return mask.get_pixel(remap(x,-25,25,0,1)*1100,remap(z,-25,25,0,1)*1100).r
