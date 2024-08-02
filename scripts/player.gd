extends CharacterBody2D
 
signal blade

var can_blade: bool = true

@export var speed = 150
@export var gravity = 30
@export var jump_force = 300 
@export var blade_force = 400

#@onready var ap = $AnimationPlayer
@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
const TBlade = preload("res://scenes/Blade.tscn")

#Input
func _physics_process(_delta):
	if !is_on_floor():  
		velocity.y += gravity
		if velocity.y > 1000:
			velocity.y = 1000
	
	if Input.is_action_just_pressed("jump"): #&& is_on_floor():
		velocity.y = -jump_force
	
	var horizontal_direction = Input.get_axis("left" , "right")
	velocity.x = speed * horizontal_direction
	if horizontal_direction != 0:
		sprite.flip_h = (horizontal_direction == -1)
	
	
	move_and_slide()
	fire()
	update_animations(horizontal_direction)

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
		var t = TBlade.instantiate()
		get_parent().add_child(t)
		t.position.y = position.y
		t.position.x = position.x
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
			
			



			
			
		
		

