extends CanvasLayer


onready var bulletsbar = $BulletsBar

func update_bullets(bullets):
	bulletsbar.value = bullets
