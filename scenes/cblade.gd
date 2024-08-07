extends CharacterBody2D

var direction = 1
const SPEED = 1200
const BOUNCE = -1200

func _ready():
	velocity.x = SPEED * direction
	
	if  Input.is_action_pressed("up"):
		velocity.y = -SPEED
		velocity.x = 0
		if Input.is_action_pressed("left"):
			velocity.x = SPEED * direction
		if Input.is_action_pressed("right"):
			velocity.x = SPEED * direction
	if Input.is_action_pressed("down"):
		velocity.y = SPEED

func _physics_process(_delta):
	if velocity.length() > 600: velocity.normalized()
	
	if is_on_floor():
		velocity.y = BOUNCE
	if is_on_wall():
		velocity.x = BOUNCE
	if is_on_ceiling():
		velocity.y = BOUNCE
	
	move_and_slide()
	
