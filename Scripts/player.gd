extends KinematicBody2D

signal die(stock)

export (float) var GRAVITY = 35
export (float) var SPEED = 300 
export (float) var JUMP_HEIGHT = 500

var stock = 3
var jump_count = 0
var velocity = Vector2()
#state
var left_stick_dir = Vector2(Input.get_joy_axis(0, JOY_AXIS_0),Input.get_joy_axis(0, JOY_AXIS_1))
var state
enum {IDLE, DASH, JUMP_1,JUMP_2, JUMP_DOWN}

func _ready():
	change_state(IDLE)

func _physics_process(delta):
	state_loop()
	movement_loop()
	jump_loop()
	move_and_slide(velocity, Vector2(0,-1))
	
func movement_loop():
	var LEFT  = Input.get_action_strength("left")
	var RIGHT = Input.get_action_strength("right")
	var DOWN  = Input.get_action_strength("down")
	var UP    = Input.get_action_strength("up")
	
	if velocity.y <= JUMP_HEIGHT:
		velocity.y += GRAVITY
	velocity.x = RIGHT * SPEED - LEFT * SPEED
	if state in[IDLE,DASH]:
		if velocity.x < 0:
			$Sprite.flip_h = true
		elif velocity.x > 0:
			$Sprite.flip_h = false

		
var can_jump := true

func jump_loop():
	var JUMP  = Input.is_action_just_pressed("jump")
	if can_jump:
		if JUMP and state in [IDLE, DASH, JUMP_1, JUMP_DOWN]:
			velocity.y = -JUMP_HEIGHT
			jump_count += 1
		if jump_count == 1:
			can_jump = false
			jump_count = 0
	if is_on_floor():
		can_jump = true

func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			animation_play("idle")
		DASH:
			animation_play("dash")
		JUMP_1:
			animation_play("jump_up")
		JUMP_2:
			animation_play("jump_up")
		JUMP_DOWN:
			animation_play("jump_down")

func state_loop():
		if state == IDLE and velocity.x != 0:
			change_state(DASH)
		if state == DASH and velocity.x == 0:
			change_state(IDLE)
		if state in [IDLE, DASH] and velocity.y < 0 and not is_on_floor():
			change_state(JUMP_1)
		if not is_on_floor() and velocity.y > 0:
			change_state(JUMP_DOWN)
		if state == JUMP_DOWN and velocity.y < 0:
			change_state(JUMP_2)
		if state in [JUMP_DOWN, JUMP_2, JUMP_DOWN] and is_on_floor():
			change_state(IDLE)
		$Label.text = str(state)
			
func after_die():
	emit_signal("die", stock)
	stock -= 1
	if stock == 0:
		get_parent().get_node("GUI/VBoxContainer2/Game").show()
		get_tree().paused = true
		yield(get_tree().create_timer(2), "timeout")
	if not stock == 0:
		position = Vector2(386, 144)
		while yield(get_tree().create_timer(2),"timeout") or Input.is_action_just_pressed("down"):
			animation_play("idle")
			set_physics_process(false)
		set_physics_process(true)
			
func animation_play(new_anim):
	if $anim.current_animation != new_anim:
		$anim.play(new_anim)
		
func stick_direction_loop():
	var dir = Vector2()

func _on_VisibilityNotifier2D_screen_exited():
	after_die()