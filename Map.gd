extends Node2D

func _ready():
	var resource = preload("res://Dialogue.tres")
	DialogueManager.show_example_dialogue_balloon(\
		"this_is_a_node_title", \
		resource
	)
	
#func move_over_there() -> void:
#	$AnimationPlayer.play("walk")
#	yield($AnimationPlayer, "animation_finished")
