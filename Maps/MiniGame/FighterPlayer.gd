extends KinematicBody2D
class_name FighterPlayer

# Movement.
export (int) var speed = 200
export (int) var jump_speed = -500
export (int) var gravity = 2000
export (int) var terminal_velocity = 300
var velocity:Vector2 = Vector2.ZERO


# States.
enum States {
	IDLE,
	DIVEKICK,
	HURT,
	JAB,
	JUMP,
	JUMPKICK,
	KICK,
	PUNCH,
	WALK
}
var state = States.IDLE setget set_state
onready var animation_state = $AnimationTreeFighter.get("parameters/playback")

## Actions.
var fighter_is_jumping:bool = false


#Get input from controller.
func get_input():
	velocity.x = 0

	# Moving Right.
	if Input.is_action_pressed("right") and state != States.JUMPKICK and state != States.KICK and state != States.PUNCH:
			$AnimatedSprite.flip_h = false
			velocity.x += speed
			if !fighter_is_jumping:
				self.state = States.WALK

	# Moving Left.
	if Input.is_action_pressed("left") and state != States.JUMPKICK and state != States.KICK and state != States.PUNCH:
		$AnimatedSprite.flip_h = true
		velocity.x -= speed
		if !fighter_is_jumping:
			self.state = States.WALK
#
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

	# DiveKicking
	if Input.is_action_pressed("divekick"):
		self.state = States.DIVEKICK

	# Jabbing.
	if Input.is_action_pressed("jab"):
		self.state = States.JAB

	# JumpKick.
	if Input.is_action_pressed("jumpkick"):
		self.state = States.JUMPKICK

	# Kicking.
	if Input.is_action_pressed("kick"):
		self.state = States.KICK

	# Punching.
	if Input.is_action_pressed("punch"):
		self.state = States.PUNCH


# Physics processing.
func _physics_process(delta):

	get_input()

	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

	# Detect if player is idle or walking.
	if velocity == Vector2.ZERO and state != States.DIVEKICK \
		and state != States.JAB and state != States.JUMPKICK and state != States.KICK and state != States.PUNCH:
		self.state = States.IDLE


# States setter.
func set_state(new_state):

	match new_state:
		States.IDLE:
			animation_state.travel("Idle")
		States.DIVEKICK:
			animation_state.travel("DiveKick")
		States.HURT:
			animation_state.travel("Hurt")
		States.JAB:
			animation_state.travel("Jab")
		States.JUMP:
			animation_state.travel("Jump")
		States.JUMPKICK:
			animation_state.travel("JumpKick")
		States.KICK:
			animation_state.travel("Kick")
		States.PUNCH:
			animation_state.travel("Punch")
		States.WALK:
			animation_state.travel("Walk")

	state = new_state

#Finished actions:
func divekicking_finished():
	self.state = States.IDLE

func jabbing_finished():
	self.state = States.IDLE

func jumpkicking_finished():
	self.state = States.IDLE

func kicking_finished():
	self.state = States.IDLE

func punching_finished():
	self.state = States.IDLE
	
