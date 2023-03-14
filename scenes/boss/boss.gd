extends KinematicBody2D


enum BOSS_STATE {IDLE, RUNNING, ATTACKING}
var curr_state = BOSS_STATE.IDLE
var rng = RandomNumberGenerator.new()


func _physics_process(delta):
	match curr_state:
		BOSS_STATE.IDLE:
			pass
		
		BOSS_STATE.RUNNING:
			pass
		
		BOSS_STATE.ATTACKING:
			pass


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


func _on_StateTimer_timeout():
	change_state()
