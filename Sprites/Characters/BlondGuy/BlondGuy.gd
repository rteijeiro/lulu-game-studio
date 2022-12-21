extends Area2D


var active = false 

func _process(delta):
	$InteractionMessage.visible = active

func _on_BlondGuy_body_entered(body):
	if body.name == "Lulu":
		active = true
		
func _on_BlondGuy_body_exited(body):
	if body.name == "Lulu":
		active = false 





