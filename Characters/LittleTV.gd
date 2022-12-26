extends KinematicBody2D

export var speed:int = 30
var velocity:Vector2 = Vector2.ZERO
var direction:int = 1

enum States {
	RUN,
}

var state = States.RUN

func _physics_process(_delta: float) -> void:
	self.state = States.RUN
	velocity = Vector2(speed * direction, 0)
	velocity = move_and_slide(velocity)
	if !$FloorCast.is_colliding():
		self.state = States.RUN
		direction *= -1
		check_direction()
	

func check_direction():
	if direction > 0: # Move right.
		$AnimatedSprite.flip_h = false
		$FloorCast.position.x = 17
		
	else: # Move left.
		$AnimatedSprite.flip_h = true
		$FloorCast.position.x = -3

