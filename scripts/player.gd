extends CharacterBody2D

signal blade(pos, direction)
enum States{AIR = 1, FLOOR, CHARGE, WALL, DASH, PREDASH, POSTDASH}
var state = States.AIR
var can_blade: bool = true
var air_fric = 1000
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
	cblade()
	
	match state:
		States.AIR:
			if is_on_floor():
				state = States.FLOOR
			elif is_on_wall():
				state = States.WALL
			if Input.is_action_just_pressed("blade") && can_blade:
				state = States.PREDASH
				$PREDASHTIME.start()
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
			move_and_fall(false)
			set_direction()
			update_animations(horizontal_direction)
		
		States.PREDASH:
			if Input.is_action_just_released("blade"):
				state = States.DASH
			move_and_fall(false)
			set_direction()
		
		States.DASH:
			fire()
			state = States.POSTDASH
			$PDT.start()
		
		States.CHARGE:
			if Input.is_action_just_released("blade"):
				mfire()
				state = States.POSTDASH
				$PDT.start()
			set_direction()
			charge_and_fall()
		
		States.WALL:
			if is_on_floor():
				state = States.FLOOR
			elif not is_on_wall():
				state = States.AIR
			if Input.is_action_just_pressed("down"):
				state = States.AIR
				velocity.x = 30 * -direction
			if Input.is_action_just_pressed("blade") && can_blade:
				state = States.PREDASH
			if Input.is_action_pressed("jump") && ((Input.is_action_pressed("left") and direction == 1) or Input.is_action_pressed("right") and direction == -1):
				velocity.x = 400 * -direction
				velocity.y = -jump_force * 0.9
				state = States.AIR
			move_and_fall(true)
		
		States.POSTDASH:
			var horizontal_direction = Input.get_axis("left" , "right")
			if horizontal_direction != 0:
				velocity.x = move_toward(velocity.x, speed * horizontal_direction, air_fric * _delta)
			else:
				velocity.x = move_toward(velocity.x, 0 ,air_fric * _delta)
			if horizontal_direction != 0:
				sprite.flip_h = (horizontal_direction == -1)
			orientation_fall()

func set_direction():
		direction = 1 if not sprite.flip_h else -1

func charge_and_fall():
	if velocity.y > 50:
		velocity.y = 50
	if velocity.x > 50:
		velocity.x = 50
	if velocity.x < -50:
		velocity.x = -50
	move_and_slide()

func orientation_fall():
	if !is_on_floor():
		velocity.y += gravity  
	if velocity.y > 1:
		velocity.y = 2
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

#blade state/functions
func fire():
	if can_blade: 
		var pos = $BladeStartPositions.get_children()[0].global_position
		var direction = (get_global_mouse_position() - position).normalized() 
		can_blade = false
		blade.emit(pos, direction)

func mfire():
	if can_blade: 
		can_blade = false
		var pos = $BladeStartPositions.get_children()[0].global_position
		var direction = (get_global_mouse_position() - position).normalized()
		blade.emit(pos, direction)

func cfire():
	if can_blade: 
		can_blade = false
		var pos = $BladeStartPositions.get_children()[0].global_position
		var direction = (get_global_mouse_position() - position).normalized()
		blade.emit(pos, direction)

func cblade():
	if Input.is_action_just_released("blade") && can_blade:
		$Timer.start()
	if $Timer.is_stopped():
		if is_on_floor():
			can_blade = true

func _on_predashtime_timeout():
	if Input.is_action_pressed("blade"):
		state = States.CHARGE
		$Charge.start()

func _on_charge_timeout():
	if Input.is_action_pressed("blade"):
		cfire()
	if not is_on_floor():
		state = States.AIR
	else:
		state = States.FLOOR

func _on_pdt_timeout():
	if not is_on_floor():
		state = States.AIR
	else:
		state = States.FLOOR
