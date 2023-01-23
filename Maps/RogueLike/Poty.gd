extends Area2D

signal poty

func _on_Poty_body_entered(body):
	queue_free()
	emit_signal("poty", self.name)
