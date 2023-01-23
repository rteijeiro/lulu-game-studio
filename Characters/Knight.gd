extends KinematicBody2D

export (int) var speed = 100
var velocity:Vector2 = Vector2.ZERO


enum States {
	IDLE,
	RUN
}
var state = States.IDLE setget set_state
onready var animation_state = $AnimationTreeKnight.get("parameters/playback")

func _ready():
	get_parent().get_node("Enemy").connect("hit", self, "hp_down")
	get_parent().get_node("Spike").connect("hit", self, "hp_down")
	get_parent().get_node("Poty").connect("poty", self, "hp_up")
func hp_down(enemy):
	print ("E")
	if $AnimatedHeart.frame != 0:
		$AnimatedHeart.frame = 2
	else:
		$AnimatedHeart.frame = 1
		
	
func hp_up(poty):
	$Poty.show()

func get_input():
	velocity.x = 0
	velocity.y = 0
	
	if Input.is_action_pressed("right"):
		$AnimatedSprite.flip_h = false
		velocity.x += speed
		self.state = States.RUN
		
	if Input.is_action_pressed("left"):
		$AnimatedSprite.flip_h = true
		velocity.x -= speed
		self.state = States.RUN
		
	if Input.is_action_pressed("up"):
		velocity.y -= speed
		self.state = States.RUN
		
	if Input.is_action_pressed("down"):
		velocity.y += speed
		self.state = States.RUN
		
	if Input.is_action_pressed("attack_right"):
		$Attack_right/Sprite.show()
		$Attack_right.monitoring = true
		
	if Input.is_action_just_released("attack_right"):
		$Attack_right/Sprite.hide()
		$Attack_right.monitoring = false
		
	if Input.is_action_pressed("attack_left"):
		$Attack_left/Sprite.show()
		$Attack_left.monitoring = true
		
	if Input.is_action_just_released("attack_left"):
		$Attack_left/Sprite.hide()
		$Attack_left.monitoring = false
		
	if Input.is_action_pressed("attack_down"):
		$Attack_down/Sprite.show()
		$Attack_down.monitoring = true
		
	if Input.is_action_just_released("attack_down"):
		$Attack_down/Sprite.hide()
		$Attack_down.monitoring = false
		
	if Input.is_action_pressed("attack_up"):
		$Attack_up/Sprite.show()
		$Attack_up.monitoring = true
		
	if Input.is_action_just_released("attack_up"):
		$Attack_up/Sprite.hide()
		$Attack_up.monitoring = false
		
	if Input.is_action_just_pressed("Poty") and $Poty.visible == true and $AnimatedHeart.frame == 1:
		$AnimatedHeart.frame = 0
		
	if Input.is_action_just_pressed("Poty") and $Poty.visible == true and $AnimatedHeart.frame == 2:
		$AnimatedHeart.frame = 1
		
	if Input.is_action_just_released("Poty") and $AnimatedHeart.frame != 0:
		$Poty.hide()
func _physics_process(delta):

	get_input()

	velocity = move_and_slide(velocity, Vector2.UP)
	
	if velocity == Vector2.ZERO:
		self.state = States.IDLE

func set_state(new_state):
	match new_state:
		States.IDLE:
			animation_state.travel("Idle")
			
		States.RUN:
			animation_state.travel("Run")


func _on_Attack_right_body_entered(body):
	if body.has_method("hit"):
		body.hit()
		print ("R")

func _on_Attack_left_body_entered(body):
	if body.has_method("hit"):
		body.hit()
		print ("R")

func _on_Attack_down_body_entered(body):
	if body.has_method("hit"):
		body.hit()
		print ("R")

func _on_Attack_up_body_entered(body):
	if body.has_method("hit"):
		body.hit()
		print ("R")
