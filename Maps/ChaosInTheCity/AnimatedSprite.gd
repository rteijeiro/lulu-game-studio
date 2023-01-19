extends AnimatedSprite

export var speed:int = 60
var velocity:Vector2 = Vector2.ZERO
var direction:int = 1

enum States {
	MOVING,
}

var state = States.MOVING

func _physics_process(_delta: float) -> void:
	self.state = States.RUN
	velocity = Vector2(speed * direction, 0)
	velocity = move_and_slide(velocity)
