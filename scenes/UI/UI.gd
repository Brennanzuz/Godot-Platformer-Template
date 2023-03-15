extends Control


func _process(delta):
	$CharacterHealthBar.value = get_parent().get_node("Player").health
	$BossHealthBar.value = get_parent().get_node("Boss").health
	rect_position = get_parent().get_node("Player/Camera2D").get_camera_screen_center() + Vector2(-205, -120)
