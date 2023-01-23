extends KinematicBody2D

export (int) var speed = 100

var velocity: Vector2 = Vector2.ZERO

enum States {
	IDLE,
	RUN
}
var state = States.IDLE setget set_state
onready var animation_state = $AnimationTreeEnemy.get("parameters/playback")

var path: Array = []
var levelNavigation: Navigation2D = null
var knight = null
var knight_spotted: bool = false

var heal = 30

signal hit

onready var line2d = $Line2D
onready var los = $RayCast2D

func _ready():
	position = Vector2(-412,40)
	yield(get_tree(), "idle_frame")
	var tree = get_tree()
	if tree.has_group("LevelNavigation"):
		levelNavigation = tree.get_nodes_in_group("LevelNavigation")[0]
	if tree.has_group("Knight"):
		knight = tree.get_nodes_in_group("Knight")[0]
	

func _physics_process(delta: float) -> void:
	line2d.global_position = Vector2.ZERO
	if knight:
		los.look_at(knight.global_position)
		check_knight_in_detection()
		if knight_spotted:
			generate_path()
			navigate()
			self.state = States.RUN
		
	
	var collision = move_and_collide(velocity * delta)
	

func check_knight_in_detection() -> bool:
	var collider = los.get_collider()
	if collider and collider.is_in_group("Knight"):
		knight_spotted = true
		return true
	return false
func navigate():
	if path.size() > 0:
		velocity = global_position.direction_to(path[1]) * speed
		
		if global_position == path[0]:
			path.pop_front()
	
func generate_path():
	if levelNavigation != null and knight != null:
		path = levelNavigation.get_simple_path(global_position, knight.global_position, false)
		line2d.points = path
		
	
func hit():
	$CanvasLayer/Control/Lifebar.value -= 10
	
	if $CanvasLayer/Control/Lifebar.value == 0:
		queue_free()
		
	
func set_state(new_state):
	match new_state:
		States.IDLE:
			animation_state.travel("Idle")
			
		States.RUN:
			animation_state.travel("Run")

func _on_Area2D_body_entered(body):
	if body.name == "Knight":
		body.hp_down("up")
