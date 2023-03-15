extends KinematicBody2D


# boss states now only determines the animation to be played (found in AnimatedSprite
# assets can be found in Aekashics -> Anubis
# AnimationPlayer now has an empty track of position of AnimatedSprite
# change_state() method changes the curr_state uniformly randomly to another state
# change_state() is activated every 1 second, the time is set by StateTimer
# take damage is called whenever the boss takes damage (from the player)
# IMPORTANT: do not change MAX_HEALTH of Player and Boss. This is because UI health bar values are pegged to health values
# do not change the ordering of UI scene. The script for UI depends on the ordering of UI node in Player node


enum BOSS_STATE {IDLE, RUNNING, ATTACKING}
var curr_state = BOSS_STATE.IDLE
var rng = RandomNumberGenerator.new()

const MAX_HEALTH = 100
var health = MAX_HEALTH


func _ready():
	$AnimationPlayer.play("Animation") # blank for now


func _physics_process(delta):
	match curr_state:
		BOSS_STATE.IDLE:
			$AnimatedSprite.animation = "idle"
		
		BOSS_STATE.RUNNING:
			$AnimatedSprite.animation = "running"
		
		BOSS_STATE.ATTACKING:
			$AnimatedSprite.animation = "attacking"


func change_state():
	match curr_state:
		BOSS_STATE.IDLE:
			var rand_num = rng.randi_range(0, 1)
			match rand_num:
				0:
					curr_state = BOSS_STATE.RUNNING
				1:
					curr_state = BOSS_STATE.ATTACKING
		
		BOSS_STATE.RUNNING:
			var rand_num = rng.randi_range(0, 1)
			match rand_num:
				0:
					curr_state = BOSS_STATE.IDLE
				1:
					curr_state = BOSS_STATE.ATTACKING
		
		BOSS_STATE.ATTACKING:
			var rand_num = rng.randi_range(0, 1)
			match rand_num:
				0:
					curr_state = BOSS_STATE.IDLE
				1:
					curr_state = BOSS_STATE.RUNNING
	
	# debugging
	match curr_state:
		BOSS_STATE.IDLE:
			print("changed state: idle")
		BOSS_STATE.RUNNING:
			print("changed state: running")
		BOSS_STATE.ATTACKING:
			print("changed state: attacking")


func take_damage(damage):
	print("take damage")


func _on_StateTimer_timeout():
	change_state()
