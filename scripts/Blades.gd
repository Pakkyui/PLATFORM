extends Node2D

signal tele

func _on_blades_child_entered_tree():
	tele.emit()
