extends KinematicBody2D


enum States {
	IDLE,
	WALK,
	ATTACK, 
}
#
var direction:Vector2 = Vector2.ZERO
onready var animation_state = $AnimationTree.get('parameters/playback')
var state = States.WALK
var is_attacking = false
var life = 2
var is_switching_direction:bool = false
var target = null

func _physics_process(delta: float) -> void:

		if state != States.ATTACK:
			$AnimatedSprite.play("Walk")
			var collision = move_and_collide(direction)
			if collision != null:
				if collision.collider.name == "FighterPlayer" :
						collision.collider.is_hit("up", 10)
				else:
						direction = target
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
				state = States.WALK


func set_state(new_state):
	match new_state:
		States.IDLE:
			animation_state.travel("Idle")
		States.WALK:
			animation_state.travel("Walk")
		States.ATTACK:
			animation_state.travel("Attack")
	
	state = new_state


func check_direction():
	if direction.x > 0: # Move right.
		$AnimatedSprite.flip_h = true
		$CollisionShape2D.position.x = -3.2
		$AttackArea/CollisionShape2D.position.x = 45
	else: # Move left.
		$AnimatedSprite.flip_h = false
		$CollisionShape2D.position.x = -3.2
		$AttackArea/CollisionShape2D.position.x = -50
	
	
func attacking():
	is_attacking = true
	$Timer.start(3)
	self.state = States.ATTACK
	
func _on_Timer_timeout():
	is_attacking = false 

#func hit():
#	life = life - 1
#	if life <= 0 :
#		state = States.DEAD
#		$AnimationPlayer.play("Dead")

#func is_not_hit():
#	self.state = States.IDLE
#
#
#func _on_AttackArea_body_entered(body):
#	if body.name == "FighterPlayer":
#		self.state = States.ATTACK
#
#func _on_DetectionArea_body_entered(body):
#	if body.name == "FighterPlayer":
#		target = body
#
#func _on_DetectionArea_body_exited(body):
#	if body.name == "FighterPlayer":
#		target = null
#		self.state = States.WALK
#
#
#func _on_HitBox_body_entered(body):
#	if body.name == "FighterPlayer":
#		self.state = States.HURT
#		body.is_hit("up", 10)
#	if body.name == "Bullet":
#		self.state = States.HURT
#
#func death():
#	queue_free()



