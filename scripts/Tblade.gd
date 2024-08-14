extends RigidBody2D


func _ready():
	$Self_destruct.start()

func _on_self_destruct_timeout():
	queue_free()
