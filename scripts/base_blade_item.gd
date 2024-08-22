extends Area2D





func _on_body_entered(body):
	if body.name == "Player":
		Playerstats.has_blade = true
		
		queue_free()
