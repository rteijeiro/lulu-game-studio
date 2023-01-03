extends KinematicBody2D


enum States {
	IDLE,
	WALK,
	HURT,
	ATTACK
}

export var speed:int = 30
var velocity:Vector2 = Vector2.ZERO
var direction:int = -1
onready var animation_state = $AnimationTree.get('parameters/playback')
var state = States.IDLE setget set_state
var is_switching_direction:bool = false
var target = null



func _physics_process(_delta: float) -> void:
	for body in $DetectionArea.get_overlapping_bodies():
		if body.name == "FighterPlayer" and state != States.HURT:
			self.state = States.WALK



func set_state(new_state):
	match new_state:
		States.IDLE:
			animation_state.travel("idle")
		States.WALK:
			animation_state.travel("move")
		States.ATTACK:
			animation_state.travel("attack")
		States.HURT:
			animation_state.travel("hurt")
	
	state = new_state

func check_direction():
	if direction > 0: # Move right.
		$AnimatedSprite.flip_h = false
		$CollisionShape2D.position.x = -5
		$HitBoxt/CollisionShape2D.position.x = 15
	else: # Move left.
		$AnimatedSprite.flip_h = true
		$CollisionShape2D.position.x = 5
		$HitBox/CollisionShape2D.position.x = -15
	
func hit():
	self.state = States.HURT

		
func is_not_hit():
	self.state = States.IDLE



func _on_HitBox_area_entered(area):
	 if area.get_name() == "PunchZone":
			$AnimationPlayer.play("Hurt")
	 if area.get_name() == "AreaBullet":
			$AnimationPlayer.play("Hurt")
	 if area.get_name() == "KickZone":
			$AnimationPlayer.play("Hurt")



#func _on_DetectionArea_body_entered(body: Node) -> void:
#	if body.name == "FighterPlayer":
#		target = body
#		self.state = States.WALK
		
	
#func _on_DetectionArea_body_exited(body: Node) -> void:
#	if body.name == "FighterPlayer":
#		target = null
#		self.state = States.IDLE

#func _on_HitBox_body_entered(body: Node) -> void:
#	if body.name == "FighterPlayer":
#		body.is_hit()
	









