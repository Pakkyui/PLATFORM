extends CharacterBody2D
 
var can_blade: bool = true

@export var speed = 300
@export var gravity = 30
@export var jump_force = 300 

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D



#Input
func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > 1000:
			velocity.y = 1000
	
	if Input.is_action_just_pressed("jump"): #&& is_on_floor():
		velocity.y = -jump_force
	
	var horizontal_direction = Input.get_axis("move_left" , "move_right")
	
	velocity.x = speed * horizontal_direction
	
	move_and_slide()
	
	print(velocity)

#Blade shooting input
	if Input.is_action_pressed("blade") and can_blade:
		print('fire blade')
		can_blade = false
		$Timer.start()
	


func _on_timer_timeout():
	if is_on_floor():
		can_blade = true
