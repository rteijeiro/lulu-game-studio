extends CanvasLayer

onready var lifebar = $LifeBar

func update_life(life):
	lifebar.value = life
