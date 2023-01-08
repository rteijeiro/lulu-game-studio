extends KinematicBody2D
class_name FighterPlayer

# Movement.
export (int) var speed = 80
export (int) var speed_y = 50
export (int) var jump_speed = -500
export (int) var gravity = 2000
export (int) var terminal_velocity = 300
var velocity:Vector2 = Vector2.ZERO
var life:int = 5
var direction:Vector2 = Vector2.ZERO

# HUD.
#var hud = null

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
	DEAD
}
var state = States.IDLE setget set_state
onready var animation_state_nogun = $AnimationTreeFighter.get("parameters/playback")
onready var animation_state_gun = $AnimationTreeGun.get("arameters/playback")
var animation_state = null

#Bullet
onready var Bullet = preload("res://Maps/ChaosInTheCity/Bullet.tscn")

## Actions.
var fighter_is_jumping:bool = false

#func _ready() -> void:  
#	randomize()
#	hud = get_parent().get_node("HUD")	    


#Get input from controller.
func get_input():
	velocity.x = 0
	velocity.y = 0
	motion.y = 0
	z = 0
	
	# Moving Right.
	if Input.is_action_pressed("right") and state != States.JUMPKICK and state != States.KICK and state != States.PUNCH:
			$AnimatedSprite.flip_h = false
			$KickZone/CollisionShape2D.position.x = 33
			$PunchZone/CollisionShape2D.position.x = 36
			velocity.x += speed
			if !fighter_is_jumping:
				self.state = States.WALK
				if animation_state_gun:
					$AnimationPlayer.play("WalkGun")
				if animation_state_nogun:
					$AnimationPlayer.play("Walk")

	# Moving Left.
	if Input.is_action_pressed("left") and state != States.JUMPKICK and state != States.KICK and state != States.PUNCH:
		$AnimatedSprite.flip_h = true
		$KickZone/CollisionShape2D.position.x = -66
		$PunchZone/CollisionShape2D.position.x = -72
		velocity.x -= speed
		if !fighter_is_jumping:
			self.state = States.WALK
			if animation_state_gun:
					$AnimationPlayer.play("WalkGun")
			if animation_state_nogun:
					$AnimationPlayer.play("Walk")

	#Moving Up.
	if Input.is_action_pressed("up") and state != States.JUMPKICK and state != States.KICK and state != States.PUNCH:
		velocity.y -= speed_y
		if !fighter_is_jumping:
			self.state = States.WALK
			if animation_state_gun:
					$AnimationPlayer.play("WalkGun")
			if animation_state_nogun:
					$AnimationPlayer.play("Walk")

	# Moving Down.
	if Input.is_action_pressed("down") and state != States.JUMPKICK and state != States.KICK and state != States.PUNCH:
		velocity.y += speed_y
		if !fighter_is_jumping:
			self.state = States.WALK
			if animation_state_gun:
					$AnimationPlayer.play("WalkGun")
			if animation_state_nogun:
					$AnimationPlayer.play("Walk")

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
	
#Change AnimationTrees:
	if Input.is_action_just_pressed("gun"):
		$AnimationTreeGun.active = true
		$AnimationTreeFighter.active = false
	if Input.is_action_pressed("fight"):
		$AnimationTreeGun.active = false
		$AnimationTreeFighter.active = true

	if Input.is_action_pressed("shoot"):
		self.state = States.SHOOT

# Physics processing.
func _physics_process(delta):

	get_input()
	shoot()


	velocity = move_and_slide(velocity, Vector2.UP)


	# Detect if player is idle or walking.
	if velocity == Vector2.ZERO and state != States.DIVEKICK \
		and state != States.JAB and state != States.JUMPKICK and state != States.KICK and state != States.PUNCH and state != States.JUMP and state!= States.SHOOT and state != States.HURT:
		self.state = States.IDLE


# States setter.
func set_state(new_state):

	match new_state:
		States.IDLE:
			animation_state_nogun.travel("Idle")
		States.DIVEKICK:
			animation_state_nogun.travel("DiveKick")
		States.JAB:
			animation_state_nogun.travel("Jab")
		States.JUMP:
			animation_state_nogun.travel("Jump")
		States.JUMPKICK:
			animation_state_nogun.travel("JumpKick")
		States.KICK:
			animation_state_nogun.travel("Kick")
		States.PUNCH:
			animation_state_nogun.travel("Punch")
		States.WALK:
			animation_state_nogun.travel("Walk")
		States.HURT:
			animation_state_nogun.travel("Hurt")
#		States.SHOOT:
#			animation_state_gun.travel("Shoot")
#		States.WALKGUN:
#			animation_state_gun.travel("WalkGun")

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


#Is Hit.
func is_hit(hurt):
	if state != States.DEAD and life > 0:
		self.state = States.HURT
		life -= hurt
#		hud.update_life(life)
	if life <= 0:
		self.state = States.DEAD


#Not hit.
func is_not_hit():
		state = States.IDLE


func get_life(value):
	life += value
	if life > 5:
		life = 5
		
#	hud.update_life(life)


func _on_HitZone_area_entered(area):
	if area.get_name() == "PunchArea":
		self.state = States.HURT