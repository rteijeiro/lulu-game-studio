extends Node2D


func _ready():
	$Fight.play()
	$AnimationPlayer.play("Letters")
	
func animation_over():
	queue_free()
