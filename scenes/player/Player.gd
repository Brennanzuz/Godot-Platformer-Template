extends KinematicBody2D

enum States {GROUNDED, AIRBORNE, CLIMBING, ATTACKING}

var input_vector
var velocity = Vector2.ZERO
var is_facing_right = false
var grounded_state = States.AIRBORNE
var jumps_remaining

var ground_speed = 200
var air_speed = ground_speed * 0.5
var jump_height = 300
var friction = 1
var air_resistance = 1
var gravity = 981

var sprite_scale

func _ready():
	sprite_scale = $Sprite.scale

func _physics_process(delta):
	input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	match grounded_state:
		States.AIRBORNE:
			if is_on_floor():
				grounded_state = States.GROUNDED
				continue
			air_moving(delta)

		States.GROUNDED:
			if !is_on_floor():
				grounded_state = States.AIRBORNE
				$CoyoteJump/JumpGracePeriod.start()
				continue
			ground_moving(delta)
			
func change_direction():
	if input_vector.x > 0:
		$Sprite.scale.x = -sprite_scale.x
		is_facing_right = true
	elif input_vector.x < 0:
		$Sprite.scale.x = sprite_scale.x
		is_facing_right = false

func ground_moving(delta):
	velocity.y += delta * gravity
	change_direction()
	velocity.x = lerp(velocity.x, input_vector.x * ground_speed, friction)
	velocity = move_and_slide(velocity, Vector2.UP)
	jumps_remaining = 1
	if Input.is_action_pressed("player_jump"):
		jump()

func air_moving(delta):
	velocity.y += delta * gravity
	change_direction()
	velocity.x = lerp(velocity.x, input_vector.x * ground_speed, air_resistance)
	velocity = move_and_slide(velocity, Vector2.UP)
	if !$CoyoteJump/JumpGracePeriod.is_stopped() && !$CoyoteJump/GroundCollisionRayCast2D.is_colliding():
		if Input.is_action_pressed("player_jump") && jumps_remaining > 0:
			jump()

func jump():
	velocity.y = -1 * jump_height
	jumps_remaining -= 1
