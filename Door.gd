extends Area2D



func _on_Door_body_entered(body):
	get_tree().change_scene("res://World.tscn")
