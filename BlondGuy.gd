extends Area2D


var active = false 

func _ready():
	connect("body_entered", self, '_on_BlondGuy_body_entered')
	connect("body_excited", self, '_on_BlondGuy_body_exited')

func _process(delta):
	$InteractionMessage.visible = active


func _input(event):
	if event.is_action_pressed("bark") and len(get_overlapping_bodies()) > 0:
		pass


func _on_BlondGuy_body_entered(body):
	if body.name == "Lulu":
		active = true
		
func _on_BlondGuy_body_exited(body):
	if body.name == "Lulu":
		active = false 





