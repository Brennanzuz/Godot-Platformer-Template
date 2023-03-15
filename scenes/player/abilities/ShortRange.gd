extends Area2D


const DAMAGE = 6


func _ready():
	$AnimationPlayer.play("Animation")


func _on_ShortRange_body_entered(body):
	body.take_damage(DAMAGE)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Animation":
		get_parent().short_range_attack_enabled = true
		queue_free()
