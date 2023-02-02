extends KinematicBody2D
class_name FighterPlayer

# Movement.
export (int) var speed = 100
export (int) var speed_y = 80
export (int) var speed_jump = 500
export (int) var gravity = 2000
export (int) var terminal_velocity = 300
var velocity:Vector2 = Vector2.ZERO
var life:int = 5
var bullets:int = 0
var direction:Vector2 = Vector2.ZERO

#Hud.
var hud = null
var hudbullets = null

#Movement through Y axis
var motion= Vector2()
var z = 0

# States.
enum States {
	FALL,
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
	IDLESTICK,
	STICKATTACK,
	WALKSTICK,
	IDLETASER,
	TASERATTACK,
	WALKTASER,
	DEAD
}

#IDLE states(4 AnimationTrees)
var state = States.IDLE setget set_state
var stateGun = States.IDLEGUN setget set_stateGun
var stateStick = States.IDLESTICK setget set_stateStick
var stateTaser = States.IDLETASER setget set_stateTaser
onready var animation_state_nogun = $AnimationTreeFighter.get("parameters/playback")
onready var animation_state_gun = $AnimationTreeGun.get("parameters/playback")
onready var animation_state_stick = $AnimationTreeStick.get("parameters/playback")
onready var animation_state_taser = $AnimationTreeTaser.get("parameters/playback")
var animation_state = null

#Bullet
onready var Bullet = preload("res://Maps/ChaosInTheCity/Weapons/Bullet.tscn")

#Actions.
var fighter_is_jumping:bool = false
	
#Ready.
func _ready() -> void:  
	randomize()
	hud = get_parent().get_node("Hud")  

	hudbullets = get_parent().get_node("HudBullets")
	
	#Limit of the Camera
	var tilemap_rect = get_parent().get_parent().get_node("Map").get_node("Floor").get_used_rect()
	var tilemap_cell_size = get_parent().get_parent().get_node("Map").get_node("Floor").cell_size
	$Camera2D.limit_left = tilemap_rect.position.x * tilemap_cell_size.x
	$Camera2D.limit_right = tilemap_rect.end.x * tilemap_cell_size.x



#Get input from controller.
func get_input():
	velocity.x = 0
	velocity.y = 0
	motion.y = 0
	z = 0

# Moving Right.
	if Input.is_action_pressed("right") and state != States.JUMPKICK and state != States.KICK and state != States.PUNCH and $AnimationTreeFighter.active:
			$AnimatedSpritePlayer.flip_h = false
			$CollisionShape2D.position.x = -21.5
			$PunchZone/CollisionShape2D.position.x = 36
			$HitZone/CollisionShape2D.position.x = -22
			$KickZone/CollisionShape2D.position.x = 33
			$JumpkickZone/CollisionShape2D.position.x = 2.5
			$StickZone/CollisionShape2D.position.x = 60  
			$TaserZone/CollisionShape2D.position.x = -9
			direction_bullet = 1
			velocity.x += speed
			if !fighter_is_jumping:
				self.state = States.WALK

# Moving Left.
	if Input.is_action_pressed("left") and state != States.JUMPKICK and state != States.KICK and state != States.PUNCH and $AnimationTreeFighter.active:
			$AnimatedSpritePlayer.flip_h = true
			$CollisionShape2D.position.x = -8
			$PunchZone/CollisionShape2D.position.x = -72
			$HitZone/CollisionShape2D.position.x = -11
			$KickZone/CollisionShape2D.position.x = -69
			$JumpkickZone/CollisionShape2D.position.x = -40
			$StickZone/CollisionShape2D.position.x = -95 
			$TaserZone/CollisionShape2D.position.x = -120
			direction_bullet = -1
			velocity.x -= speed
			if !fighter_is_jumping:
				self.state = States.WALK

#Moving Up.
	if Input.is_action_pressed("up") and state != States.JUMPKICK and state != States.KICK and state != States.PUNCH and $AnimationTreeFighter.active:
		velocity.y -= speed_y
		if !fighter_is_jumping:
			self.state = States.WALK

# Moving Down.
	if Input.is_action_pressed("down") and state != States.JUMPKICK and state != States.KICK and state != States.PUNCH and $AnimationTreeFighter.active:
		velocity.y += speed_y
		if !fighter_is_jumping:
			self.state = States.WALK

# Start Jumping.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			self.state = States.IDLE
			fighter_is_jumping = false

		if fighter_is_jumping == true:
			self.state = States.JUMP

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
		$Reload.play()
		$AnimationTreeGun.active = true
		$AnimationTreeFighter.active = false
		$AnimationTreeStick.active = false
		$AnimationTreeTaser.active = false
#Move Right with the Gun:
	if Input.is_action_pressed("rightgun") and self.stateGun != States.SHOOT and $AnimationTreeGun.active:
		$AnimatedSpritePlayer.flip_h = false
		$CollisionShape2D.position.x = -21.5
		$PunchZone/CollisionShape2D.position.x = 36
		$HitZone/CollisionShape2D.position.x = -22
		$KickZone/CollisionShape2D.position.x = 33
		$JumpkickZone/CollisionShape2D.position.x = 2.5
		$StickZone/CollisionShape2D.position.x = 60  
		$TaserZone/CollisionShape2D.position.x = -9
		direction_bullet = 1
		velocity.x += speed
		self.stateGun = States.WALKGUN

#Move Left with the Gun:
	if Input.is_action_pressed("leftgun") and self.stateGun != States.SHOOT and $AnimationTreeGun.active:
		$AnimatedSpritePlayer.flip_h = true
		$CollisionShape2D.position.x = -8
		$PunchZone/CollisionShape2D.position.x = -72
		$HitZone/CollisionShape2D.position.x = -11
		$KickZone/CollisionShape2D.position.x = -69
		$JumpkickZone/CollisionShape2D.position.x = -40
		$StickZone/CollisionShape2D.position.x = -95 
		$TaserZone/CollisionShape2D.position.x = -120
		direction_bullet = -1
		velocity.x -= speed
		self.stateGun = States.WALKGUN
			
#Move Up with the Gun.
	if Input.is_action_pressed("upgun") and self.stateGun != States.SHOOT and $AnimationTreeGun.active:
		velocity.y -= speed_y
		self.stateGun = States.WALKGUN
		
#Move Down with the Gun.
	if Input.is_action_pressed("downgun") and self.stateGun != States.SHOOT and $AnimationTreeGun.active:
		velocity.y += speed_y
		self.stateGun = States.WALKGUN

#Move Right with the Stick:
	if Input.is_action_pressed("rightstick") and self.stateStick != States.STICKATTACK and $AnimationTreeStick.active:
		$AnimatedSpritePlayer.flip_h = false
		$CollisionShape2D.position.x = -21.5
		$PunchZone/CollisionShape2D.position.x = 36
		$HitZone/CollisionShape2D.position.x = -22
		$KickZone/CollisionShape2D.position.x = 33
		$JumpkickZone/CollisionShape2D.position.x = 2.5
		$StickZone/CollisionShape2D.position.x = 60  
		$TaserZone/CollisionShape2D.position.x = -9
		velocity.x += speed
		self.stateStick = States.WALKSTICK
		
#Move Left with the Stick:
	if Input.is_action_pressed("leftstick") and self.stateStick != States.STICKATTACK and $AnimationTreeStick.active:
		$AnimatedSpritePlayer.flip_h = true
		$CollisionShape2D.position.x = -8
		$PunchZone/CollisionShape2D.position.x = -72
		$HitZone/CollisionShape2D.position.x = -11
		$KickZone/CollisionShape2D.position.x = -69
		$JumpkickZone/CollisionShape2D.position.x = -40
		$StickZone/CollisionShape2D.position.x = -95 
		$TaserZone/CollisionShape2D.position.x = -120
		velocity.x -= speed
		self.stateStick = States.WALKSTICK
			
#Move Up with the Stick.
	if Input.is_action_pressed("upstick") and self.stateStick != States.STICKATTACK and $AnimationTreeStick.active:
		velocity.y -= speed_y
		self.stateStick = States.WALKSTICK
		
#Move Down with the Stick.
	if Input.is_action_pressed("downstick") and self.stateStick != States.STICKATTACK and $AnimationTreeStick.active:
		velocity.y += speed_y
		self.stateStick = States.WALKSTICK


#Move Right with the Taser:
	if Input.is_action_pressed("righttaser") and self.stateTaser != States.TASERATTACK and $AnimationTreeTaser.active:
		$AnimatedSpritePlayer.flip_h = false
		$CollisionShape2D.position.x = -21.5
		$PunchZone/CollisionShape2D.position.x = 36
		$HitZone/CollisionShape2D.position.x = -22
		$KickZone/CollisionShape2D.position.x = 33
		$JumpkickZone/CollisionShape2D.position.x = 2.5
		$StickZone/CollisionShape2D.position.x = 60  
		$TaserZone/CollisionShape2D.position.x = -9
		velocity.x += speed
		self.stateTaser = States.WALKTASER
		
#Move Left with the Taser:
	if Input.is_action_pressed("lefttaser") and self.stateTaser != States.TASERATTACK and $AnimationTreeTaser.active:
		$AnimatedSpritePlayer.flip_h = true
		$CollisionShape2D.position.x = -8
		$PunchZone/CollisionShape2D.position.x = -72
		$HitZone/CollisionShape2D.position.x = -11
		$KickZone/CollisionShape2D.position.x = -69
		$JumpkickZone/CollisionShape2D.position.x = -40
		$StickZone/CollisionShape2D.position.x = -95 
		$TaserZone/CollisionShape2D.position.x = -120
		velocity.x -= speed
		self.stateTaser = States.WALKTASER

#Move Up with the Taser:
	if Input.is_action_pressed("uptaser") and self.stateTaser != States.TASERATTACK and $AnimationTreeTaser.active:
		velocity.y -= speed_y
		self.stateTaser = States.WALKTASER

#Move Down with the Taser:
	if Input.is_action_pressed("downtaser") and self.stateTaser != States.TASERATTACK and $AnimationTreeTaser.active:
		velocity.y += speed_y
		self.stateTaser = States.WALKTASER

#Back to Fight state:
	if Input.is_action_pressed("fight"):
		$AnimationTreeGun.active = false
		$AnimationTreeStick.active = false
		$AnimationTreeTaser.active = false
		$AnimationTreeFighter.active = true 
		

#Attack with the Stick:
	if Input.is_action_just_pressed("stickattack") and $AnimationTreeStick.active:
		self.stateStick = States.STICKATTACK
#Attack with the Taser:
	if Input.is_action_just_pressed("taserattack") and $AnimationTreeTaser.active:
		self.stateTaser = States.TASERATTACK
		$Electricity.play()
		
# Physics processing.
func _physics_process(delta):

	get_input()
	shoot()

	velocity = move_and_slide(velocity, Vector2.UP)


# Detect if player is idle or walking.
	if velocity == Vector2.ZERO and state != States.DIVEKICK \
		and state != States.JAB and state != States.JUMPKICK and state != States.KICK and state != States.PUNCH and state != States.JUMP and state!= States.SHOOT and state != States.HURT and state != States.FALL:
		self.state = States.IDLE
#With the Gun:
	if velocity == Vector2.ZERO and stateGun != States.SHOOT:
		self.stateGun = States.IDLEGUN
#With the Stick:
	if velocity == Vector2.ZERO and stateStick != States.STICKATTACK:
		self.stateStick = States.IDLESTICK
#With the Taser:
	if velocity == Vector2.ZERO and stateTaser != States.TASERATTACK:
		self.stateTaser = States.IDLETASER

# States setter.
func set_state(new_state):

	match new_state:
		States.FALL:
			animation_state_nogun.travel("Fall")
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
	
#You get the Gun
func set_stateGun(new_stateGun):
	match new_stateGun:
		States.IDLEGUN:
			animation_state_gun.travel("IdleGun")
		States.SHOOT:
			animation_state_gun.travel("Shoot")
		States.WALKGUN:
			animation_state_gun.travel("WalkGun")

	stateGun = new_stateGun
	
#You get the Stick
func set_stateStick(new_stateStick):
	match new_stateStick:
		States.IDLESTICK:
			animation_state_stick.travel("IdleStick")
		States.STICKATTACK:
			animation_state_stick.travel("StickAttack")
		States.WALKSTICK:
			animation_state_stick.travel("WalkStick")
			
	stateStick = new_stateStick
	
#You get the Taser
func set_stateTaser(new_stateTaser):
	match new_stateTaser:
		States.IDLETASER:
			animation_state_taser.travel("IdleTaser")
		States.TASERATTACK:
			animation_state_taser.travel("TaserAttack")
		States.WALKTASER:
			animation_state_taser.travel("WalkTaser")

	stateTaser = new_stateTaser

#Finished actions:
func falling_finished():
	self.state = States.IDLE
	
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

#Attack
var is_punching = false
func punching_finished():
	is_punching = false
	self.state = States.IDLE
	
#Shooting
func shooting_finished():
	self.stateGun =States.IDLEGUN

#With the Stick
func stick_attacking_finished():
	self.stateStick = States.IDLESTICK
#With the Taser
func taser_attacking_finished():
	self.stateTaser = States.IDLETASER


#Shooting Function
var b
var direction_bullet = 1
func shoot():
	if Input.is_action_just_pressed("shoot") and $AnimationTreeGun.active:
		self.stateGun = States.SHOOT
		bullets -= 1
		hudbullets.update_bullets(bullets)
		$Shoot.play()
		b = Bullet.instance()
		add_child(b)
		b.direction = direction_bullet
		b.global_position = $Bullet.global_position
		if bullets <= 0:
			$AnimationTreeFighter.active = true



#Is Hit.
func hit(hurt):
	if state != States.DEAD and life > 0:
		self.state = States.HURT
	if life <= 0:
		self.state = States.DEAD

#Not hit.
func is_not_hit():
		state = States.IDLE


#Contact Areas:
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
			get_tree().change_scene("res://Maps/ChaosInTheCity/GameOver/GameOver.tscn")
	if area.get_name() == "MetalPunchArea":
		if life > 0:
			$AnimationPlayer.play("Hurt")
			life -= 1
			$Hurt.play()
			hud.update_life(life)
			print(life)
		if life <= 0:
			$Dead.play()
			self.state = States.DEAD
			get_tree().change_scene("res://Maps/ChaosInTheCity/GameOver/GameOver.tscn")
	if area.get_name() == "GranadeArea":
		if life > 0:
			$AnimationPlayer.play("Hurt")
			life -= 1
			$Hurt.play()
			hud.update_life(life)
		if life <=0:
			$Dead.play()
			self.state = States.DEAD
			get_tree().change_scene("res://Maps/ChaosInTheCity/GameOver/GameOver.tscn")
	if area.get_name() == "RunoverArea":
		if life > 0:
			$AnimatedSpritePlayer.play("Hurt")
			life -= 1
			$Hurt.play()
			hud.update_life(life)
		if life <= 0:
			$Dead.play()
			self.state = States.DEAD
			get_tree().change_scene("res://Maps/ChaosInTheCity/GameOver/GameOver.tscn")
	if area.get_name() == "FirstAidKit":
			$GetLife.play()
			life += 5
			hud.update_life(life)
	if area.get_name() == "FirstAidKit2":
			$GetLife.play()
			life += 5
			hud.update_life(life)
	if area.get_name() == "Bullets":
			$Reload.play()
			bullets += 4
			hudbullets.update_bullets(bullets)
			$AnimationTreeGun.active =true
	if area.get_name() == "Bullets2":
			$Reload.play()
			bullets += 4
			hudbullets.update_bullets(bullets)
			$AnimationTreeGun.active = true
	if area.get_name() == "Stick":
		$AnimationTreeStick.active = true
		$AnimationTreeFighter.active = false
		$AnimationTreeGun.active = false
		$AnimationTreeTaser.active = false
	if area.get_name() == "Taser":
		$AnimationTreeTaser.active = true
		$AnimationTreeFighter.active = false
		$AnimationTreeGun.active = false
		$AnimationTreeStick.active = false
		


#Jump and Kick at the same time
var is_jumpkick setget set_jumpkick, get_jumpkick

func set_jumpkick(value):
	animation_state_nogun.set("parameters/conditions/is_jumpkick/advance_condition", value)
func get_jumpkick():
	animation_state_nogun.get("parameters/conditios/is_jumpkick/advance_condition")
