extends Area2D


var active = false 

func _ready():
	connect("body_entered", self, '_on_BlondGuy_body_entered')
	connect("body_excited", self, '_on_BlondGuy_body_exited')

func _process(delta):
	$InteractionMessage.visible = active


func _on_BlondGuy_body_entered(body):
	if body.name == "Lulu":
		active = true
		
func _on_BlondGuy_body_exited(body):
	if body.name == "Lulu":
		active = false 



func _input(event):
	if event.is_action_pressed("bark") and len(get_overlapping_bodies()) > 0:
		use_dialogue()

func use_dialogue():
	var resource = preload("res://Dialogues/Dialogue.tres")
	DialogueManager.show_example_dialogue_balloon(\
		"this_is_a_node_title", \
		resource
	)


