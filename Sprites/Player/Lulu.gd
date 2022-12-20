extends KinematicBody2D
class_name Player

# Movement.
export (int) var speed = 250
export (int) var jump_speed = -500
export (int) var gravity = 2000
export (int) var terminal_velocity = 300
var velocity:Vector2 = Vector2.ZERO


# States.
enum States {
	IDLE,
	RUN,
	JUMP,
	SIT,
	POOP,
	BARK,
	WALK,
}
var state = States.IDLE setget set_state


# Actions.
var is_barking:bool = false
var is_jumping:bool = false
var is_pooping:bool = false


# Get input from controller.
func get_input():
	velocity.x = 0
	
	# Moving Right.
	if Input.is_action_pressed("right"):
		$AnimatedSprite.flip_h = false
		velocity.x += speed
		if !is_jumping:
			self.state = States.WALK
	
	# Moving Left.
	if Input.is_action_pressed("left"):
		$AnimatedSprite.flip_h = true
		velocity.x -= speed
		if !is_jumping:
			self.state = States.WALK
			
	# Start Jumping.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			self.state = States.IDLE
			velocity.y = jump_speed	
		else:
			self.state = States.JUMP

	# Stop Jumping.
	if Input.is_action_just_released("jump"):
		self.state = States.IDLE
		
	# Barking.
	if Input.is_action_pressed("bark"):
		self.state = States.BARK
		
	# Poop.
	if Input.is_action_pressed("poop"):
		self.state = States.POOP
		
	# Sit.
	if Input.is_action_pressed("sit"):
		self.state = States.SIT
	
	
# Physics processing.
func _physics_process(delta):
	
	get_input()
	
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	# Detect if player is idle or falling.
	if velocity == Vector2.ZERO and state != States.BARK \
		and state != States.POOP and state != States.SIT:
		self.state = States.IDLE


# States setter.
func set_state(new_state):
	
	match state :
		States.IDLE:
			$AnimationPlayer.play("Idle")
		States.BARK:
			$AnimationPlayer.play("Bark")
		States.SIT:
			$AnimationPlayer.play("Sit")
		States.JUMP:
			$AnimationPlayer.play("Jump")
		States.RUN:
			$AnimationPlayer.play("Run")
		States.WALK:
			$AnimationPlayer.play("Walk")
		States.POOP:
			$AnimationPlayer.play("Poop")
			
	state = new_state


