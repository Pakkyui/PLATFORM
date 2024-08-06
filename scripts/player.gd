extends CharacterBody2D
 
signal blade
enum States{AIR = 1, FLOOR, CHARGE, WALL, DASH, PREDASH}
var state = States.AIR
var can_blade: bool = true
var air_fric = 1300
@export var speed = 150
@export var gravity = 30
@export var jump_force = 200 
@export var blade_force = 400
@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
const TBlade = preload("res://scenes/Blade.tscn")

#Input
func _physics_process(_delta):
	print(state)
	cblade()
	match state:
		States.AIR:
			if is_on_floor():
				state = States.FLOOR
			if Input.is_action_just_pressed("blade") && can_blade:
				state = States.PREDASH
				$PREDASHTIME.start()
			momentum()
			move_and_fall()
			update_animations(horizontal_direction)
		States.FLOOR:
			if Input.is_action_just_pressed("blade") && can_blade:
				state = States.PREDASH
				$PREDASHTIME.start()
			if not is_on_floor():
				state = States.AIR
				can_blade = true
			var horizontal_direction = Input.get_axis("left" , "right")
			velocity.x = speed * horizontal_direction
			if horizontal_direction != 0:
				sprite.flip_h = (horizontal_direction == -1)
			if Input.is_action_just_pressed("jump"):
				velocity.y = -jump_force
				state = States.AIR
			move_and_fall()
			update_animations(horizontal_direction)
		States.PREDASH:
			if Input.is_action_just_released("blade"):
				state = States.DASH
			if $PREDASHTIME.is_stopped():
				state = States.CHARGE
			move_and_fall()
		States.DASH:
			fire()
			if not is_on_floor():
				state = States.AIR
			else:
				state = States.FLOOR
		States.CHARGE:
			momentum()
			if Input.is_action_just_released("blade"):
				fire()
				if not is_on_floor():
					state = States.AIR
				else:
					state = States.FLOOR
			charge_and_fall()
				
func charge_and_fall():
	if !is_on_floor():  
		velocity.y = gravity
		if velocity.y > 0.1:
			velocity.y = 0.1
		if velocity.x > 30:
			velocity.x = 30
	move_and_fall()

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
	if can_blade: 
		var direction = 1 if not sprite.flip_h else -1
		var t = TBlade.instantiate()
		t.direction = direction
		get_parent().add_child(t)
		t.position.y = position.y if not Input.is_action_pressed("up") else position.y - 25
		t.position.x = position.x + 20 * direction if not Input.is_action_pressed("up") else position.x 
		can_blade = false

func cblade():
	if Input.is_action_just_released("blade") && can_blade:
		$Timer.start()
		blade.emit()
	
	if $Timer.is_stopped():
		if is_on_floor():
			can_blade = true
		
func _on_predashtime_timeout():
	if Input.is_action_pressed("blade"):
		state = States.CHARGE
func momentum():
	var horizontal_direction = Input.get_axis("left" , "right")
	if horizontal_direction != 0:
		velocity.x = move_toward(velocity.x, 20 * horizontal_direction, air_fric * _delta)
	else:
		velocity.x = move_toward(velocity.x, 0 ,air_fric * _delta)
	if horizontal_direction != 0:
		sprite.flip_h = (horizontal_direction == -1)

