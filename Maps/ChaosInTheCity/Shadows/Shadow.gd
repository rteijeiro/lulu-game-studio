extends Sprite


func _process(delta):
	global_position = get_parent().get_parent().get_node("FighterPlayer/CollisionShape2D").global_position
	if get_parent().get_parent().get_node("FighterPlayer").life <= 0:
		queue_free()


