extends CharacterBody2D


class_name Ground_Enemy
signal stack()
const speed = 150
var is_enemy_chase: bool

var health = 10
var health_max = 10
var health_min = 0 

var dead:bool = false
var taking_damage: bool = false
var damage_to_deal = 1
var is_dealing_damage: bool = false

var dir: Vector2
const gravity = 30
var knockback_force = 200
var is_roaming: bool = true

func _process(delta):
	if !is_on_floor():
		velocity.y += gravity * delta
		velocity.x = 0
	move(delta)
	move_and_fall(false)

func move(delta):
	if !dead:
		if !is_enemy_chase:
			velocity += dir * speed * delta
		is_roaming = true
	elif dead:
		velocity.x = 0

func _on_direction_timer_timeout():
	$DirectionTimer.wait_time = choose([1.5,2,2.5])
	if !is_enemy_chase:
		dir = choose ([Vector2.RIGHT, Vector2.LEFT])
		velocity.x = 0
	
func choose(array):
	array.shuffle()
	return array.front()
	
func move_and_fall(slow_fall: bool):
	if slow_fall:
		if velocity.y > 50:
			velocity.y = 50
	if !is_on_floor():  
		velocity.y += gravity 
		if velocity.y > 480:
			velocity.y = 725
	move_and_slide()
	


func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Tblade":
		print('hi')
