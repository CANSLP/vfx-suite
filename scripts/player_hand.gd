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

var hand_side = 1
var throw_vector = Vector3(-0.1*hand_side,0,-1)

var walk_bob : float = 0.0

var time = 0

var down = 0.0

func _ready():
	update_hand()
	update_watch = true

func _input(event):
	if event.is_action_pressed("click") and player.has_focus:
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
		stop_actions()
	if event.is_action_pressed("hand_scroll-"):
		hand_item -= 1
		stop_actions()
	if event.is_action_pressed("hand_1"):
		hand_item = 0
		stop_actions()
	if event.is_action_pressed("hand_2"):
		hand_item = 1
		stop_actions()
	if event.is_action_pressed("hand_3"):
		hand_item = 2
		stop_actions()

func stop_actions():
	unswing_sword()
	stop_wand()

func _process(delta):
	time += delta
	rotation_degrees.z = sin(time*15.0)*walk_bob*2.5
	position.y = sin(time*15.0)*walk_bob*0.025-down
	if $wand.shooting:
		shoot_wand()
	$bomb.position.x = lerp($bomb.position.x,0.4*hand_side,delta*30)
	$wand.position.x = lerp($wand.position.x,0.3*hand_side,delta*30)

func update_hand():
	if hand_props != null:
		update_watch = false
		if hand_item < 0:
			hand_item = len(hand_props)-1
		if hand_item > len(hand_props)-1:
			hand_item = 0
		for i in range(len(hand_props)):
			hand_props[i].visible = (i==hand_item)


func swing_sword():
	hand_side = -hand_side
	$sword.swipe_to(-20*hand_side,-70*hand_side,0.1,60*hand_side,hand_side)
	var areas = player.get_shoot_areas(1.0)
	if areas != null:
		areas.get_parent().get_parent().die((hand_side*global_basis.x-global_basis.z)*10)

func unswing_sword():
	#sword_rot = sword_up_rot
	pass

func throw_bomb():
	var bomb = pf_bomb.instantiate()
	item_bin.add_child(bomb)
	bomb.global_position = $bomb.global_position
	bomb.linear_velocity = ((global_basis*throw_vector)+Vector3(0,0.5,0))*10

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
	var areas = player.get_shoot_areas((target[0]-$wand.global_position).length())
	if areas != null:
		areas.get_parent().get_parent().shoot()
