extends GPUParticles3D


# Called when the node enters the scene tree for the first time.
func _ready():
	rotation_degrees = Vector3(randf(),randf(),randf())*360
