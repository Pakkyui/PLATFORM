extends RigidBody2D


func _ready():
	$Self_destruct.start()

func _on_self_destruct_timeout():
	queue_free()
func _physics_process(_delta):
	if Input.is_action_just_released("blade"):
		queue_free()
