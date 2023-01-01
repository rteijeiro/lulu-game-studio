extends Node2D


func _ready():
	if randi() % 2 == 0:
		$TextureRect.texture = load("res://Sprites/VRGlasses/Glasses1.png")
	else:
		$TextureRect.texture = load("res://Sprites/VRGlasses/Glasses2.png")
