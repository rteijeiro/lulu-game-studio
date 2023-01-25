extends KinematicBody2D

export var speed:int = 250
var velocity:Vector2 = Vector2.ZERO
var direction:int = 1

enum States {
	MOVING,
}

var state = States.MOVING


func _physics_process(_delta: float) -> void:
	self.state = States.MOVING
	velocity = Vector2(speed * direction, 0)
	velocity = move_and_slide(velocity)
	
#func is_moving():
#	state = States.MOVING


func _on_Timer_timeout():
	$AnimatedSprite.flip_h = true
	direction = -1

func _on_VisibilityNotifier2D_screen_exited():
	$Timer.start(5)
	direction = 0




