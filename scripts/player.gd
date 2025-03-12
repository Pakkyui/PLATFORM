extends CharacterBody2D

signal blade(pos, direction)
enum States{AIR = 1, FLOOR, CHARGE, WALL}
var state = States.AIR
var air_fric = 1700
var charge_fric = 0.1
var direction = 1
var charging := false
@export var speed = 300
@export var gravity = 30
var jump_force = 700
@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D

#Input
func _physics_process(_delta):
	match state:
		States.AIR:
			if is_on_floor():
				state = States.FLOOR
			elif is_on_wall():
				state = States.WALL
			if Input.is_action_just_released("jump"):
				if velocity.y < -380:
					velocity.y = -380
			var horizontal_direction = Input.get_axis("left" , "right")
			if horizontal_direction != 0:
				velocity.x = move_toward(velocity.x, speed * horizontal_direction, air_fric * _delta)
			else:
				velocity.x = move_toward(velocity.x, 0 ,air_fric * _delta)
			if horizontal_direction != 0:
				sprite.flip_h = (horizontal_direction == -1)
			move_and_fall(false)
			set_direction()
			update_animations(horizontal_direction)
		
		States.FLOOR:
			if !is_on_floor():
				state = States.AIR
			var horizontal_direction = Input.get_axis("left" , "right")
			velocity.x = speed * horizontal_direction
			if horizontal_direction != 0:
				sprite.flip_h = (horizontal_direction == -1)
			if Input.is_action_just_pressed("jump"):
				velocity.y = -jump_force
				state = States.AIR
			move_and_fall(false)
			set_direction()
			update_animations(horizontal_direction)
		
		
		States.WALL:
			if is_on_floor():
				state = States.FLOOR
			if !is_near_wall():
				if is_on_floor():
					state = States.FLOOR
				else:
					state = States.AIR
			if Input.is_action_just_pressed("down"):
				state = States.AIR
				velocity.x = 30 * -direction
			if Input.is_action_pressed("jump") && ((Input.is_action_pressed("left") and direction == 1) or Input.is_action_pressed("right") and direction == -1):
				velocity.x = 400 * -direction
				velocity.y = -jump_force * 0.9
				state = States.AIR
			move_and_fall(true)
		
#Movement 
func charge_and_fall():
	if velocity.y != 0:
		velocity.y = 0
	if velocity.x  != 0:
		velocity.x != 0
	move_and_slide()
func move_and_fall(slow_fall: bool):
	if slow_fall:
		if velocity.y > 50:
			velocity.y = 50
	if !is_on_floor():  
		velocity.y += gravity
		if velocity.y > 480:
			velocity.y = 725
	move_and_slide()
func set_direction():
	direction = 1 if not sprite.flip_h else -1
	$Wallchecker.rotation_degrees = 90 * -direction
func is_near_wall():
	return $Wallchecker.is_colliding()

#Animations
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
	if not is_on_floor():
		state = States.AIR
	else:
		state = States.FLOOR


func _on_fallzone_body_entered(body):
	if body.name == "Player":
		Playerstats.has_blade = false
		get_tree().change_scene_to_file("res://scenes/World.tscn")


func _on_fallzone_2_body_entered(body):
	if body.name == "Player":
		Playerstats.has_blade = false
		get_tree().change_scene_to_file("res://scenes/World.tscn")
