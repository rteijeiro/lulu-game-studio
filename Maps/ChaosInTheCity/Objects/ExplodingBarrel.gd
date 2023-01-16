extends Area2D
	

func _on_AreaExplodingBarrel_area_entered(area):
	if area.get_name() == "AreaBullet":
		$AnimationPlayer.play("Exploding")
		$Explosion.play()
	if area.get_name() == "PunchZone":
		$AnimationPlayer.play("Exploding")
		$Explosion.play()
	if area.get_name() == "StickZone":
		$AnimationPlayer.play("Exploding")
		$Explosion.play()
