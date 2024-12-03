class_name Player extends RigidBody3D

@export var front_angle = 0
@export var cam_angle = 0

var has_focus = false

var kFORWARD = false
var kBACKWARD = false
var kLEFTWARD = false
var kRIGHTWARD = false
var kCROUCH = false
var kRUN = false
var kJUMP = false
var vLOOK = Vector2(0,0.0)

@export var cam_speed = Vector2(1,1)*30
@export var walk_speed = 1.5
@export var jump_power = 15
@export var gravity = 0.5
@export var friction = Vector3(0.75,1,0.75)
@export var dead_zone = 0.1

var on_ground = false
var crouch = 0

@export var water = false
@export var waterY = -1
var in_water = false

@export var reach = 2
var target = null

var pos_save
var last_pos

var walk_bob = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	get_window().title = "" #set the window title (this should be put somewhere else lol)
	last_pos = position
	$camera/hand.player = self


func _integrate_forces(state):
	get_ground(state) #am i on the ground
	state.linear_velocity *= friction # friction
	var stick = true #ground stuck flag
	
	#get walk direction from input
	var walk_vector = Vector2(0,0)
	if has_focus:
		if(kFORWARD):
			walk_vector += Vector2(0,-1)
		if(kBACKWARD):
			walk_vector += Vector2(0,1)
		if(kLEFTWARD):
			walk_vector += Vector2(1,0)
		if(kRIGHTWARD):
			walk_vector += Vector2(-1,0)
		
		#if there is a walk direction, add walk force
		if(!(walk_vector.x==0&&walk_vector.y==0)):
			var walk_angle = atan2(walk_vector.y,walk_vector.x)
			state.linear_velocity += Vector3(-cos(front_angle+walk_angle)*walk_speed*(1-crouch*0.5),0,sin(front_angle+walk_angle)*walk_speed*(1-crouch*0.5))
			stick = false
			if on_ground:
				walk_bob += (1.0-walk_bob)*0.1
		else:
			walk_bob += (0.0-walk_bob)*0.2
		
		if(on_ground):
			#add jump force
			if(kJUMP):
				if(crouch<0.5):
					stick = false
					state.linear_velocity.y = jump_power
					$sfx_jump.play()
		else:
			walk_bob += (0.0-walk_bob)*0.2
	
	state.linear_velocity += Vector3(0,-gravity,0) #gravity
	
	#water handling (TEMP)
	if(water):
		if(position.y<waterY):
			state.linear_velocity.y *= 0.5
		if(position.y<waterY+1):
			state.linear_velocity.y *= 0.975
			state.linear_velocity.y+=((waterY+1)-position.y)*1
			if !in_water:
				in_water = true
				$sfx_splash_in.play()
	else:
		#stick to the ground (prevent slipping down slopes)
		if (on_ground&&stick):
			state.linear_velocity.y *= 0
			if (state.linear_velocity.length() < dead_zone):
				state.linear_velocity *= 0
				if pos_save == null:
					pos_save = global_position
				else:
					global_position = pos_save
					
		if in_water:
			in_water = false
			$sfx_splash_out.play()
	if water||!(on_ground&&stick):
		pos_save = null
	last_pos = position

func _process(delta):
	#get_ground() #am i on the ground
	
	#camera angle
	if has_focus:
		front_angle += vLOOK.x * delta * cam_speed.x
		cam_angle += vLOOK.y * delta * cam_speed.y
	cam_angle = clamp(cam_angle,-PI/2.0,PI/2.0)
	vLOOK = Vector2(0,0)
	$camera.rotation.y = front_angle
	$camera.rotation.x = cam_angle
	
	#am i in the water (TEMP)
	if(water):
		if(position.y<waterY):
			position.y=waterY
	
	#crouch handling
	var c = crouch
	if(kCROUCH):
		crouch += (1-crouch)*delta*10
		walk_bob += (0-walk_bob)*delta*15
	else:
		crouch += (0-crouch)*delta*10
	if crouch < c:
		var headspace = 2-crouch
		var headcast = clamp(sphere_cast(global_position+Vector3(0,-0.5,0),Vector3(0,1.5,0),0.5).hit_distance+0.5,1,2)
		if headspace > headcast:
			if headcast > 2-crouch:
				crouch = 2-headcast
			else:
				crouch = c
		$camera.position.y = 0.5-crouch
		$collider.shape.set_height(2-crouch)
		$collider.position.y = crouch*-0.5
	else:
		$camera.position.y = 0.5-crouch
		$collider.shape.set_height(2-crouch)
		$collider.position.y = crouch*-0.5
	
	#walk bob
	$camera/hand.walk_bob = walk_bob
	if has_focus:
		$camera/hand.down += (0.0-$camera/hand.down)*delta*15.0
	else:
		$camera/hand.down += (1.0-$camera/hand.down)*delta*15.0
	
	#get the mouse target
	get_target()

#what object is the mouse hovering over
func get_target():
	if target and is_instance_valid(target):
		if(target.has_method("_untarget")):
			target._untarget(self)
	target = null
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create($camera.global_position,
			$camera.global_position - $camera.global_transform.basis.z * reach)
	query.collide_with_areas = true
	var collision = space.intersect_ray(query)
	if collision:
		target = collision.collider.get_parent()
		if(target.has_method("_target")):
			target._target(self)

func get_shoot_target(range : float):
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create($camera.global_position,
			$camera.global_position - $camera.global_transform.basis.z * range)
	query.collide_with_areas = false
	var collision = space.intersect_ray(query)
	if collision:
		return [collision.position,true]
	else:
		return [$camera.global_position - $camera.global_transform.basis.z * range,false]

func get_shoot_areas(range : float):
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create($camera.global_position,
			$camera.global_position - $camera.global_transform.basis.z * range)
	query.collide_with_areas = true
	var collision = space.intersect_ray(query)
	var collider = collision.get("collider")
	if collider != null && collision.collider.collision_layer == 128:
		return collider
	else:
		return null

#click on target
func interact():
	get_target()
	if target:
		if(target.has_method("_clicked")):
			target._clicked(self)

#am i on the ground
func get_ground(state):
	if state.get_contact_count() > 0:
		for contact in range(state.get_contact_count()):
			var cpos = state.get_contact_collider_position(contact)-last_pos
			var clayer = state.get_contact_collider_object(contact).get_collision_layer()
			if cpos.y<-0.6:
				if !on_ground:
					$sfx_land.play()
				on_ground = true
				return
	on_ground = false


func _input(event):
	if event is InputEventMouseMotion:
		vLOOK = Vector2(event.relative.x * -0.0025,event.relative.y * -0.0025)
	if event.is_action_pressed("click"):
		if(has_focus):
			interact()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		has_focus = true
		$sfx_click_in.play()
	if event.is_action_released("click"):
		$sfx_click_out.play()
	if event.is_action_pressed("quit"):
		#get_tree().quit()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		has_focus = false
		$camera/hand.stop_actions()
	if event.is_action_pressed("forward"):
		kFORWARD = true
	if event.is_action_released("forward"):
		kFORWARD = false
	if event.is_action_pressed("backward"):
		kBACKWARD = true
	if event.is_action_released("backward"):
		kBACKWARD = false
	if event.is_action_pressed("leftward"):
		kLEFTWARD = true
	if event.is_action_released("leftward"):
		kLEFTWARD = false
	if event.is_action_pressed("rightward"):
		kRIGHTWARD = true
	if event.is_action_released("rightward"):
		kRIGHTWARD = false
	if event.is_action_pressed("jump"):
		kJUMP = true
	if event.is_action_released("jump"):
		kJUMP = false
	if event.is_action_pressed("crouch"):
		kCROUCH = true
	if event.is_action_released("crouch"):
		kCROUCH = false
	if event.is_action_pressed("run"):
		kRUN = true
	if event.is_action_released("run"):
		kRUN = false

#spherecast return struct
class SphereCastResult:
	var hit_distance: float
	var hit_position: Vector3
	var hit_normal: Vector3
	var hit_collider

#spherecast
func sphere_cast(origin: Vector3, offset: Vector3, radius: float):
	var space: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state as PhysicsDirectSpaceState3D
	
	var shape: = SphereShape3D.new()
	shape.radius = radius
	
	var params: = PhysicsShapeQueryParameters3D.new()
	params.set_shape(shape)
	params.transform = Transform3D.IDENTITY
	params.transform.origin = origin
	params.motion = offset
	
	var castResult = space.cast_motion(params)
	
	var result: = SphereCastResult.new()
	
	result.hit_distance = castResult[0] * offset.length()
	result.hit_position = origin + offset * castResult[0] # needs null check in godot physics
	
	params.transform.origin += offset * castResult[1]

	var collision = space.get_rest_info(params)
	result.hit_normal = collision.get("normal", Vector3.ZERO)

	collision = space.intersect_shape(params, 1)
	#result.hit_collider = collision[0].get("collider")
	
	return result
