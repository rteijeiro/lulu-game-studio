extends KinematicBody2D

var direction = 2.5


func _physics_process(delta: float) -> void:
	
	$AnimatedSprite.play("Running")
	var collision = move_and_collide(Vector2(direction,0))




