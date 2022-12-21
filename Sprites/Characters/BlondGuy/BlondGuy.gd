extends Area2D

onready var lulu = get_node("/root/World/Lulu")

var showed:bool = false

func _on_BlondGuy_body_entered(body):
	if body.name == "Lulu" and !showed:
		var new_dialog = Dialogic.start('first')
		add_child(new_dialog)
		new_dialog.connect("timeline_end", self, 'after_dialog')
		$InteractionMessage.visible = true
		lulu.set_physics_process(false)
		showed = true
		
func _on_BlondGuy_body_exited(body):
	if body.name == "Lulu":
		$InteractionMessage.visible = false 

func after_dialog(timeline_name):
	lulu.set_physics_process(true)



