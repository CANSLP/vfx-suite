extends Node3D

@export var pf_bomb : PackedScene
@onready var item_bin = get_parent().get_parent().get_parent().get_node("item bin")
var throw_vector = Vector3(1,1,0)

func throw_bomb():
	var bomb = pf_bomb.instantiate()
	item_bin.add_child(bomb)
	bomb.global_position = global_position
	bomb.linear_velocity = global_basis*throw_vector*10

func _input(event):
	if event.is_action_pressed("click"):
		throw_bomb()
