extends KinematicBody2D

export var speed:int = 300
var velocity:Vector2 = Vector2.ZERO
var direction:int = 1

enum States {
	MOVING,
}

var state = States.MOVING


func _physics_process(_delta: float) -> void:
	$Scooter.play()
	self.state = States.MOVING
	velocity = Vector2(speed * direction, 0)
	velocity = move_and_slide(velocity)
	

func _on_Timer_timeout():
	$AnimatedSprite.flip_h = !$AnimatedSprite.flip_h
	direction *= -1
	$Scooter.stream_paused = false
	
		
func _on_VisibilityNotifier2D_screen_exited():
	$Scooter.stream_paused = true
	$Timer.start(2)






