extends KinematicBody2D


enum States {
	IDLE,
	WALK,
	HURT,
	HURTELECTRICITY,
	ATTACK, 
	DEAD
}

var direction:Vector2 = Vector2.ZERO
onready var animation_state = $AnimationTree.get('parameters/playback')
var state = States.IDLE
var is_attacking = false
var life = 5
var is_switching_direction:bool = false
var target = null

func _physics_process(delta: float) -> void:

	if state != States.HURT and state != States.HURTELECTRICITY:
		if state != States.ATTACK:
			$AnimatedSprite.play("Walk")
			var collision = move_and_collide(direction)
			if collision != null:
				if collision.collider.name == "FighterPlayer" :
						$AnimationPlayer.play("Attack")
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
			else:
				state = States.IDLE


func set_state(new_state):
	
	match new_state:
		
		States.IDLE:
			animation_state.travel("Idle")
		States.WALK:
			animation_state.travel("Walk")
		States.ATTACK:
			animation_state.travel("Attack")
		States.HURT:
			animation_state.travel("Hurt")
		States.HURTELECTRICITY:
			animation_state.travel("HurtElectricity")
		States.DEAD:
			animation_state.travel("Dead")
	
	state = new_state


func check_direction():
	if direction.x > 0: # Move right.
		$AnimatedSprite.flip_h = true
		$CollisionShape2D.position.x = -3.2
		$DetectionArea/CollisionShape2D.position.x = 9.5
		$AttackArea/CollisionShape2D.position.x = 45
		$HitBox/CollisionShape2D.position.x = -5.5
		$PunchArea/CollisionShape2D.position.x = 40
	else: # Move left.
		$AnimatedSprite.flip_h = false
		$CollisionShape2D.position.x = -3.2
		$DetectionArea/CollisionShape2D.position.x = -18
		$AttackArea/CollisionShape2D.position.x = -50
		$HitBox/CollisionShape2D.position.x = -5.5
		$PunchArea/CollisionShape2D.position.x = -44.5
	
func attacking():
	is_attacking = true
	$Timer.start(2)
	self.state = States.ATTACK
	
	
func _on_Timer_timeout():
	is_attacking = false 

func hit():
	self.state = States.HURT
	$AnimationPlayer.play("Hurt")
	life -= 1
	print(life)
	if life <= 0:
		$AnimationPlayer.play("Dead")
		$Dead.play() 

func hit_electricity():
	self.state = States.HURTELECTRICITY
	$AnimationPlayer.play("HurtElectricity")
	life -= 1
	if life <= 0:
		$AnimationPlayer.play("Dead")
		$Dead.play()

func is_not_hit():
	self.state = States.IDLE

func is_not_hit_electricity():
	self.state = States.IDLE


func _on_AttackArea_body_entered(body):
	if body.name == "FighterPlayer":
		self.state = States.ATTACK
		$Punch.play()

func _on_DetectionArea_body_entered(body):
	if body.name == "FighterPlayer":
		target = body
		
func _on_DetectionArea_body_exited(body):
	if body.name == "FighterPlayer":
		target = null
		self.state = States.WALK

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
		$Hurt.play()
		self.hit()
	if area.get_name() == "JumpkickZone":
		$Hurt.play()
		self.hit()
	if area.get_name() == "StickZone":
		$Hurt.play()
		self.hit()
	if area.get_name() == "TaserZone":
		self.hit_electricity()


func death():
	$AnimationPlayer.play("Dead")
	self.state = States.DEAD 

func animation_over():
	queue_free()
