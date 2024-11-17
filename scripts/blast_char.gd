class_name BlastChar extends MeshInstance3D

@onready var material : Material = material_override
var time : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	time = 0.0
	material = material.duplicate()
	material_override = material


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	if time < 0.25:
		material.set("shader_parameter/power",time*4.0)
	elif time < 5.0:
		material.set("shader_parameter/power",1.0)
	elif time < 8.0:
		material.set("shader_parameter/power",pow((8.0-time)/3.0,0.25))
	else:
		queue_free()
