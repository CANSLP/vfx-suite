extends Node3D

@export var pf_bomb : PackedScene
@onready var item_bin = get_parent().get_parent().get_parent().get_node("item bin")

enum Items {SWORD,BOMB}
@onready var hand_props = [$sword,$bomb]
@export var hand_item = Items.SWORD:
	set(item):
		hand_item = item
		if update_watch:
			update_hand()
			update_watch = true

var update_watch

var throw_vector = Vector3(1,1,0)

var sword_up_rot = Vector3(90,-90,90)
var sword_down_rot = Vector3(0,0,0)
var sword_rot : Vector3

func _ready():
	update_hand()
	update_watch = true
	sword_rot = sword_up_rot
	$sword.rotation_degrees = sword_rot

func _input(event):
	if event.is_action_pressed("click"):
		match(hand_item):
			Items.BOMB:
				throw_bomb()
			Items.SWORD:
				swing_sword()
	if event.is_action_released("click"):
		match(hand_item):
			Items.BOMB:
				pass
			Items.SWORD:
				unswing_sword()
	if event.is_action_pressed("hand_scroll+"):
		hand_item += 1
	if event.is_action_pressed("hand_scroll-"):
		hand_item -= 1

func _process(delta):
	$sword.rotation_degrees = lerp($sword.rotation_degrees,sword_rot,delta*30)

func update_hand():
	if hand_props != null:
		update_watch = false
		if hand_item < 0:
			hand_item = len(hand_props)-1
		if hand_item > len(hand_props)-1:
			hand_item = 0
		for i in range(len(hand_props)):
			hand_props[i].visible = i==hand_item
	print("update")


func swing_sword():
	sword_rot = sword_down_rot
func unswing_sword():
	sword_rot = sword_up_rot

func throw_bomb():
	var bomb = pf_bomb.instantiate()
	item_bin.add_child(bomb)
	bomb.global_position = global_position
	bomb.linear_velocity = global_basis*throw_vector*10
