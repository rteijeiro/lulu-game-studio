extends Area2D

signal hit

func _on_Spike_body_entered(body):
	emit_signal("hit", self.name)
