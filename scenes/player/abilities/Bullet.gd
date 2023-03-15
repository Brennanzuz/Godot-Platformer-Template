extends Area2D


const DAMAGE = 3
const SPEED = 7
var direction


func _ready():
	if direction == Vector2.LEFT:
		$AnimatedSprite.flip_h = true


func _physics_process(delta):
	position += SPEED * direction


func _on_Bullet_body_entered(body):
	body.take_damage(DAMAGE)
	queue_free()


func _on_ExistTimer_timeout():
	queue_free()
