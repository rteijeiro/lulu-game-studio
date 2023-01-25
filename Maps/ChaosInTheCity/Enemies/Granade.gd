extends KinematicBody2D


export var speed = 5
var direction = -1

func _physics_process(delta):
	move_and_collide(speed * direction)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
 

func _on_GranadeArea_area_entered(area):
	if area.get_name() == "HitZone":
		queue_free()
