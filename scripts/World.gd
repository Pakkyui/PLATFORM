extends Node2D

var TBlade: PackedScene = preload("res://scenes/Tblade.tscn")

func _on_player_blade(pos, direction):
	var blade = TBlade.instantiate() as RigidBody2D
	blade.position = pos
	blade.rotation_degrees = rad_to_deg(direction.angle()) + 90
	blade.linear_velocity = direction * 900
	$Blades.add_child(blade)


func _on_blades_child_exiting_tree(node):
	var tele_position = get_node("Blades/Tblade").position
	$Player.global_position = tele_position



func _on_blades_child_entered_tree(node):
	Playerstats.can_blade = false
