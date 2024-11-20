extends Node3D

var player : Player

@export var pf_bomb : PackedScene
@onready var item_bin = get_parent().get_parent().get_parent().get_node("item bin")

enum Items {SWORD,BOMB,WAND}
@onready var hand_props = [$sword,$bomb,$wand]
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
			Items.WAND:
				start_wand()
	if event.is_action_released("click"):
		match(hand_item):
			Items.BOMB:
				pass
			Items.SWORD:
				unswing_sword()
			Items.WAND:
				stop_wand()
	if event.is_action_pressed("hand_scroll+"):
		hand_item += 1
		unswing_sword()
		stop_wand()
	if event.is_action_pressed("hand_scroll-"):
		hand_item -= 1
		unswing_sword()
		stop_wand()
	if event.is_action_pressed("hand_1"):
		hand_item = 0
		unswing_sword()
		stop_wand()
	if event.is_action_pressed("hand_2"):
		hand_item = 1
		unswing_sword()
		stop_wand()
	if event.is_action_pressed("hand_3"):
		hand_item = 2
		unswing_sword()
		stop_wand()

func _process(delta):
	$sword.rotation_degrees = lerp($sword.rotation_degrees,sword_rot,delta*30)
	if $wand.shooting:
		shoot_wand()

func update_hand():
	if hand_props != null:
		update_watch = false
		if hand_item < 0:
			hand_item = len(hand_props)-1
		if hand_item > len(hand_props)-1:
			hand_item = 0
		for i in range(len(hand_props)):
			hand_props[i].visible = i==hand_item


func swing_sword():
	sword_rot = sword_down_rot
func unswing_sword():
	sword_rot = sword_up_rot

func throw_bomb():
	var bomb = pf_bomb.instantiate()
	item_bin.add_child(bomb)
	bomb.global_position = global_position
	bomb.linear_velocity = global_basis*throw_vector*10

func start_wand():
	$wand.shooting = true

func stop_wand():
	$wand.shooting = false
	$wand.hit = false

func shoot_wand():
	var target = player.get_shoot_target(100.0)
	var shoot_target = target[0]
	$wand.shoot_target = target[0]
	$wand.hit = target[1]
