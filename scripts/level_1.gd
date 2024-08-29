extends LevelParent


func _on_fallzone_body_entered(body):
	if body.name == "Player":
		Playerstats.has_blade = false
		get_tree().change_scene_to_file("res://scenes/level_1.tscn")


func _on_fallzone_2_body_entered(body):
	if body.name == "Player":
		Playerstats.has_blade = false
		get_tree().change_scene_to_file("res://scenes/level_1.tscn")
