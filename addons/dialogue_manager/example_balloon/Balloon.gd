extends NinePatchRect

var character_label = "Lulu"

func show_characters():
	if character_label =="Lulu":
		$LuluHead.visible
	if character_label == "Human":
		$BlondGuyHead.visible
		
