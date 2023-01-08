extends KinematicBody2D


export var speed = 15
var direction = 1


func _physics_process(delta):
	var collision = move_and_collide(Vector2(speed * direction, 0))


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_AreaBullet_area_entered(area):
	if area.get_name() == "HitBox":
		queue_free()
	if area.get_name() == "AreaExplodingBarrel":
		queue_free()
