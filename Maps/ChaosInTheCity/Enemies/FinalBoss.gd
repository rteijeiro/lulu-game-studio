extends KinematicBody2D


enum States {
	IDLE,
	RUN,
	HURT,
	ATTACK, 
	PUNCHMETAL,
	DEAD
}
#
var direction:Vector2 = Vector2.ZERO
onready var animation_state = $AnimationTree.get('parameters/playback')
var state = States.IDLE
var is_attacking = false
var is_punching = false
var life = 10
var is_switching_direction:bool = false
var target = null


func _physics_process(delta: float) -> void:

	if state != States.HURT:
		if state != States.ATTACK and state != States.PUNCHMETAL:
			$AnimatedSprite.play("Run")
			var collision = move_and_collide(direction)
			if collision != null:
				if collision.collider.name == "FighterPlayer" :
						$AnimationPlayer.play("Attack") 
				if collision.collider.name == "FighterPlayer":
						$AnimationPlayer.play("PunchMetal")
				else:
						direction = Vector2(-1,-1)
						scale.x = 1
			if target:
					var target_direction = (target.transform.origin - self.transform.origin).normalized();
					direction = target_direction

					check_direction()

		for body in $AttackArea.get_overlapping_bodies():
			if body.name == "FighterPlayer" and !is_attacking:
				$AnimationPlayer.play("Attack")
				state = States.ATTACK
		for body in $MetalPunchArea.get_overlapping_bodies():
			if body.name == "FighterPlayer" and !is_punching:
				$AnimationPlayer.play("PunchMetal")
				state = States.PUNCHMETAL
			else:
				state = States.IDLE


func set_state(new_state):
	
	match new_state:
		
		States.IDLE:
			animation_state.travel("Idle")
		States.RUN:
			animation_state.travel("Run")
		States.ATTACK:
			animation_state.travel("Attack")
		States.PUNCHMETAL:
			animation_state.travel("PunchMetal")
		States.HURT:
			animation_state.travel("Hurt")
		States.DEAD:
			animation_state.travel("Dead")
	
	state = new_state


func check_direction():
	if direction.x > 0: # Move right.
		$AnimatedSprite.flip_h = false
		$AttackArea/CollisionShape2D.position.x = 95
		$HitBox/CollisionShape2D.position.x = -1
		$Mullet.position.x = 66
		$Mullet2.position.x = 42
		$Mullet3.position.x = 20


	else: # Move left.
		$AnimatedSprite.flip_h = true
		$AttackArea/CollisionShape2D.position.x = -95
		$HitBox/CollisionShape2D.position.x = 1
		$Mullet.position.x = -33
		$Mullet2.position.x = -21
		$Mullet3.position.x = -10

#Granade
onready var Granade = preload("res://Maps/ChaosInTheCity/Enemies/Granade.tscn")
onready var Granade2 = preload("res://Maps/ChaosInTheCity/Enemies/Granade2.tscn")
onready var Granade3 = preload("res://Maps/ChaosInTheCity/Enemies/Granade3.tscn")

func throw():
	var granade = Granade.instance()
	granade.direction = direction
	granade.global_position = $Mullet.global_position
	get_parent().add_child(granade)
	var granade2 = Granade2.instance()
	granade2.direction = direction 
	granade2.global_position = $Mullet2.global_position
	get_parent().add_child(granade2)
	var granade3 = Granade3.instance()
	granade3.direction = direction 
	granade3.global_position = $Mullet3.global_position
	get_parent().add_child(granade3)
	

func attacking():
	is_attacking = true
	$Timer.start(3)
	throw()
	
func punch():
	self.state = States.PUNCHMETAL
func punching():
	is_punching = true
	$Timer2.start(3)
	punch()

	
func _on_Timer_timeout():
	is_attacking = false 
func _on_Timer2_timeout():
	is_punching = false

func hit():
	self.state = States.HURT
	$AnimationPlayer.play("Hurt")
	life -= 1
	print(life)
	if life <= 0:
		$AnimationPlayer.play("Dead")

func is_not_hit():
	self.state = States.IDLE
	


func _on_MetalPunchArea_body_entered(body):
	if body.name == "FighterPlayer":
		punch()
		self.state = States.PUNCHMETAL

func _on_AttackArea_body_entered(body):
	if body.name == "FighterPlayer":
		throw()
		self.state = States.ATTACK

func _on_DetectionArea_body_entered(body):
	if body.name == "FighterPlayer":
		target = body
		
func _on_DetectionArea_body_exited(body):
	if body.name == "FighterPlayer":
		target = null
		self.state = States.RUN

func _on_HitBox_area_entered(area):
	if area.get_name() == "PunchZone":
		$AnimationPlayer.play("Hurt")
		$Hurt.play()
		self.hit()
	if area.get_name() == "KickZone":
		$AnimationPlayer.play("Hurt")
		$Hurt.play()
		self.hit()
	if area.get_name() == "AreaBullet":
		$AnimationPlayer.play("Hurt")
		$Hurt.play()
		self.hit()
	if area.get_name() == "JumpkickZone":
		$AnimationPlayer.play("Hurt")
		$Hurt.play()
		self.hit()


func death():
	$AnimationPlayer.play("Dead")
	self.state = States.DEAD
	
func animation_over():
	queue_free()
	get_tree().change_scene("res://World.tscn")
	















