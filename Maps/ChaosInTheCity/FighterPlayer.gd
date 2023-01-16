extends KinematicBody2D
class_name FighterPlayer

# Movement.
export (int) var speed = 80
export (int) var speed_gun = 30
export (int) var speed_y = 50
export (int) var speed_y_gun = 15
export (int) var speed_jump = 500
export (int) var gravity = 2000
export (int) var terminal_velocity = 300
var velocity:Vector2 = Vector2.ZERO
var life:int = 5
var direction:Vector2 = Vector2.ZERO

#Hud.
var hud = null

#Movement through Y axis
var motion= Vector2()
var z = 0


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
var state2 = States.IDLEGUN setget set_state2
onready var animation_state_nogun = $AnimationTreeFighter.get("parameters/playback")
onready var animation_state_gun = $AnimationTreeGun.get("arameters/playback")
var animation_state = null

#Bullet
onready var Bullet = preload("res://Maps/ChaosInTheCity/Bullet.tscn")

## Actions.
var fighter_is_jumping:bool = false

func _ready() -> void:  
	randomize()
	hud = get_parent().get_node("Hud")  


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
			$JumpkickZone/CollisionShape2D.position.x = 2.5
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
			$JumpkickZone/CollisionShape2D.position.x = -40
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

		if fighter_is_jumping == true:
			self.state = States.JUMP

		else:
			self.state = States.JUMP
#
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
		$Reload.play()
		$AnimationTreeGun.active = true
		$AnimationTreeFighter.active = false
		
	#Move Right with the Gun:
	if Input.is_action_pressed("rightgun") and self.state != States.SHOOT and $AnimationTreeGun.active:
		velocity.x += speed_gun
		self.state = States.WALKGUN
		$AnimationPlayer.play("WalkGun")
	#Move Left with the Gun:
	if Input.is_action_pressed("leftgun") and self.state != States.SHOOT and $AnimationTreeGun.active:
		velocity.x -= speed_gun
		self.state = States.WALKGUN
		$AnimationPlayer.play("WalkGun")
	#Move Up with the Gun.
	if Input.is_action_pressed("upgun") and self.state != States.SHOOT and $AnimationTreeGun.active:
		velocity.y -= speed_y_gun
		self.state = States.WALKGUN
		$AnimationPlayer.play("WalkGun")
	#Move Down with the Gun.
	if Input.is_action_pressed("downgun") and self.state != States.SHOOT and $AnimationTreeGun.active:
		velocity.y += speed_y_gun
		self.state = States.WALKGUN
		$AnimationPlayer.play("WalkGun")
			
			
	#Back to Fight state:
	if Input.is_action_pressed("fight"):
		$AnimationTreeGun.active = false
		$AnimationTreeFighter.active = true
	#Shoot:
	if Input.is_action_pressed("shoot"):
		$Shoot.play()
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
	#With the Gun:
	if velocity == Vector2.ZERO and state != States.SHOOT:
		self.state = States.IDLEGUN
	

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
			$Kick.play()
			animation_state_nogun.travel("Kick")
		States.PUNCH:
			$Punch.play()
			animation_state_nogun.travel("Punch")
		States.WALK:
			animation_state_nogun.travel("Walk")
		States.HURT:
			animation_state_nogun.travel("Hurt")


	state = new_state
	
func set_state2(new_state2):
	match new_state2:
	
		States.SHOOT:
			animation_state_gun.travel("Shoot")
		States.WALKGUN:
			animation_state_gun.travel("WalkGun")

	state2 = new_state2


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
func hit(hurt):
	if state != States.DEAD and life > 0:
		self.state = States.HURT
	if life <= 0:
		self.state = States.DEAD

#Not hit.
func is_not_hit():
		state = States.IDLE



func _on_HitZone_area_entered(area):
	if area.get_name() == "PunchArea":
		if life > 0:
			$AnimationPlayer.play("Hurt")
			life -= 1
			$Hurt.play()
			hud.update_life(life)
			print(life)
		if life <= 0:
			$Dead.play()
			self.state = States.DEAD
			get_tree().change_scene("res://Maps/ChaosInTheCity/GameOver.tscn")
	if area.get_name() == "WeaponArea":
		if life > 0:
			$AnimationPlayer.play("Hurt")
			life -= 1
			$Hurt.play()
			hud.update_life(life)
		if life <=0:
			$Dead.play()
			self.state = States.DEAD
			get_tree().change_scene("res://Maps/ChaosInTheCity/GameOver.tscn")
	if area.get_name() == "FirstAidKit":
			life += 5
			hud.update_life(life)

#Jump and Kick at the same time
var is_jumpkick setget set_jumpkick, get_jumpkick

func set_jumpkick(value):
	animation_state_nogun.set("parameters/conditions/is_jumpkick/advance_condition", value)
func get_jumpkick():
	animation_state_nogun.get("parameters/conditios/is_jumpkick/advance_condition")




