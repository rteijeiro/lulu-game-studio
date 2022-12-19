extends Area2D


func _input(event):
	if event.is_action_pressed("ui_accept") and len(get_overlapping_bodies()) > 0:
		use_dialogue()

func use_dialogue():
	var resource = preload("res://Dialogues/Dialogue.tres")
	DialogueManager.show_example_dialogue_balloon(\
		"this_is_a_node_title", \
		resource
	)


