extends Area2D



func _on_Bullets_area_entered(area):
	if area.get_name() == "HitZone":
		queue_free()
