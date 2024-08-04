extends CharacterBody2D

var direction = 1
const SPEED = 400
const BOUNCE = -300

func _ready():
	velocity.x = SPEED * direction
	
	if  Input.is_action_pressed("jump"):
		velocity.y = -SPEED
		velocity.x = 0
		if Input.is_action_pressed("left"):
			velocity.x = SPEED * direction
		if Input.is_action_pressed("right"):
			velocity.x = SPEED * direction
	if Input.is_action_pressed("down"):
		velocity.y = SPEED

func _physics_process(_delta):
	
	if is_on_floor():
		velocity.y = BOUNCE
	if is_on_wall():
		velocity.x = BOUNCE
	
	move_and_slide()
