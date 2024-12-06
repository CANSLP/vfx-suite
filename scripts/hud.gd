extends CanvasLayer

var player : Player
var has_moved = false
var has_swapped = false
var has_scrolled = false

var timer = 5.0
var prompt = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (player.global_position-Vector3(0,2,0)).length() > 1.0:
		#if !has_moved:
		#	print("moved")
		has_moved = true
	if player.get_node("camera/hand").has_swapped:
		#if !has_swapped:
		#	print("swapped")
		has_swapped = true
	if player.get_node("camera/hand").has_scrolled:
		#if !has_scrolled:
		#	print("scrolled")
		has_scrolled = true
	
	if prompt:
		if !has_moved:
			$prompt_move.visible = true
		else:
			if $prompt_move.visible:
				$prompt_move.visible = false
				prompt = false
				timer = 5.0
			else:
				if !has_swapped:
					$prompt_swap.visible = true
				else:
					if $prompt_swap.visible:
						$prompt_swap.visible = false
						prompt = false
						timer = 5.0
					else:
						if !has_scrolled:
							$prompt_scroll.visible = true
						else:
							if $prompt_scroll.visible:
								$prompt_scroll.visible = false
								prompt = false
								timer = 5.0
	else:
		$prompt_move.visible = false
		$prompt_swap.visible = false
		$prompt_scroll.visible = false
		if timer < 0.0:
			prompt = true
	
	timer -= delta
