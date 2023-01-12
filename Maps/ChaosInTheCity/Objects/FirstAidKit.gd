extends Area2D

func _on_FirstAidKit_body_entered(body):
	if body.name == "FighterPlayer":
		queue_free()
