extends Control


func get_viewport_center():
	var transform = get_viewport_transform()
	var scale = transform.get_scale()
	return -transform.origin / scale + get_viewport_rect().size / scale / 2


func _process(delta):
	$CharacterHealthBar.value = get_parent().get_node("Player").health
	$BossHealthBar.value = get_parent().get_node("Boss").health
	position = get_viewport_center() + Vector2(-205, -120)
