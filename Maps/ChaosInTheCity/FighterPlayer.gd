extends KinematicBody2D
class_name FighterPlayer

# Movement.
export (int) var speed = 80
export (int) var speed_y = 50
export (int) var jump_speed = -500
export (int) var gravity = 2000
export (int) var terminal_velocity = 300
var velocity:Vector2 = Vector2.ZERO


var motion= Vector2()
var z = 0
var GRAVITY = 5

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
	WALK, 
	IDLEGUN,
	WALKGUN,
	SHOOT,
}
var state = States.IDLE setget set_state
onready var animation_state_nogun = $AnimationTreeFighter.get("parameters/playback")
onready var animation_state_gun = $AnimationTreeGun.get("parameters/playback")
var animation_state = null
#

#Bullet
onready var Bullet = preload("res://Maps/ChaosInTheCity/Bullet.tscn")

## Actions.
var fighter_is_jumping:bool = false

#Get input from controller.
func get_input():
	velocity.x = 0
	velocity.y = 0
	motion.y = 0
	z = 0
	
	# Moving Right.
	if Input.is_action_pressed("right") and state != States.JUMPKICK and state != States.KICK and state != States.PUNCH:
			$AnimatedSprite.flip_h = false
			velocity.x += speed
			if !fighter_is_jumping:
				self.state = States.WALK
				if animation_state_gun:
					$AnimationPlayerGun.play("WalkGun")

	# Moving Left.
	if Input.is_action_pressed("left") and state != States.JUMPKICK and state != States.KICK and state != States.PUNCH:
		$AnimatedSprite.flip_h = true
		velocity.x -= speed
		if !fighter_is_jumping:
			self.state = States.WALK
			if animation_state_gun:
					$AnimationPlayerGun.play("WalkGun")

	#Moving Up.
	if Input.is_action_pressed("up") and state != States.JUMPKICK and state != States.KICK and state != States.PUNCH:
		velocity.y -= speed_y
		if !fighter_is_jumping:
			self.state = States.WALK
			if animation_state_gun:
					$AnimationPlayerGun.play("WalkGun")

	# Moving Down.
	if Input.is_action_pressed("down") and state != States.JUMPKICK and state != States.KICK and state != States.PUNCH:
		velocity.y += speed_y
		if !fighter_is_jumping:
			self.state = States.WALK
			if animation_state_gun:
					$AnimationPlayerGun.play("WalkGun")

	# Start Jumping.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			self.state = States.IDLE
			fighter_is_jumping = false
			z = 0
			motion.y = 0
		if fighter_is_jumping == true:
			z += GRAVITY
			motion.y = z
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
	
	if Input.is_action_pressed("shoot"):
		self.state = States.SHOOT
	
	if Input.is_action_pressed("idlegun"):
		$AnimatedSprite.hide()
		$AnimatedSpriteGun.show()
		self.state = States.IDLEGUN
		animation_state = animation_state_gun
	else:
		animation_state = animation_state_nogun


# Physics processing.
func _physics_process(delta):

	get_input()
	shoot()

	velocity = move_and_slide(velocity, Vector2.UP)


	# Detect if player is idle or walking.
	if velocity == Vector2.ZERO and state != States.DIVEKICK \
		and state != States.JAB and state != States.JUMPKICK and state != States.KICK and state != States.PUNCH and state != States.JUMP and state!= States.SHOOT:
		self.state = States.IDLE


# States setter.
func set_state(new_state):

	match new_state:
		States.IDLE:
			animation_state.travel("Idle")
		States.DIVEKICK:
			animation_state.travel("DiveKick")
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
		States.IDLEGUN:
			animation_state.travel("IdleGun")
		States.SHOOT:
			animation_state.travel("Shoot")
		States.WALKGUN:
			animation_state.travel("WalkGun")

	state = new_state

#Finished actions:
func divekicking_finished():
	self.state = States.IDLE

func jabbing_finished():
	self.state = States.IDLE
	
func jumpkicking_finished():
	self.state = States.IDLE
	
var is_kicking = false
func kicking_finished():
	is_kicking = false
	self.state = States.IDLE
	
func jumping_finished():
	self.state = States.IDLE

func shooting_finished():
	self.state =States.IDLEGUN

#Attack
var is_punching = false
func punching_finished():
	is_punching = false
	self.state = States.IDLE


#Shooting
var b
func shoot():
	if Input.is_action_just_pressed("shoot"):
		b = Bullet.instance()
		add_child(b)

#Not hit.
func is_not_hit():
		state = States.IDLE
	


