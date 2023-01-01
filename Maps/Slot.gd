extends Panel


var default_tex = preload("res://Sprites/Inventory/Slot2.png")
var empty_tex = preload("res://Sprites/Inventory/Slot.png")

var default_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null

var ItemClass = preload("res://Maps/Objects/VRGlassesInventary.tscn")
var item = null


func _ready():
	default_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	default_style.texture = default_tex 
	empty_style.texture = empty_tex
	
	if randi() % 2 == 0:
		item = ItemClass.instance()
		add_child(item)
	refresh_style()
	
func refresh_style():
	if item == null:
		set("custom_styles/panel", empty_style)
	else:
		set("custom_styles/panel", default_style)

func PickFromSlot():
	remove_child(item)
	var InventoryNode = find_parent("Inventory")
	InventoryNode.add_child(item)
	item = null
	refresh_style()

func PutIntoSlot(new_item):
	item = new_item
	item.position = Vector2(0,0)
	var InventoryNode = find_parent("Inventory")
	InventoryNode.remove_child(item)
	add_child(item)
	refresh_style()
	
