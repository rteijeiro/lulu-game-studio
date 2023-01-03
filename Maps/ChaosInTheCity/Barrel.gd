extends Area2D

func _on_AreaBarrel_area_entered(area):
	 if area.get_name() == "PunchZone":
			$Idle.hide()
			$Broken.show() 
	 if area.get_name() == "KickZone":
			$Idle.hide()
			$Broken.show()




