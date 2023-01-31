extends Area2D
 
enum States {
	IDLE,
	DISAPPEAR
}


func _on_AreaBarrel_area_entered(area):

	if area.get_name() == "PunchZone":
		$AnimationPlayer.play("Disappear")
		$Metal.play()


	if area.get_name() == "KickZone":
		$AnimationPlayer.play("Disappear")
		$Metal.play()


	if area.get_name() == "AreaBullet":
		$AnimationPlayer.play("Disappear")
		$Metal.play()


	if area.get_name() == "StickZone":
		$AnimationPlayer.play("Disappear")
		$Metal.play()



