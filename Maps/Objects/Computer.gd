extends Area2D


var showed:bool = false

func _on_Computer_body_entered(body):
	if body.name == "Lulu" and !showed:
		$InteractionMessage.visible = true
		showed = true
	if body.name == "Lulu" :
		get_tree().change_scene("res://RogueLike.tscn")
	
