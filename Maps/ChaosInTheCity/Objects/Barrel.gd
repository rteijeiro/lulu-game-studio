extends Area2D

func _on_AreaBarrel_area_entered(area):
	 if area.get_name() == "PunchZone":
			$Idle.hide()
			$Broken.show() 
			$Metal.play()
			
	 if area.get_name() == "KickZone":
			$Idle.hide()
			$Broken.show()
			$Metal.play()
			
	 if area.get_name() == "AreaBullet":
			$Idle.hide()
			$Broken.show()
			$Metal.play()
			



