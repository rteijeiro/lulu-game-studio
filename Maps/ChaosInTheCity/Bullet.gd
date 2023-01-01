extends KinematicBody2D


export var speed = 5
var direction = 1


func _physics_process(delta):
	var collision = move_and_collide(Vector2(speed * direction, 0))
#	if collision:
#		if collision.collider.name == "Enemy":
#
#		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
