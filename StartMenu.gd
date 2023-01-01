extends Node2D
	
func _on_Button_pressed() -> void:
	get_tree().change_scene("res://World.tscn")
	


func _on_Button2_pressed():
	get_tree().change_scene("res://Maps/Map2.tscn")
