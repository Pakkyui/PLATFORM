extends CharacterBody2D
 
signal blade
enum States{AIR = 1, FLOOR, CHARGE, WALL}
var state = States.AIR
var can_blade: bool = true
@export var speed = 150
@export var gravity = 30
@export var jump_force = 200 
@export var blade_force = 400
@export var air_fric = 1300
@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
const TBlade = preload("res://scenes/Blade.tscn")

#Input
func _physics_process(_delta):
	match state:
		States.AIR:
			if is_on_floor():
				state = States.FLOOR
			var horizontal_direction = Input.get_axis("left" , "right")
			if horizontal_direction != 0:
				velocity.x = move_toward(velocity.x, speed * horizontal_direction, air_fric * _delta)
			else:
				velocity.x = move_toward(velocity.x, 0 ,air_fric * _delta)
			if horizontal_direction != 0:
				sprite.flip_h = (horizontal_direction == -1)
			move_and_fall()
			update_animations(horizontal_direction)
			fire()
		States.FLOOR:
			if not is_on_floor():
				state = States.AIR
			var horizontal_direction = Input.get_axis("left" , "right")
			velocity.x = speed * horizontal_direction
			if horizontal_direction != 0:
				sprite.flip_h = (horizontal_direction == -1)
			if Input.is_action_just_pressed("jump"):
				velocity.y = -jump_force
				state = States.AIR
			move_and_fall()
			update_animations(horizontal_direction)
			fire()
			
		
func move_and_fall():
	if !is_on_floor():  
		velocity.y += gravity
		if velocity.y > 1000:
			velocity.y = 1000
	move_and_slide()
	
func update_animations(horizontal_direction):
	if is_on_floor():
		if horizontal_direction == 0:
			ap.play("idle")
		else:
			ap.play("run")
	else:
		if velocity.y < 0:
			ap.play("jump")
		elif velocity.y > 0:
			ap.play("fall")

	#Blade shooting input
func fire():
	if Input.is_action_just_pressed("blade") && can_blade: 
		var direction = 1 if not sprite.flip_h else -1
		var t = TBlade.instantiate()
		t.direction = direction
		get_parent().add_child(t)
		t.position.y = position.y if not Input.is_action_pressed("up") else position.y - 25
		t.position.x = position.x + 20 * direction if not Input.is_action_pressed("up") else position.x 
		can_blade = false
		$Timer.start()
		blade.emit()
		
	if not $Timer.is_stopped():
		can_blade = false
	if $Timer.is_stopped():
		if is_on_floor():
			can_blade = true
			
func on_timer_timeout():
	pass
			
			



			
			
		
		

