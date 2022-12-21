extends Area2D

func _on_BlondGuy_body_entered(body):
	if body.name == "Lulu":
		var new_dialog = Dialogic.start('first')
		add_child(new_dialog)
		new_dialog.connect("timeline_end", self, 'after_dialog')
		$InteractionMessage.visible = true
		
	
		
func _on_BlondGuy_body_exited(body):
	if body.name == "Lulu":
		$InteractionMessage.visible = false 


func after_dialog(timeline_name):
	print("You can resume with the game")



