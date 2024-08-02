extends CharacterBody2D

var direction = 1
const SPEED = 300

func _ready():
	velocity.x = SPEED * direction
	#velocity.y = SPEED * direction
func _physics_process(_delta):
	
	if is_on_wall():
		queue_free()
	
	
	move_and_slide()
