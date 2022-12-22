extends KinematicBody2D

var direction = 0.75


func _physics_process(delta: float) -> void:
	
	$WalkingWoman/AnimatedSprite.play("Walking")
	var collision = move_and_collide(Vector2(direction,0))


onready var lulu = get_node("/root/World/Lulu")


func _on_WalkingWoman_body_entered(body):
	if body.name == "Lulu":
		var new_dialog = Dialogic.start('WalkingWoman')
		add_child(new_dialog)
		new_dialog.connect("timeline_end", self, 'after_dialog')
		lulu.set_physics_process(false)
		

func after_dialog(timeline_name):
	lulu.set_physics_process(true)

