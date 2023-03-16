extends CharacterBody2D

enum States {GROUNDED, AIRBORNE, CLIMBING, ATTACKING}

var input_vector
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

var long_range_attack_enabled = true
const Bullet = preload("res://scenes/player/abilities/Bullet.tscn")

var short_range_attack_enabled = true
const ShortRange = preload("res://scenes/player/abilities/ShortRange.tscn")

const MAX_HEALTH = 100
var health = MAX_HEALTH


func _ready():
	sprite_scale = $Sprite2D.scale
	velocity = Vector2.ZERO


func _physics_process(delta):
	input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	match grounded_state:
		States.AIRBORNE:
			if is_on_floor():
				grounded_state = States.GROUNDED
			air_moving(delta)

		States.GROUNDED:
			if !is_on_floor():
				grounded_state = States.AIRBORNE
				$CoyoteJump/JumpGracePeriod.start()
			ground_moving(delta)
	
	# skills
	if Input.is_action_just_pressed("long_range"):
		long_range_attack()
	if Input.is_action_just_pressed("short_range"):
		short_range_attack()


func change_direction():
	if input_vector.x > 0:
		$Sprite2D.scale.x = -sprite_scale.x
		is_facing_right = true
	elif input_vector.x < 0:
		$Sprite2D.scale.x = sprite_scale.x
		is_facing_right = false


func ground_moving(delta):
	velocity.y += delta * gravity
	change_direction()
	velocity.x = lerp(velocity.x, input_vector.x * ground_speed, friction)
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()
	velocity = velocity
	jumps_remaining = 1
	if Input.is_action_pressed("player_jump"):
		jump()


func air_moving(delta):
	velocity.y += delta * gravity
	change_direction()
	velocity.x = lerp(velocity.x, input_vector.x * ground_speed, air_resistance)
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()
	velocity = velocity
	if !$CoyoteJump/JumpGracePeriod.is_stopped() && !$CoyoteJump/GroundCollisionRayCast2D.is_colliding():
		if Input.is_action_pressed("player_jump") && jumps_remaining > 0:
			jump()


func jump():
	velocity.y = -1 * jump_height
	jumps_remaining -= 1


func long_range_attack():
	if long_range_attack_enabled:
		long_range_attack_enabled = false
		var bullet = Bullet.instantiate()
		if is_facing_right:
			bullet.direction = Vector2.RIGHT
		else:
			bullet.direction = Vector2.LEFT
		bullet.position = position
		get_parent().add_child(bullet)
		$SkillTimers/LongRangeTimer.start()


func short_range_attack():
	if short_range_attack_enabled:
		short_range_attack_enabled = false
		var short_range = ShortRange.instantiate()
		short_range.scale = Vector2(2, 2)
		add_child(short_range)
		move_child(short_range, $Sprite2D.get_index())


func _on_LongRangeTimer_timeout():
	long_range_attack_enabled = true
