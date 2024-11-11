extends Node3D

@export var pf_bomb : PackedScene
@onready var item_bin = get_parent().get_parent().get_parent().get_node("item bin")

func throw_bomb():
	var bomb = pf_bomb.instantiate()
	item_bin.add_child(bomb)
	bomb.global_position = global_position
	bomb.linear_velocity = -global_basis.z*10

func _input(event):
	if event.is_action_pressed("click"):
		throw_bomb()
