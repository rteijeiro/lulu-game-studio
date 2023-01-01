extends Area2D



#Collect items for the Inventory
var items_in_range = {}
func _on_PickUpZone_body_entered(body):
	items_in_range[body] = body



func _on_PickUpZone_body_exited(body):
	if items_in_range.has(body):
		items_in_range.erase(body)
		
