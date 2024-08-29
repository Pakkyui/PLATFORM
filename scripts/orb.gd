extends Area2D


func _on_body_entered(body):
	if body.name == "Player" or body.name == "Tblade":
		Playerstats.can_blade = true
		queue_free()
